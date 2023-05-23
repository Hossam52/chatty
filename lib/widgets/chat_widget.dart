import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/models/message_model.dart';
import 'package:chatgpt/services/assets_manager.dart';
import 'package:chatgpt/widgets/custom_chat_bubble.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
  });
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    if (message.chatIndex == 2) {
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
              label: 'Your role changed to ${message.name}',
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
    if (message is HiddenMessageModel) return const SizedBox.shrink();

    return Directionality(
      textDirection:
          message.chatIndex == 0 ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          Material(
            color: message.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    message.chatIndex == 0
                        ? AssetsManager.userImage
                        : AssetsManager.botImage,
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: message.chatIndex == 0
                        ? SendChatBubble(message: message)
                        : RecieveChatBubble(
                            message: message,
                          ),
                  ),
                  message.chatIndex == 0
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
