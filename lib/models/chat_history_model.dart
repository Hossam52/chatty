import 'package:chatgpt/models/chat_model.dart';

class ChatHistoryModel {
  final int id;
  final String chat_name;
  final String model;
  List<ChatModel> chats = [];

  ChatHistoryModel(
      {required this.id, required this.chat_name, required this.model});
  factory ChatHistoryModel.fromJson(Map<String, dynamic> map) =>
      ChatHistoryModel(
          id: map['id'], chat_name: map['chat_name'], model: map['model']);
}
