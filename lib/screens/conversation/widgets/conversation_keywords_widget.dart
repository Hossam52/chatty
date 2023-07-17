import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/widgets/chat_dialogs/tag_details_dialog.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ConversationKeywordsWidget extends StatelessWidget {
  const ConversationKeywordsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: ConversationBlocBuilder(
          builder: (context, state) {
            final conversationCubit = ConversationCubit.instance(context);
            return Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const TextWidget(label: 'Keywords: ', fontSize: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10,
                        children: conversationCubit.allTags
                            .map((e) => OutlinedButton(
                                  style: const ButtonStyle(
                                      side: MaterialStatePropertyAll(BorderSide(
                                        color: Colors.white,
                                      )),
                                      padding: MaterialStatePropertyAll(
                                        EdgeInsets.all(1),
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  child: TextWidget(
                                    label: e,
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            TagDetailsDialog(tagName: e));
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
