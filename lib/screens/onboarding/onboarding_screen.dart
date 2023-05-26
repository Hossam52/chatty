import 'package:chatgpt/screens/auth/login_screen.dart';
import 'package:chatgpt/screens/auth/register_screen.dart';
import 'package:chatgpt/shared/presentation/resourses/assets_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(AssetsManager.logo),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          'Chatty\n Welcome to ChatGPT, your all-in-one chatbot app!',
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s17),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            'Welcome to the ultimate chatbot app powered by ChatGPT! Choose a role, prompt, and chat with our AI to experience the future of conversations' *
                                1,
                            textAlign: TextAlign.center,
                            style: getRegularStyle(color: ColorManager.white),
                          ),
                          Text(
                            '[switch roles, prompt, upload files!]' * 1,
                            textAlign: TextAlign.center,
                            style: getBoldStyle(
                                color: ColorManager.highlight,
                                fontSize: FontSize.s16),
                          ),
                        ],
                      )),
                    ],
                  )),
              SizedBox(
                  height: 45.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Container(
                        color: ColorManager.highlight.withOpacity(0.7),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        ColorManager.accentColor)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen()));
                                },
                                child: Text(
                                  'Register',
                                  style:
                                      getBoldStyle(color: ColorManager.white),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.transparent),
                                    elevation: MaterialStatePropertyAll(0)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                                child: Text(
                                  'Login',
                                  style: getBoldStyle(
                                      color: ColorManager.accentColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
