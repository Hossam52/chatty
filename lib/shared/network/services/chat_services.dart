import 'dart:developer';

import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:chatgpt/shared/network/endpoints.dart';
import 'package:chatgpt/shared/network/remote/dio_chat.dart';

class ChatServices {
  static Future<List<ModelsModel>> getModels() async {
    final response = await DioChat.getData(EndPoints.models);

    return ModelsModel.modelsFromSnapshot(
        response.data['data'] as List<dynamic>);
  }

  static Future<List<ChatModel>> sendMessageGPT(
      {List<ChatModel> previousChats = const [],
      required String message,
      required String modelId}) async {
    log('Previous ${ChatModel.generatePreviousUserChats(previousChats)}');
    final response = await DioChat.postData(EndPoints.chatCompletionGPT, {
      "model": modelId,
      "messages": ChatModel.generatePreviousUserChats(previousChats),
    });
    log({
      "model": modelId,
      "messages": ChatModel.generatePreviousUserChats(previousChats),
    }.toString());
    List<ChatModel> chatList = [];
    if (response.data["choices"].length > 0) {
      chatList = List.generate(
        response.data["choices"].length,
        (index) => ChatModel.fromJson(
          response.data["choices"][index]["message"],
        ),
      );
    }
    return chatList;
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    final response = await DioChat.postData(
      EndPoints.chatCompletion,
      {
        "model": modelId,
        "prompt": message,
        "max_tokens": 300,
      },
    );
    log(response.data.toString());
    List<ChatModel> chatList = [];
    if (response.data["choices"].length > 0) {
      chatList = List.generate(
        response.data["choices"].length,
        (index) => ChatModel(
            msg: response.data["choices"][index]["text"],
            role: 'assistant',
            chatIndex: 1,
            isNewly: true),
      );
    }
    return chatList;
  }

  static Future<List<ChatModel>> getConversationTags(
      {required List<ChatModel> chats, required String modelId}) async {
    final response = await DioChat.postData(EndPoints.chatCompletionGPT, {
      "model": modelId,
      "max_tokens": 20,
      "frequency_penalty": 1,
      "presence_penalty": 0,
      "n": 10,
      "messages": [
        ChatModel(
                msg: 'you act like an keyword extractor',
                chatIndex: 2,
                role: 'system')
            .toMap(),
        ...ChatModel.generatePreviousUserChats(chats),
        ChatModel(
                msg:
                    'generate one keyword in message without any leading words',
                chatIndex: 1,
                role: 'user')
            .toMap()
      ],
    });
    List<ChatModel> chatList = [];
    if (response.data["choices"].length > 0) {
      chatList = List.generate(
        response.data["choices"].length,
        (index) => ChatModel.fromJson(
          response.data["choices"][index]["message"],
        ),
      );
    }
    return chatList;
  }
}
