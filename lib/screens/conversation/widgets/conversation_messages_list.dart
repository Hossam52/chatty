import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationMessagesList extends StatelessWidget {
  const ConversationMessagesList({super.key, required this.conversationCubit});
  final ConversationCubit conversationCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonasCubit, PersonasState>(
      builder: (context, state) {
        return ListView.builder(
            reverse: true,
            itemCount: conversationCubit.getMessages.length, //chatList.length,
            itemBuilder: (context, index) {
              return MessageWidget(
                message: conversationCubit.getMessages[index],
              );
            });
      },
    );
  }
}
