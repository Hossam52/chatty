import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_states.dart';
import 'package:chatgpt/screens/auth/confirm_phone_screen.dart';
import 'package:chatgpt/screens/auth/register_screen.dart';
import 'package:chatgpt/screens/auth/widgets/auth_text_field.dart';
import 'package:chatgpt/screens/chat/chat_history_screen.dart';
import 'package:chatgpt/screens/home/home_screen.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:chatgpt/widgets/default_loader.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
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
        body: AuthBlocConsumer(listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.user.verified == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmPhoneScreen(
                            phoneNumber: state.user.phone,
                            sendVerification: true,
                          )));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          }
          if (state is LoginErrorState) {
            Methods.showSnackBar(context, state.error);
          }
        }, builder: (context, state) {
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
                          'Let\'s sign you in.',
                          style: getBoldStyle(
                              fontSize: FontSize.s24,
                              color: ColorManager.white.withOpacity(0.8)),
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          height: 70.h,
                          child: AnimatedTextKit(
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              displayFullTextOnTap: true,
                              // totalRepeatCount: 1,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Welcome back.\nYou\'ve been missed!',
                                  speed: Duration(milliseconds: 100),
                                  textStyle: getRegularStyle(
                                      fontSize: FontSize.s24,
                                      color:
                                          ColorManager.white.withOpacity(0.8)),
                                ),
                              ]),
                        ),
                        SizedBox(height: 50.h),
                        AuthTextField(
                            label: 'Email',
                            hint: 'Enter your email',
                            validationRules: const [
                              IsEmail('Email is not correct'),
                            ],
                            controller: emailController),
                        StatefulBuilder(builder: (context, setState) {
                          return AuthTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              password: isPasswordVisible,
                              onIconPressed: () {
                                setState(() {
                                  log(isPasswordVisible.toString());
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              validationRules: [
                                MinLength(5, 'Min length is 5'),
                                MaxLength(50, 'You excced max length 50'),
                              ],
                              controller: passwordController);
                        }),
                        if (kDebugMode)
                          TextButton(
                              onPressed: () async {
                                await AuthCubit.instance(context)
                                    .login('hossam@gmail.com', '123456');
                              },
                              child: Text('Test')),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            Text(
                              'Don\'t have account?',
                              style: getRegularStyle(),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen()));
                                },
                                child: const TextWidget(label: 'Register')),
                          ],
                        ),
                        if (state is LoginLoadingState)
                          const DefaultLoader()
                        else
                          CustomButton(
                            text: 'Login',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                AuthCubit.instance(context).login(
                                    emailController.text,
                                    passwordController.text);
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
        }),
      ),
    );
  }
}
