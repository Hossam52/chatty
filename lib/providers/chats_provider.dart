import 'package:chatgpt/shared/network/services/chat_services.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.insert(0, ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.insertAll(
          0,
          await ChatServices.sendMessageGPT(
            message: msg,
            modelId: chosenModelId,
          ));
    } else {
      chatList.insertAll(
          0,
          await ChatServices.sendMessage(
            message: msg,
            modelId: chosenModelId,
          ));
    }
    notifyListeners();
  }

  ChatModel getChat(int index) {
    return chatList[index];
  }

  void changeToOld(int index) {
    chatList[index].changeToOld();
    notifyListeners();
  }
}
