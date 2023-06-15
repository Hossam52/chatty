import 'dart:developer';

import '../../../models/message_model.dart';
import '../../../models/models_model.dart';
import '../endpoints.dart';
import '../remote/dio_chat.dart';

class ChatServices {
  static Future<List<ModelsModel>> getModels() async {
    final response = await DioChat.getData(EndPoints.models);

    return ModelsModel.modelsFromSnapshot(
        response.data['data'] as List<dynamic>);
  }

  static Future<List<MessageModel>> sendMessageGPT(
      {List<MessageModel> previousChats = const [],
      required String message,
      required String modelId}) async {
    final response = await DioChat.postData(EndPoints.chatCompletionGPT, {
      "model": modelId,
      "messages": MessageModel.generatePreviousMessages(previousChats),
    });
    List<MessageModel> chatList = [];
    if (response.data["choices"].length > 0) {
      chatList = List.generate(
        response.data["choices"].length,
        (index) => MessageModel.fromJson(
          response.data["choices"][index]["message"],
        ),
      );
    }
    return chatList;
  }

  static Future<List<MessageModel>> sendMessage(
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
    List<MessageModel> chatList = [];
    if (response.data["choices"].length > 0) {
      chatList = List.generate(
        response.data["choices"].length,
        (index) => MessageModel(
            msg: response.data["choices"][index]["text"],
            role: 'assistant',
            chatIndex: 1,
            isNewly: true),
      );
    }
    return chatList;
  }

  static Future<List<MessageModel>> getConversationTags(
      {required List<MessageModel> messages, required String modelId}) async {
    final response = await DioChat.postData(EndPoints.chatCompletionGPT, {
      "model": modelId,
      "max_tokens": 100,
      "messages": [
        MessageModel.generateMessageForTags(messages).toMap(),
      ],
    });
    List<MessageModel> chatList = [];
    if (response.data["choices"].length > 0) {
      chatList = List.generate(
        response.data["choices"].length,
        (index) => MessageModel.fromJson(
          response.data["choices"][index]["message"],
        ),
      );
    }
    return chatList;
  }
}
/*
 Extract keywords from this text conversation between system, user and assistant (AI chatgpt):
 user: hello
 AI: Hello, How can I help you today?
 user: Help me to do my homework in math in grade 4.
 AI: sure, provide me the questions and i'll answer.
 */