import '../constants/constants.dart';
import '../cubits/conversation_cubit/conversation_cubit.dart';
import '../models/message_model.dart';
import '../shared/presentation/resourses/assets_manager.dart';
import '../shared/presentation/resourses/color_manager.dart';
import 'custom_chat_bubble.dart';
import 'text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                            chatCubit: ConversationCubit.instance(context),
                          ),
                  ),
                  message.chatIndex == 0
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () async {
                            try {
                              await Clipboard.setData(
                                  ClipboardData(text: message.msg));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Copied successfully')));
                            } catch (e) {}
                          },
                          icon: Icon(
                            FontAwesomeIcons.copy,
                            color: ColorManager.white.withOpacity(0.8),
                          ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
