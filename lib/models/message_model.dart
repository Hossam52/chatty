import 'dart:convert';
import 'dart:developer';
import 'dart:math';

class MessageModel {
  final String msg;
  final int chatIndex;
  final String role;
  bool isNewly;
  String name;

  MessageModel(
      {required this.msg,
      required this.chatIndex,
      this.role = 'user',
      this.name = '',
      this.isNewly = false});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
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

  static List<Map<String, dynamic>> generatePreviousMessages(
      List<MessageModel> messages) {
    int systemIndex =
        messages.indexWhere((element) => element.role == 'system');
    if (systemIndex == -1) systemIndex = messages.length - 1;
    return messages
        .getRange(0, systemIndex + 1)
        .toList()
        .reversed
        .map((e) => e.toMap())
        .toList();
  }

  static MessageModel generateMessageForTags(List<MessageModel> messages) {
    final range = messages.getRange(0, min(10, messages.length));
    String prompt =
        "Extract up to 10 in one line keywords from this conversation between system,user and assistant(AI chatgpt)\n";
    for (var element in messages) {
      prompt += '${element.role}: ${element.msg}\n';
    }
    return MessageModel(msg: prompt, chatIndex: 1, role: 'user');
  }

  MessageModel copyWith({
    String? msg,
    int? chatIndex,
    String? role,
    bool? isNewly,
  }) {
    return MessageModel(
      msg: msg ?? this.msg,
      chatIndex: chatIndex ?? this.chatIndex,
      role: role ?? this.role,
      isNewly: isNewly ?? this.isNewly,
    );
  }
}
