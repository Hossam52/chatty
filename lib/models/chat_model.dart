import 'dart:convert';
import 'dart:developer';

class ChatModel {
  final String msg;
  final int chatIndex;
  final String role;
  bool isNewly;
  String name;

  ChatModel(
      {required this.msg,
      required this.chatIndex,
      this.role = 'user',
      this.name = '',
      this.isNewly = false});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      msg: json["content"],
      chatIndex: 1,
      role: json['role'],
      isNewly: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': msg,
      'role': role,
    };
  }

  void changeToOld() {
    isNewly = false;
  }

  static List<Map<String, dynamic>> generatePreviousUserChats(
      List<ChatModel> chats) {
    int systemIndex = chats.indexWhere((element) => element.role == 'system');
    return chats
        .getRange(0, systemIndex + 1)
        .toList()
        .reversed
        .map((e) => e.toMap())
        .toList();
    return chats
        .map(
          (e) {
            log(e.role);
            return e.toMap();
          },
        )
        .toList()
        .reversed
        .toList();
  }

  ChatModel copyWith({
    String? msg,
    int? chatIndex,
    String? role,
    bool? isNewly,
  }) {
    return ChatModel(
      msg: msg ?? this.msg,
      chatIndex: chatIndex ?? this.chatIndex,
      role: role ?? this.role,
      isNewly: isNewly ?? this.isNewly,
    );
  }
}
