import 'dart:developer';

import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/shared/network/endpoints.dart';
import 'package:chatgpt/shared/network/remote/app_dio_helper.dart';
import 'package:chatgpt/shared/network/remote/dio_helper.dart';

class AppServices {
  AppServices._();

  static Future<List<ChatModel>> getAllMessages(int chatId) async {
    final response = await AppDioHelper.getData(
        url: EndPoints.allMessages, query: {'chat': chatId});
    final List messages = response.data['messages'];
    return messages.reversed
        .map((e) => ChatModel(
            msg: e['content'], chatIndex: e['index'], role: e['role']))
        .toList();
  }

  static Future<void> sendMessage(int chatId, List<ChatModel> chats) async {
    final map = {
      'chat_id': chatId,
      'messages': chats.map((e) {
        final map = e.toMap();
        map['index'] = e.chatIndex;
        return map;
      }).toList(),
    };
    print(map.toString());

    await AppDioHelper.postData(url: EndPoints.sendMessage, data: map);
  }

  static Future<Map<String, dynamic>> getAllChats() async {
    final response = await AppDioHelper.getData(url: EndPoints.allchats);
    return response.data;
  }
}
