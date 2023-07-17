import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../models/message_model.dart';
import '../endpoints.dart';
import '../remote/app_dio_helper.dart';

class AppServices {
  AppServices._();
  static Future<Map<String, dynamic>> getHomeData() async {
    final response = await AppDioHelper.getData(
      url: EndPoints.home,
      token: Constants.token,
    );
    return response.data;
  }

  static Future<List<MessageModel>> getAllMessages(int chatId) async {
    final response = await AppDioHelper.getData(
      url: EndPoints.allMessages,
      query: {'chat': chatId},
      token: Constants.token,
    );
    final List messages = response.data['messages'];
    return messages.reversed.map((e) => MessageModel.fromJson(e)).toList();
  }

  static Future<Map<String, dynamic>> sendMessage(
      int chatId, int userId, String prompt, List<MessageModel> chats,
      {File? file}) async {
    final map = {
      'chat_id': chatId,
      'prompt': prompt,
      'last_messages': chats.map((e) {
        final map = e.toMap();
        map['index'] = e.chatIndex;
        return map;
      }).toList(),
    };
    final formData = FormData.fromMap(map);
    if (file == null && prompt.isEmpty)
      throw 'You don\'t enter the message yet';
    if (file != null)
      formData.files.add(MapEntry(
        'pdf',
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('application', 'pdf'),
        ),
      ));
    final res = await AppDioHelper.postFormData(
      url: EndPoints.sendMessage,
      formData: formData,
      token: Constants.token,
    );
    log(res.data.toString());
    return res.data;
  }

  static Future<Map<String, dynamic>> getAllChats(int userId) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.allchats, token: Constants.token, data: {});
    return response.data;
  }

  static Future<Map<String, dynamic>> createChat(
      String chatName, bool isChat) async {
    final response = await AppDioHelper.postData(
      url: EndPoints.createChat,
      data: {
        'name': chatName,
        'is_chat': isChat,
        'model': 'gpt03-turbo-0301',
      },
      token: Constants.token,
    );
    log(response.toString());
    return response.data;
  }

  static Future<Map<String, dynamic>> deleteChat(int chatId) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.deleteChat,
        token: Constants.token,
        data: {'chat_id': chatId});
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

  static Future<Map<String, dynamic>> getTags(int chatId) async {
    final response = await AppDioHelper.getData(
        url: EndPoints.allTags,
        token: Constants.token,
        query: {'chat_id': chatId});
    return response.data;
  }

  static Future<Map<String, dynamic>> tagInfo(String tag) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.tagInfo, token: Constants.token, data: {'tag': tag});
    return response.data;
  }
}
/**
 {chat_id: 9, prompt: h, last_messages: [{content: hello, role: user, index: 0}, {content: hello, role: user, index: 0}, {content: ehello, role: user, index: 0}, {content: hello, role: user, index: 0}, {content: Hello, role: user, index: 0}, {content: h, role: user, index: 0}]}
 */