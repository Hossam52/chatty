import 'dart:core';
import 'dart:developer';

import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/models/message_model.dart';
import 'package:chatgpt/models/static/system_role_model.dart';
import 'package:chatgpt/screens/chat/chat_history_screen.dart';
import 'package:chatgpt/shared/network/services/app_services.dart';
import 'package:chatgpt/shared/network/services/chat_services.dart';
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
  int _untrackedMessages = 0;
  String get conversationTags {
    if (_tags.isEmpty) return '';
    return _tags[0]
        .msg
        .toLowerCase()
        .replaceAll(RegExp(r'keyword|:|\n'), '')
        .replaceAll(RegExp(r'\d.'), ' - ');
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

  void addUserMessage({required String msg}) {
    chat.messages.insert(0, MessageModel(msg: msg, chatIndex: 0));
    _untrackedMessages++;
    emit(AddUserMessage());
  }

  Future<void> fetchAllMessages() async {
    chat.messages.clear();
    try {
      emit(FetchAllMessagesLoadingState());
      final response = await AppServices.getAllMessages(chat.id);
      log(response.toString());
      chat.messages.insertAll(0, response);

      emit(FetchAllMessagesSuccessState());
    } catch (e) {
      emit(FetchAllMessagesErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    try {
      isGeneratingAssitantMessage = true;

      emit(SendMessageLoadingState());

      if (chosenModelId.toLowerCase().startsWith("gpt")) {
        final chats = await ChatServices.sendMessageGPT(
          previousChats: chat.messages,
          message: msg,
          modelId: chosenModelId,
        );
        chat.messages.insertAll(0, chats);
        _untrackedMessages += chats.length;

        AppServices.sendMessage(
            chat.id,
            chat.messages
                .getRange(0, _untrackedMessages)
                .toList()
                .reversed
                .toList());
        _untrackedMessages = 0;
        _tags = await ChatServices.getConversationTags(
          messages: chat.messages,
          modelId: chosenModelId,
        );
      } else {
        chat.messages.insertAll(
            0,
            await ChatServices.sendMessage(
              message: msg,
              modelId: chosenModelId,
            ));
      }
      emit(SendMessageSuccessState());
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
