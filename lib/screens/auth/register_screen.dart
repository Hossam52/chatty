import 'dart:developer';

import 'package:chatgpt/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_states.dart';
import 'package:chatgpt/screens/auth/confirm_phone_screen.dart';
import 'package:chatgpt/screens/auth/edit/change_phone_screen.dart';
import 'package:chatgpt/screens/auth/login_screen.dart';
import 'package:chatgpt/screens/auth/widgets/auth_text_field.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/default_loader.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool passwordVisible = false;
  bool passwordConfirmVisible = false;

  String _completePhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: CupertinoNavigationBarBackButton(
            color: ColorManager.white,
          ),
        ),
        body: AuthBlocConsumer(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              Methods.showSnackBar(
                  context, 'Success register login to continue');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmPhoneScreen(
                            phoneNumber: phoneController.text,
                          )));
            }
            if (state is RegisterErrorState) {
              Methods.showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            log('Builder');
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let\'s sign up.',
                            style: getBoldStyle(
                                fontSize: FontSize.s24,
                                color: ColorManager.white.withOpacity(0.8)),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'Welcome.\nto new member!',
                            style: getRegularStyle(
                                fontSize: FontSize.s24,
                                color: ColorManager.white.withOpacity(0.8)),
                          ),
                          SizedBox(height: 50.h),
                          AuthTextField(
                              label: 'Name',
                              hint: 'Enter your name',
                              validationRules: const [],
                              inputType: TextInputType.name,
                              controller: nameController),
                          AuthTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              inputType: TextInputType.emailAddress,
                              validationRules: const [
                                IsEmail('Your email is not correct')
                              ],
                              controller: emailController),
                          AuthTextField.customTextField(
                            textField: PhoneField(
                              controller: phoneController,
                              onChange: (phoneNumber) =>
                                  _completePhoneNumber = phoneNumber,
                            ),
                            label: 'Phone',
                            controller: phoneController,
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            return AuthTextField(
                                label: 'Password',
                                password: passwordVisible,
                                onIconPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                hint: 'Enter your password',
                                validationRules: [
                                  PasswordConfirmationValidator(
                                      'Password not equal to confirmation',
                                      confirmPasswordController:
                                          passwordConfirmController),
                                ],
                                controller: passwordController);
                          }),
                          StatefulBuilder(builder: (context, setState) {
                            return AuthTextField(
                                label: 'Confirm password',
                                password: passwordConfirmVisible,
                                onIconPressed: () {
                                  setState(() {
                                    passwordConfirmVisible =
                                        !passwordConfirmVisible;
                                  });
                                },
                                hint: 'Enter your password confirmation',
                                validationRules: const [],
                                controller: passwordConfirmController);
                          }),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Have account?',
                                style: getRegularStyle(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: const TextWidget(label: 'Login')),
                            ],
                          ),
                          if (state is RegisterLoadingState)
                            const DefaultLoader()
                          else
                            CustomButton(
                              text: 'Register',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  AuthCubit.instance(context).register(
                                    email: emailController.text,
                                    phone: _completePhoneNumber,
                                    name: nameController.text,
                                    password: passwordController.text,
                                    passwordConfirm:
                                        passwordConfirmController.text,
                                  );
                                }
                              },
                              backgroundColor: ColorManager.accentColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PasswordConfirmationValidator extends TextValidationRule {
  PasswordConfirmationValidator(super.error,
      {required this.confirmPasswordController});
  final TextEditingController confirmPasswordController;
  @override
  bool isValid(String input) {
    if (input == confirmPasswordController.text) return true;
    return false;
  }
}
