import 'dart:async';
import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_states.dart';
import 'package:chatgpt/screens/auth/edit/change_phone_screen.dart';
import 'package:chatgpt/screens/auth/login_screen.dart';
import 'package:chatgpt/screens/auth/widgets/auth_text_field.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:chatgpt/widgets/default_loader.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:queen_validators/queen_validators.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  String phoneNumber;
  final bool sendVerification;
  ConfirmPhoneScreen({
    Key? key,
    required this.phoneNumber,
    this.sendVerification = false,
  }) : super(key: key);
  @override
  State<ConfirmPhoneScreen> createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    AuthCubit.instance(context).sendVerification(widget.phoneNumber);

    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: AuthBlocConsumer(listener: (context, state) {
        if (state is VerifyOtpErrorState) {
          Methods.showSnackBar(context, state.error);
        }
        if (state is VerifyOtpSuccessState) {
          Methods.showSnackBar(context, state.message);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }, builder: (context, state) {
        if (state is SendVerificationLoadingState) return const DefaultLoader();
        if (state is SendVerificationErrorState) {
          return Center(
            child: InkWell(
                onTap: () {
                  AuthCubit.instance(context)
                      .sendVerification(widget.phoneNumber);
                },
                child: TextWidget(label: 'Try again ${state.error}')),
          );
        }
        return GestureDetector(
          onTap: () {},
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset('assets/images/person.png'),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: TextWidget(
                      label: 'Phone Number Verification',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Enter the code sent to ",
                            children: [
                              TextSpan(
                                  text: "${widget.phoneNumber}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                            style: getMediumStyle(color: ColorManager.grey)),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final phone = await showDialog<String?>(
                                context: context,
                                builder: (context) {
                                  return BlocProvider.value(
                                      value: AuthCubit.instance(context),
                                      child: const _NewPhoneDialog());
                                });
                            if (phone != null) {
                              widget.phoneNumber = phone;
                            }
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                      child: _CustomPinTextField(
                        onUpdateCode: (val) {
                          textEditingController.text = val;
                        },
                      )),
                ),
                _errorCode(),
                const SizedBox(
                  height: 20,
                ),
                _resend(context),
                const SizedBox(
                  height: 14,
                ),
                if (state is VerifyOtpLoadingState)
                  const DefaultLoader()
                else
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 30),
                    child: CustomButton(
                      text: "VERIFY".toUpperCase(),
                      backgroundColor: Colors.green.shade300,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await AuthCubit.instance(context)
                              .verifyOtp(textEditingController.text);
                        } else {
                          errorController!.add(ErrorAnimationType
                              .shake); // Triggering error shake animation
                          setState(() => hasError = true);
                        }
                      },
                    ),
                  ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _resend(BuildContext context) {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Didn't receive the code? ",
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
          TextButton(
            onPressed: () async {
              await AuthCubit.instance(context)
                  .sendVerification(widget.phoneNumber);
              snackBar("OTP resend!!");
            },
            child: const Text(
              "RESEND",
              style: TextStyle(
                  color: Color(0xFF91D3B3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )
        ],
      );
    });
  }

  Padding _errorCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        hasError ? "*Please fill up all the cells properly" : "",
        style: const TextStyle(
            color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class _CustomPinTextField extends StatefulWidget {
  const _CustomPinTextField({super.key, required this.onUpdateCode});
  final void Function(String code) onUpdateCode;

  @override
  State<_CustomPinTextField> createState() => __CustomPinTextFieldState();
}

class __CustomPinTextFieldState extends State<_CustomPinTextField> {
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();

  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      obscureText: true,
      obscuringCharacter: '*',

      animationType: AnimationType.fade,
      validator: (v) {
        if (v!.length < 3) {
          return "Not valid code";
        } else {
          return null;
        }
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50.h,
        fieldWidth: 40.w,
        activeFillColor: Colors.white,
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      errorAnimationController: errorController,
      controller: textEditingController,
      keyboardType: TextInputType.number,

      onCompleted: (v) {
        debugPrint("Completed");
      },
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: (value) {
        debugPrint(value);
        widget.onUpdateCode(value);
      },
      beforeTextPaste: (text) {
        debugPrint("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}

class _NewPhoneDialog extends StatefulWidget {
  const _NewPhoneDialog({super.key});

  @override
  State<_NewPhoneDialog> createState() => _NewPhoneDialogState();
}

class _NewPhoneDialogState extends State<_NewPhoneDialog> {
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String _completePhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return AuthBlocConsumer(listener: (context, state) {
      if (state is ChangePhoneErrorState) {
        Methods.showSnackBar(context, state.error);
      }
      if (state is ChangePhoneSuccessState) {
        AuthCubit.instance(context).sendVerification(phoneController.text);
        Navigator.pop(context, state.phone);
      }
    }, builder: (context, state) {
      return Dialog(
        backgroundColor: scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthTextField.customTextField(
                  textField: PhoneField(
                    controller: phoneController,
                    onChange: (phoneNumber) =>
                        _completePhoneNumber = phoneNumber,
                  ),
                  controller: phoneController,
                  label: 'Phone',
                ),
                AuthTextField(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    validationRules: []),
                CustomButton(
                  text: 'Change phone',
                  backgroundColor: ColorManager.accentColor,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await AuthCubit.instance(context).changePhone(
                          _completePhoneNumber, passwordController.text);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
