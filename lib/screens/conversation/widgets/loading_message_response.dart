import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingMessageResponse extends StatelessWidget {
  const LoadingMessageResponse({
    super.key,
    required this.conversationCubit,
  });

  final ConversationCubit conversationCubit;

  @override
  Widget build(BuildContext context) {
    if (conversationCubit.isGeneratingAssitantMessage) {
      return const SpinKitThreeBounce(
        color: Colors.white,
        size: 18,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
