import 'package:chatgpt/screens/auth/edit/change_password_screen.dart';
import 'package:chatgpt/screens/auth/register_screen.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({Key? key}) : super(key: key);

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final currentPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TextWidget(
        label: 'Change Phone',
      )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(children: [
                CustomAuthField(
                    controller: TextEditingController(),
                    label: 'Current password',
                    hint: 'Your current password',
                    validationRules: const []),
                CustomAuthField(
                    controller: TextEditingController(),
                    label: 'New Phone',
                    hint: 'Your new phone',
                    validationRules: [
                      MinLength(10),
                      MaxLength(15),
                    ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: CustomButton(
                    text: 'Save',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {}
                    },
                    backgroundColor: ColorManager.accentColor,
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
