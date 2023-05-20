import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/chat_cubit/chat_cubit.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/services/assets_manager.dart';
import 'package:chatgpt/widgets/custom_chat_bubble.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.chatIndex,
  });
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    final ChatModel chatModel = ChatCubit.instance(context).getChat(chatIndex);
    log(chatModel.isNewly.toString());
    if (chatModel.chatIndex == 2) {
      return Row(
        children: [
          const Expanded(
              child: Divider(
            height: 1.5,
            thickness: 0.6,
            color: Colors.grey,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextWidget(
              label: 'Your role changed to ${chatModel.name}',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Expanded(
              child: Divider(
            height: 1.5,
            thickness: 0.6,
            color: Colors.grey,
          ))
        ],
      );
    }
    return Directionality(
      textDirection:
          chatModel.chatIndex == 0 ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          Material(
            color:
                chatModel.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    chatModel.chatIndex == 0
                        ? AssetsManager.userImage
                        : AssetsManager.botImage,
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: chatModel.chatIndex == 0
                        ? SendChatBubble(msg: chatModel.msg)
                        : RecieveChatBubble(
                            chatIndex: chatIndex,
                          ),
                  ),
                  chatModel.chatIndex == 0
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.thumb_down_alt_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
