import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/models/message_model.dart';
import 'package:chatgpt/providers/chats_provider.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:provider/provider.dart';

class _CustomChatBubble extends StatelessWidget {
  const _CustomChatBubble(
      {super.key, required this.child, required this.bubbleType, this.color});
  final Widget child;
  final BubbleType bubbleType;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper4(type: bubbleType),
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      backGroundColor: color,
      child: Container(
        constraints: BoxConstraints(
          minWidth: bubbleType == BubbleType.sendBubble
              ? 0
              : MediaQuery.of(context).size.width * 0.7,
          // maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: child,
      ),
    );
  }
}

class SendChatBubble extends StatelessWidget {
  const SendChatBubble({super.key, required this.message});
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return _CustomChatBubble(
      bubbleType: BubbleType.sendBubble,
      color: sendColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(message.msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const SizedBox(width: 10),
          if (message is FileMessageModel)
            const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class RecieveChatBubble extends StatelessWidget {
  const RecieveChatBubble({super.key, required this.message});
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    final chatCubit = ConversationCubit.instance(context);
    return _CustomChatBubble(
      bubbleType: BubbleType.receiverBubble,
      color: recieveColor,
      child: message.isNewly
          ? AnimatedTextKit(
              isRepeatingAnimation: false,
              repeatForever: false,
              displayFullTextOnTap: true,
              totalRepeatCount: 1,
              onTap: () {
                chatCubit.changeToOld();
              },
              onFinished: () {
                chatCubit.changeToOld();
              },
              animatedTexts: [
                  TyperAnimatedText(
                    message.msg.trim(),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ])
          : Text(
              message.msg.trim(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
    );
  }
}
