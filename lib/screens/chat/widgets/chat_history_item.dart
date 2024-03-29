import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/screens/chat/widgets/delete_chat_dialog.dart';
import 'package:chatgpt/screens/conversation/conversation_screen.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatHistoryItem extends StatelessWidget {
  const ChatHistoryItem({
    super.key,
    required this.chat,
  });

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        color: ColorManager.accentColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: AppCubit.instance(context),
              child: ConversationScreen(
                appCubit: AppCubit.instance(context),
                chat: chat,
              ),
            ),
          ));
        },
        onLongPress: () async {
          final res = await showDialog<bool?>(
              context: context, builder: (context) => DeleteChatDialog());
          if (res != null && res) {
            AppCubit.instance(context).deleteChat(chat);
          }
        },
        child: Row(
          children: [
            TextWidget(
              label: chat.chat_name,
              fontSize: FontSize.s14,
            ),
          ],
        ),
      ),
    );
  }
}
