import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:chatgpt/models/conversation_tags_model.dart';

import '../../models/chat_history_model.dart';
import '../../models/message_model.dart';
import '../../models/static/system_role_model.dart';
import '../../shared/network/services/app_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'conversation_states.dart';

//Bloc builder and bloc consumer methods
typedef ConversationBlocBuilder
    = BlocBuilder<ConversationCubit, ConversationStates>;
typedef ConversationBlocConsumer
    = BlocConsumer<ConversationCubit, ConversationStates>;

//
class ConversationCubit extends Cubit<ConversationStates> {
  ConversationCubit(this.chat) : super(IntitalChatState());
  static ConversationCubit instance(BuildContext context) =>
      BlocProvider.of<ConversationCubit>(context);

  ChatModel chat;
  ConversationTagsModel? _tags;
  List<String> get allTags => _tags?.tags ?? [];
  List<MessageModel> _tempMessages = [];

  List<MessageModel> get getMessages => chat.messages;

  void changeSystemRole(SystemRoleModel systemRoleModel) {
    final message = MessageModel(
        msg: systemRoleModel.generateContent(),
        chatIndex: 2,
        role: 'system',
        name: systemRoleModel.name);
    chat.messages.insert(0, message);
    _tempMessages.insert(0, message);
    emit(ChangeChatPersona());
  }

  void addUserMessage({required String msg}) {
    chat.messages.insert(0, MessageModel(msg: msg, chatIndex: 0));
    emit(AddUserMessage());
  }

  void addFileMessage({required File file}) async {
    try {
      final message = FileMessageModel.withFile(file: file, chatIndex: 0);
      await message.content;
      chat.messages.insert(0, message);
      isGeneratingAssitantMessage = true;
      emit(SendMessageLoadingState());
      final response = await AppServices.sendMessage(
          chat.id, chat.user_id, '', [],
          file: file);
      final messageContent =
          MessageModel.fromJson(response['message'], isNew: true);
      chat.messages.insert(0, messageContent);
      emit(SendMessageSuccessState(1));
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
    } finally {
      isGeneratingAssitantMessage = false;
    }
  }

  Future<void> fetchAllMessages() async {
    chat.messages.clear();
    try {
      emit(FetchAllMessagesLoadingState());
      final response = await AppServices.getAllMessages(chat.id);
      chat.messages.insertAll(0, response);

      emit(FetchAllMessagesSuccessState());
    } catch (e) {
      emit(FetchAllMessagesErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> sendMessage(String prompt) async {
    try {
      isGeneratingAssitantMessage = true;
      emit(SendMessageLoadingState());
      final response = await AppServices.sendMessage(
          chat.id, chat.user_id, prompt, _tempMessages.reversed.toList());
      final message = MessageModel.fromJson(response['message'], isNew: true);
      chat.messages.insert(0, message);
      emit(SendMessageSuccessState(1));
      _tempMessages.clear();
      getTags();
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
      rethrow;
    } finally {
      isGeneratingAssitantMessage = false;
    }
  }

  Future<void> getTags() async {
    try {
      emit(GetTagsLoadingState());
      final response = await AppServices.getTags(chat.id);
      print(response.toString());
      _tags = ConversationTagsModel.fromMap(response);
      emit(GetTagsSuccessState());
    } catch (e) {
      emit(GetTagsErrorState(error: e.toString()));
      rethrow;
    }
  }

  bool isGeneratingAssitantMessage = false;
  void changeToOld() {
    for (var element in chat.messages) {
      if (element.isNewly) element.changeToOld();
    }
    emit(ChangeStatusToOld(index: chat.messages.length - 1));
  }
}

typedef TagsConversationQueryiesBlocBuilder
    = BlocBuilder<TagsConversationQueryiesCubit, ConversationStates>;

class TagsConversationQueryiesCubit extends ConversationCubit {
  TagsConversationQueryiesCubit(super.chat);
  static ConversationCubit instance(BuildContext context) =>
      BlocProvider.of<TagsConversationQueryiesCubit>(context);

  Future<void> getTagInformation(String tag) async {
    try {
      isGeneratingAssitantMessage = true;
      emit(SendMessageLoadingState());
      final response = await AppServices.tagInfo(tag);
      final message = MessageModel.fromJson(response['message'], isNew: true);
      chat.messages.insert(0, message);
      emit(SendMessageSuccessState(1));
      _tempMessages.clear();
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
    } finally {
      isGeneratingAssitantMessage = false;
    }
  }
}
