import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/models/message_model.dart';
import 'package:chatgpt/widgets/custom_chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TagDetailsDialog extends StatelessWidget {
  const TagDetailsDialog({super.key, required this.tagName});
  final String tagName;
  @override
  Widget build(BuildContext context) {
    final userMessage = MessageModel(
      msg: 'What is $tagName ?',
      chatIndex: 0,
    );
    return BlocProvider(
        create: (context) =>
            ConversationCubit(ChatModel(id: 1, chat_name: 'Query', model: ''))
              ..addUserMessage(msg: 'What is the $tagName meaining?')
              ..sendMessageAndGetAnswers(
                  msg: userMessage.msg, chosenModelId: 'gpt-3.5-turbo-0301'),
        child: ConversationBlocBuilder(
          builder: (context, state) {
            final conversationCubit = ConversationCubit.instance(context);
            final messages = conversationCubit.getMessages.reversed.toList();
            return Dialog(
              backgroundColor: scaffoldBackgroundColor,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (messages[index].chatIndex == 0)
                              SendChatBubble(message: messages[index]),
                            if (messages[index].chatIndex == 1)
                              RecieveChatBubble(message: messages[index]),
                            if (conversationCubit.isGeneratingAssitantMessage)
                              const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 18,
                              )
                          ],
                        );
                      },
                      itemCount: messages.length,
                      shrinkWrap: true)),
            );
          },
        ));
  }
}
