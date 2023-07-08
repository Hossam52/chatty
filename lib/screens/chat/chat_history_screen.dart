import 'package:flutter/material.dart';

import 'package:chatgpt/screens/chat/widgets/base_chat_history.dart';

import '../../cubits/app_cubit/app_cubit.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder(
      builder: (context, state) {
        final appCubit = AppCubit.instance(context);
        return BaseChatHistory(
          chats: appCubit.allChats,
          title: 'Chat history',
        );
      },
    );
  }
}

class ChatPromptsHistory extends StatelessWidget {
  const ChatPromptsHistory({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder(
      builder: (context, state) {
        final appCubit = AppCubit.instance(context);
        return BaseChatHistory(
          chats: appCubit.allChatsPrompts,
          title: 'Prompts history',
        );
      },
    );
  }
}
