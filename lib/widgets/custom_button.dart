import '../shared/presentation/resourses/color_manager.dart';
import '../shared/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double radius;
  final double padding;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final bool hasBorder;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const CustomButton({
    Key? key,
    this.onPressed,
    this.text = 'write text',
    this.textColor = Colors.white,
    this.backgroundColor,
    this.borderColor,
    this.radius = 10.0,
    this.padding = 5.0,
    this.width,
    this.height = 50,
    this.textStyle,
    this.hasBorder = false,
    this.leadingIcon,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      height: height.h,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                backgroundColor ?? ColorManager.accentColor),
            shape: MaterialStatePropertyAll(_shape()),
            padding: MaterialStatePropertyAll(EdgeInsets.all(padding)),
            elevation: MaterialStatePropertyAll(0)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) leadingIcon!,
            Container(
              child: Text(
                text,
                style: textStyle ??
                    getMediumStyle(color: textColor ?? Colors.black),
              ),
            ),
            if (trailingIcon != null) trailingIcon!
          ],
        ),
      ),
    );
  }

  RoundedRectangleBorder _shape() {
    return RoundedRectangleBorder(
      side: hasBorder
          ? BorderSide(
              width: 1.5,
              color: onPressed != null
                  ? borderColor ?? ColorManager.grey
                  : Colors.grey)
          : BorderSide.none,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
//01014656595 mohamed mohy