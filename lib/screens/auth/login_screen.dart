import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/screens/auth/widgets/remember_me_widget.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/auth_cubit/auth_states.dart';
import 'confirm_phone_screen.dart';
import 'register_screen.dart';
import 'widgets/auth_text_field.dart';
import '../home/home_screen.dart';
import '../../shared/methods.dart';
import '../../shared/presentation/resourses/color_manager.dart';
import '../../shared/presentation/resourses/font_manager.dart';
import '../../shared/presentation/resourses/styles_manager.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/default_loader.dart';
import '../../widgets/text_widget.dart';
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

  bool isPasswordSecured = true;
  @override
  void initState() {
    _loadCachedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: !Navigator.canPop(context)
              ? null
              : CupertinoNavigationBarBackButton(
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
                              password: isPasswordSecured,
                              onIconPressed: () {
                                setState(() {
                                  log(isPasswordSecured.toString());
                                  isPasswordSecured = !isPasswordSecured;
                                });
                              },
                              validationRules: [],
                              controller: passwordController);
                        }),
                        RememberMeWidget(),
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

  Future<void> _loadCachedData() async {
    print('${'-' * 20}Begin load Cached data');
    final instance = AuthCubit.instance(context);
    await AuthCubit.instance(context).loadCahcedRemember();
    emailController.text = instance.cachedEmail;
    passwordController.text = instance.cachedPassword;
    print('${'-' * 20}Endload Cached data');
  }
}
