import 'message_model.dart';

class ChatModel {
  final int id;
  final int user_id;
  final String chat_name;
  final String model;
  final bool isChat;
  List<MessageModel> messages = [];

  ChatModel(
      {required this.id,
      required this.user_id,
      required this.chat_name,
      required this.model,
      this.isChat = true});
  factory ChatModel.fromJson(Map<String, dynamic> map) => ChatModel(
      id: map['id'],
      user_id: map['user_id'],
      chat_name: map['chat_name'],
      model: map['model'],
      isChat: map['is_chat']);
}
