import 'package:chatgpt/models/message_model.dart';

class ChatModel {
  final int id;
  final String chat_name;
  final String model;
  List<MessageModel> messages = [];

  ChatModel({required this.id, required this.chat_name, required this.model});
  factory ChatModel.fromJson(Map<String, dynamic> map) => ChatModel(
      id: map['id'], chat_name: map['chat_name'], model: map['model']);
}
