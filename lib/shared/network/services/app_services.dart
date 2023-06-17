import 'dart:developer';

import '../../../constants/constants.dart';
import '../../../models/message_model.dart';
import '../endpoints.dart';
import '../remote/app_dio_helper.dart';

class AppServices {
  AppServices._();

  static Future<List<MessageModel>> getAllMessages(int chatId) async {
    final response = await AppDioHelper.getData(
      url: EndPoints.allMessages,
      query: {'chat': chatId},
      token: Constants.token,
    );
    log(response.data.toString());
    final List messages = response.data['messages'];
    return messages.reversed
        .map((e) => MessageModel(
            msg: e['content'], chatIndex: e['index'], role: e['role']))
        .toList();
  }

  static Future<void> sendMessage(
      int chatId, int userId, List<MessageModel> chats) async {
    final map = {
      'chat_id': chatId,
      'messages': chats.map((e) {
        final map = e.toMap();
        map['index'] = e.chatIndex;
        return map;
      }).toList(),
    };

    await AppDioHelper.postData(
      url: EndPoints.sendMessage,
      data: map,
      token: Constants.token,
    );
  }

  static Future<Map<String, dynamic>> getAllChats(int userId) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.allchats, token: Constants.token, data: {});
    return response.data;
  }

  static Future<Map<String, dynamic>> createChat(String chatName) async {
    final response = await AppDioHelper.postData(
      url: EndPoints.createChat,
      data: {
        'name': chatName,
        'model': 'gpt03-turbo-0301',
      },
      token: Constants.token,
    );
    log(response.toString());
    return response.data;
  }

  static Future<Map<String, dynamic>> getPrompts() async {
    final response = await AppDioHelper.getData(
      url: EndPoints.prompts,
      token: null,
    );
    return response.data;
  }

  static Future<Map<String, dynamic>> claimAdReward() async {
    final response = await AppDioHelper.postData(
        url: EndPoints.adReward, token: Constants.token, data: {});
    return response.data;
  }
}
