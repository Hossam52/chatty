import 'dart:async';

import 'package:chatgpt/screens/auth/login_screen.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  final String? phoneNumber;

  const ConfirmPhoneScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _ConfirmPhoneScreenState createState() => _ConfirmPhoneScreenState();
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
      body: GestureDetector(
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
                child: RichText(
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
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
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
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              _errorCode(),
              const SizedBox(
                height: 20,
              ),
              _resend(),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: CustomButton(
                  text: "VERIFY".toUpperCase(),
                  backgroundColor: Colors.green.shade300,
                  onPressed: () {
                    formKey.currentState!.validate();
                    // conditions for validating
                    if (currentText.length != 6 || currentText != "123456") {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => hasError = true);
                    } else {
                      setState(
                        () {
                          hasError = false;
                          snackBar("OTP Verified!!");
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      );
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
      ),
    );
  }

  Row _resend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive the code? ",
          style: TextStyle(color: Colors.black54, fontSize: 15),
        ),
        TextButton(
          onPressed: () => snackBar("OTP resend!!"),
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