import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/widgets/personas/personas_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';
import '../widgets/drop_down.dart';
import '../widgets/text_widget.dart';

class Services {
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
          return BlocProvider.value(
            value: ConversationCubit.instance(context),
            child: PersonasBlocBuilder(builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _CustomRow(
                      label: 'Chosen Model:',
                      child: ModelsDrowDownWidget(),
                    ),
                    const _CustomRow(
                      label: 'Act as:',
                      child: PersonasDropDown(),
                    ),
                    _CustomRow(
                      label: 'The system message',
                      child: TextWidget(
                        fontSize: 13,
                        label: PersonasCubit.instance(context)
                            .selectedPersona
                            .generateContent(),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
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
