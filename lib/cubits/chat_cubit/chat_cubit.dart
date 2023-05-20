import 'dart:developer';

import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/static/system_role_model.dart';
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

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    try {
      emit(SendMessageLoadingState());

      if (chosenModelId.toLowerCase().startsWith("gpt")) {
        chatList.insertAll(
            0,
            await ChatServices.sendMessageGPT(
              previousChats: chatList,
              message: msg,
              modelId: chosenModelId,
            ));
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
