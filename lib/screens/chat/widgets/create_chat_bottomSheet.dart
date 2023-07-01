import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CreateChatBottomSheet extends StatefulWidget {
  const CreateChatBottomSheet({super.key, required this.appCubit});

  final AppCubit appCubit;
  @override
  State<CreateChatBottomSheet> createState() => CreateChatBottomSheetState();
}

class CreateChatBottomSheetState extends State<CreateChatBottomSheet> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(child: TextWidget(label: 'Chat name: ')),
                Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(
                          filled: true, fillColor: Colors.white30),
                      controller: controller,
                    ))
              ],
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
                onPressed: () {
                  widget.appCubit.addNewChat(controller.text);
                },
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: const TextWidget(
                  label: 'Save and create',
                ))
          ],
        ),
      ),
    );
  }
}
