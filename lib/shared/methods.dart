import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Methods {
  Methods._();

  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: TextWidget(
          label: text,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
