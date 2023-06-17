import 'dart:async';
import 'dart:core';
import 'dart:developer' as developer;
import 'dart:io';

import '../../models/chat_history_model.dart';
import '../../models/message_model.dart';
import '../../models/static/system_role_model.dart';
import '../../shared/network/services/app_services.dart';
import '../../shared/network/services/chat_services.dart';
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
  List<MessageModel> _tags = [];
  List<String> tagsStrings = [];

  int _untrackedMessages = 0;

  void formatTags() {
    if (_tags.isEmpty) return;
    tagsStrings = _tags[0]
        .msg
        .toLowerCase()
        .replaceAll(RegExp(r'keyword|:|\n'), '')
        .replaceAll(RegExp(r'(\d)+.|,'), ' - ')
        .split('-');
    tagsStrings.removeWhere(
        (element) => element.trim().isEmpty || element.length == 2);
  }

  List<MessageModel> get getMessages => chat.messages;

  void changeSystemRole(SystemRoleModel systemRoleModel) {
    chat.messages.insert(
        0,
        MessageModel(
            msg: systemRoleModel.generateContent(),
            chatIndex: 2,
            role: 'system',
            name: systemRoleModel.name));
    _untrackedMessages++;
    emit(ChangeChatPersona());
  }

  void addUserMessage({required String msg, String? alteranteText}) {
    if (alteranteText == null) {
      chat.messages.insert(0, MessageModel(msg: msg, chatIndex: 0));
    } else {
      chat.messages.insert(0, MessageModel(msg: msg, chatIndex: 0));
      // chat.messages.insert(0, HiddenMessageModel(msg: msg, chatIndex: 0));
    }
    _untrackedMessages++;
    emit(AddUserMessage());
  }

  void addFileMessage({required File file}) async {
    try {
      isGeneratingAssitantMessage = true;
      emit(AddUserMessage());
      final message = FileMessageModel(file: file, chatIndex: 0);
      await message.content;
      chat.messages.insert(0, message);

      _untrackedMessages++;
      emit(AddUserMessage());

      await _summerizeFile(message);
    } catch (e) {
      emit(ErrorAddUserFileMessage(e.toString()));
    } finally {
      isGeneratingAssitantMessage = false;
    }
  }

  Future<void> _summerizeFile(FileMessageModel message) async {
    try {
      developer.log(await message.content);
      emit(SummerizeFileLoadingState());
      final summery = await ChatServices.sendMessageGPT(previousChats: [
        MessageModel(msg: await message.summerizePrompt, chatIndex: 0)
      ], message: await message.summerizePrompt, modelId: 'gpt-3.5-turbo-0301');

      chat.messages
          .insert(0, HiddenMessageModel(msg: summery[0].msg, chatIndex: 0));
      chat.messages.insert(0, summery[0]);
      emit(SummerizeFileSuccessState());
    } catch (e) {
      emit(SummerizeFileErrorState(error: e.toString()));
    }
  }

  Future<void> fetchAllMessages() async {
    chat.messages.clear();
    try {
      emit(FetchAllMessagesLoadingState());
      final response = await AppServices.getAllMessages(chat.id);
      developer.log(response.toString());
      chat.messages.insertAll(0, response);

      emit(FetchAllMessagesSuccessState());
    } catch (e) {
      emit(FetchAllMessagesErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> _baseSendMessage(String chosenModelId, int userId) async {
    // AppServices.sendMessage(
    //     chat.id,
    //     userId,
    //     chat.messages
    //         .getRange(0, _untrackedMessages)
    //         .toList()
    //         .reversed
    //         .toList());

    // _tags = await ChatServices.getConversationTags(
    //   messages: chat.messages,
    //   modelId: chosenModelId,
    // );
    // formatTags();

    emit(SendMessageSuccessState(_untrackedMessages));
    _untrackedMessages = 0;
  }

  Future<void> sendMessageViaChatGPT(
      {required String msg,
      required String chosenModelId,
      required int userId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      final chats = await ChatServices.sendMessageGPT(
        previousChats: chat.messages,
        message: msg,
        modelId: chosenModelId,
      );
      chat.messages.insertAll(0, chats);
      _untrackedMessages += chats.length;
    } else {
      chat.messages.insertAll(
          0,
          await ChatServices.sendMessage(
            message: msg,
            modelId: chosenModelId,
          ));
    }
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg,
      required String chosenModelId,
      required int userId}) async {
    try {
      isGeneratingAssitantMessage = true;

      emit(SendMessageLoadingState());
      await sendMessageViaChatGPT(
          chosenModelId: chosenModelId, userId: userId, msg: msg);
      await _baseSendMessage(chosenModelId, userId);
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
      rethrow;
    } finally {
      isGeneratingAssitantMessage = false;
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

  @override
  Future<void> sendMessageAndGetAnswers(
      {required String msg,
      required String chosenModelId,
      required int userId}) async {
    try {
      isGeneratingAssitantMessage = true;

      emit(SendMessageLoadingState());
      await sendMessageViaChatGPT(
          chosenModelId: chosenModelId, userId: userId, msg: msg);
      emit(SendMessageSuccessState(1));
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
      rethrow;
    } finally {
      isGeneratingAssitantMessage = false;
    }
  }
}
