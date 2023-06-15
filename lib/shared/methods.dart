import '../widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Methods {
  Methods._();
  static Future<dynamic> navigateTo(BuildContext context, Widget widget) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
  }

  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: TextWidget(
          label: text,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: TextWidget(
          label: text,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

extension SizeExtensions on BuildContext {
  double get getWidth => size!.width;
  double get getHeight => size!.height;
  double getFactorWidth(double factor) => getWidth * factor;
  double getFactorHeight(double factor) => getHeight * factor;
}
