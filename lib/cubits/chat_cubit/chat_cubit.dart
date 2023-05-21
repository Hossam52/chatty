import 'dart:core';
import 'dart:developer';

import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/static/system_role_model.dart';
import 'package:chatgpt/screens/chat/chat_history_screen.dart';
import 'package:chatgpt/shared/network/services/app_services.dart';
import 'package:chatgpt/shared/network/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './chat_states.dart';

//Bloc builder and bloc consumer methods
typedef ChatBlocBuilder = BlocBuilder<ChatCubit, ChatStates>;
typedef ChatBlocConsumer = BlocConsumer<ChatCubit, ChatStates>;

//
class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(IntitalChatState());
  static ChatCubit instance(BuildContext context) =>
      BlocProvider.of<ChatCubit>(context);

  List<ChatModel> chatList = [];
  List<ChatHistoryModel> chatsHistory = [];
  List<ChatModel> tags = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void changeSystemRole(SystemRoleModel systemRoleModel) {
    chatList.insert(
        0,
        ChatModel(
            msg: systemRoleModel.generateContent(),
            chatIndex: 2,
            role: 'system',
            name: systemRoleModel.name));
    emit(ChangeChatPersona());
  }

  void addUserMessage({required String msg}) {
    chatList.insert(0, ChatModel(msg: msg, chatIndex: 0));
    emit(AddUserMessage());
  }

  Future<void> fetchAllChats() async {
    try {
      emit(FetchAllChatsLoadingState());
      final response = await AppServices.getAllChats();
      print(response);
      chatsHistory = (response['chats'] as List)
          .map((e) => ChatHistoryModel.fromJson(e))
          .toList();
      emit(FetchAllChatsSuccessState());
    } catch (e) {
      print(e.toString());
      emit(FetchAllChatsErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> fetchAllMessages(ChatHistoryModel chat) async {
    chatList.clear();
    try {
      emit(FetchAllMessagesLoadingState());
      final response = await AppServices.getAllMessages(chat.id);
      log(response.toString());
      chatList.insertAll(0, response);
      
      chat.chats.clear();
      chat.chats.addAll(chatList);
      emit(FetchAllMessagesSuccessState());
    } catch (e) {
      emit(FetchAllMessagesErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    try {
      emit(SendMessageLoadingState());

      if (chosenModelId.toLowerCase().startsWith("gpt")) {
        List<ChatModel> chs = [chatList[0]];
        final chats = await ChatServices.sendMessageGPT(
          previousChats: chatList,
          message: msg,
          modelId: chosenModelId,
        );
        chatList.insertAll(0, chats);
        chs.add(chats[0]);
        AppServices.sendMessage(3, chs);
        tags = await ChatServices.getConversationTags(
          chats: chatList,
          modelId: chosenModelId,
        );
      } else {
        chatList.insertAll(
            0,
            await ChatServices.sendMessage(
              message: msg,
              modelId: chosenModelId,
            ));
      }
      isGeneratingAssitantMessage = true;
      emit(SendMessageSuccessState());
    } catch (e) {
      isGeneratingAssitantMessage = false;
      emit(SendMessageErrorState(error: e.toString()));
      rethrow;
    }
  }

  ChatModel getChat(int index) {
    return chatList[index];
  }

  bool isGeneratingAssitantMessage = false;
  void changeToOld(int index) {
    chatList[index].changeToOld();
    isGeneratingAssitantMessage = false;
    emit(ChangeStatusToOld(index: index));
  }
}
