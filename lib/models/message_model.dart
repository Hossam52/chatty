import 'dart:developer';
import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class MessageModel {
  final String msg;
  final int chatIndex;
  final String role;
  final int? type_id;
  final String? slug;
  bool isNewly;
  String name;

  MessageModel(
      {required this.msg,
      required this.chatIndex,
      this.role = 'user',
      this.type_id,
      this.slug,
      this.name = '',
      this.isNewly = false});

  factory MessageModel.fromJson(Map<String, dynamic> json,
      {bool isNew = false}) {
    int? typeId = json['type_id'];
    String? slug = json['slug'];
    log(typeId.toString());
    if (typeId != null && typeId == 2) {
      return FileMessageModel.fromJson(json);
    }

    return MessageModel(
      msg: json["content"],
      chatIndex: json['index'],
      role: json['role'],
      slug: slug,
      type_id: typeId,
      isNewly: isNew,
      name: json['index'] == 2 ? json['slug'] : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': msg,
      'role': role,
      'slug': chatIndex == 2 ? name : slug,
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
  FileMessageModel.withFile(
      {required this.file, required super.chatIndex, super.name, super.role})
      : super(msg: file.path.split('/').last);
  FileMessageModel(
      {required super.msg,
      required super.chatIndex,
      super.name,
      super.role,
      super.type_id,
      super.slug});
  late File file;
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
  factory FileMessageModel.fromJson(Map<String, dynamic> json) {
    int? typeId = json['type_id'];
    String? slug = json['slug'];

    return FileMessageModel(
        msg: slug ?? '',
        chatIndex: json['index'],
        role: json['role'],
        type_id: typeId,
        slug: slug);
  }
}

class HiddenMessageModel extends MessageModel {
  HiddenMessageModel(
      {required super.msg, required super.chatIndex, super.name, super.role});
}
