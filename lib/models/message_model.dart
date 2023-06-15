import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

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
        .where((element) => element is! HiddenMessageModel)
        .toList()
        .reversed
        .map((e) => e.toMap())
        .toList();
  }

  static MessageModel generateMessageForTags(List<MessageModel> messages) {
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

class FileMessageModel extends MessageModel {
  FileMessageModel(
      {required this.file, required super.chatIndex, super.name, super.role})
      : super(msg: file.path.split('/').last);
  final File file;
  String _fileContentString = '';
  Future<String> get content async {
    if (_fileContentString.isEmpty) {
      final document = PdfDocument(inputBytes: file.readAsBytesSync());

      PdfTextExtractor extractor = PdfTextExtractor(document);

      String text = extractor.extractText().replaceAll('\n', '');
      if (text.split(' ').length > 3000)
        throw 'The document words must be less than 3000 words';
      return _fileContentString = text;
    } else {
      return _fileContentString;
    }
  }

  Future<String> get summerizePrompt async =>
      'Summerize the following pdf content:  ${await content}';
}

class HiddenMessageModel extends MessageModel {
  HiddenMessageModel(
      {required super.msg, required super.chatIndex, super.name, super.role});
}
