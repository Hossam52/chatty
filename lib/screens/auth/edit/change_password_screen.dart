import '../register_screen.dart';
import '../widgets/auth_text_field.dart';
import '../../../shared/presentation/resourses/color_manager.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TextWidget(
        label: 'Change password',
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
                    label: 'New password',
                    hint: 'Your new password',
                    validationRules: [
                      MinLength(6),
                      PasswordConfirmationValidator(
                          'Password and confirmation don\'t match ',
                          confirmPasswordController: currentPasswordController)
                    ]),
                CustomAuthField(
                    controller: TextEditingController(),
                    label: 'Password confirm',
                    hint: 'Your password confirmation',
                    validationRules: [
                      MinLength(6),
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

class CustomAuthField extends AuthTextField {
  static const int _customFlex = 2;
  const CustomAuthField({
    super.key,
    required super.controller,
    required super.label,
    required super.hint,
    required super.validationRules,
    super.inputType = TextInputType.text,
    super.password = false,
    super.onIconPressed,
    super.textField,
  }) : super(flex: _customFlex);
  CustomAuthField.customTextField({
    super.key,
    required super.controller,
    required super.label,
    super.textField,
  }) : super.customTextField(flex: _customFlex);
}
