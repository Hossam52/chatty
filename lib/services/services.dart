import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/shared/methods.dart';

import '../cubits/conversation_cubit/conversation_cubit.dart';
import '../cubits/personas_cubit/personas_cubit.dart';
import '../widgets/personas/personas_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> sendMessage(
      {required BuildContext context,
      required String text,
      String? alternateText,
      void Function()? onSendMessage}) async {
    final chatCubit = ConversationCubit.instance(context);
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
    if (text.isEmpty) {
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
    if (!AppCubit.instance(context).currentUser.canSendMessage) {
      Methods.showSnackBar(context,
          'You excceed the quota limit go to settings to add more messages');
      return;
    }
    try {
      String msg = text;
      if (onSendMessage != null) {
        onSendMessage();
      }

      chatCubit.addUserMessage(msg: msg, alteranteText: alternateText);
      await chatCubit.sendMessageAndGetAnswers(
          userId: AppCubit.instance(context).currentUser.id,
          msg: msg,
          chosenModelId: 'gpt-3.5-turbo-0301');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  static Widget roleSelection(BuildContext context) {
    return BlocProvider.value(
      value: ConversationCubit.instance(context),
      child: PersonasBlocBuilder(builder: (context, state) {
        return const Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const _CustomRow(
              //   label: 'Chosen Model:',
              //   child: ModelsDrowDownWidget(),
              // ),
              _CustomRow(
                label: 'Act as:',
                child: PersonasDropDown(),
              ),
              // _CustomRow(
              //   label: 'The system message',
              //   child: TextWidget(
              //     fontSize: 13,
              //     label: PersonasCubit.instance(context)
              //         .selectedPersona
              //         .generateContent(),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }

  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (_) {
          return roleSelection(context);
        });
  }
}

class _CustomRow extends StatelessWidget {
  const _CustomRow({super.key, required this.child, required this.label});
  final Widget child;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
        child: TextWidget(
          label: label,
          fontSize: 16,
        ),
      ),
      Flexible(flex: 2, child: child),
    ]);
  }
}
