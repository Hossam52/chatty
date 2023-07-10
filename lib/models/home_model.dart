import 'dart:convert';

import 'package:chatgpt/models/auth/user_model.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/models/prompts/prompts_map.dart';

class HomeModel {
  String contact_email;
  String facebook_link;
  User user;
  List<PromptItem> prompts;
  List<ChatModel> chats;
  List<ChatModel> chats_prompts;
  HomeModel({
    required this.contact_email,
    required this.facebook_link,
    required this.user,
    required this.prompts,
    required this.chats,
    required this.chats_prompts,
  });

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      user: User.fromMap(map),
      prompts: List<PromptItem>.from(
          map['prompts']?.map((x) => PromptItem.fromMap(x))),
      chats:
          List<ChatModel>.from(map['chats']?.map((x) => ChatModel.fromJson(x))),
      chats_prompts: List<ChatModel>.from(
          map['chats_prompts']?.map((x) => ChatModel.fromJson(x))),
      contact_email: map['contact_email'] ?? '',
      facebook_link: map['facebook_link'] ?? '',
    );
  }

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source));

  void addChat(ChatModel chat) {
    if (chat.isChat)
      chats.add(chat);
    else
      chats_prompts.add(chat);
  }
}
