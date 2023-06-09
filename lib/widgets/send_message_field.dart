import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessageField extends StatefulWidget {
  const SendMessageField({super.key});

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final conversationCubit = ConversationCubit.instance(context);
    return Material(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                focusNode: focusNode,
                controller: textEditingController,
                onSubmit: (value) async {
                  await sendMessageFCT(
                      modelsProvider: modelsProvider,
                      chatCubit: conversationCubit);
                },
                hint: 'How can I help you',
                borderColor: ColorManager.white,
                // decoration: const InputDecoration.collapsed(
                //     hintText: "How can I help you",
                //     hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            IconButton(
                onPressed: () async {
                  final response = await FilePicker.platform.pickFiles(
                      dialogTitle: 'Select file',
                      allowedExtensions: ['pdf'],
                      type: FileType.custom);
                  if (response == null) return;
                  final selectedFile = File(response.files.single.path!);
                  conversationCubit.addFileMessage(file: selectedFile);
                },
                icon: const Icon(
                  Icons.attach_file_sharp,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () async {
                  await sendMessageFCT(
                      modelsProvider: modelsProvider,
                      chatCubit: conversationCubit);
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ConversationCubit chatCubit}) async {
    if (chatCubit.isGeneratingAssitantMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;

      textEditingController.clear();
      focusNode.unfocus();

      chatCubit.addUserMessage(msg: msg);
      await chatCubit.sendMessageAndGetAnswers(
          userId: AppCubit.instance(context).currentUser.id,
          msg: msg,
          chosenModelId: modelsProvider.getCurrentModel);
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
}
