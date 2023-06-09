import 'dart:developer';

import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? type;
  final String? hint;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final String? Function(String?)? validation;
  final String? labelText;
  final String? titleText;
  final Widget? prefix;
  final Function()? onTap;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final Color? suffixIconColor;
  final bool isSecure;
  final bool enabled;
  final Function()? suffixPressed;
  final Function(String?)? onSaved;
  final FocusNode? focusNode;
  final bool hasBorder;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final bool isOptional;
  final bool isRequired;
  final int minLines;
  final int? maxLines;
  const CustomTextFormField({
    Key? key,
    this.controller,
    this.type = TextInputType.text,
    this.hint,
    this.onSubmit,
    this.onChange,
    this.validation,
    this.labelText,
    this.titleText,
    this.prefix,
    this.onTap,
    this.suffixIcon,
    this.suffixWidget,
    this.suffixIconColor,
    this.borderColor,
    this.isSecure = false,
    this.enabled = true,
    this.suffixPressed,
    this.onSaved,
    this.focusNode,
    this.hasBorder = true,
    this.backgroundColor,
    this.borderRadius = 10,
    this.contentPadding,
    this.inputFormatters,
    this.isOptional = false,
    this.isRequired = false,
    this.minLines = 1,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    final border = widget.hasBorder
        ? OutlineInputBorder(
            borderSide: widget.borderColor == null
                ? const BorderSide()
                : BorderSide(color: widget.borderColor!),
            borderRadius: BorderRadius.circular(widget.borderRadius))
        : const OutlineInputBorder(borderSide: BorderSide.none);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleText != null)
          Column(
            children: [
              RichText(
                text: TextSpan(
                  text: widget.titleText!,
                  style: getMediumStyle(),
                  children: <TextSpan>[
                    if (widget.isOptional)
                      TextSpan(
                          text: ' (اختيارى)',
                          style:
                              getRegularStyle().copyWith(color: Colors.grey)),
                    if (widget.isRequired)
                      TextSpan(
                          text: ' *',
                          style: getMediumStyle()
                              .copyWith(color: ColorManager.error)),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: TextFormField(
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            keyboardType: widget.type,
            onFieldSubmitted: widget.onSubmit,
            onChanged: widget.onChange,
            onTap: widget.onTap,
            onSaved: widget.onSaved,
            validator: widget.validation,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            obscureText: widget.isSecure,
            style: getRegularStyle(),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
                filled: widget.backgroundColor != null ? true : false,
                fillColor: widget.backgroundColor,
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  fontSize: 18.sp,
                ),
                hintText: widget.hint,
                contentPadding: widget.contentPadding,
                hintStyle:
                    getMediumStyle().copyWith(color: ColorManager.hintColor),
                suffixIcon: widget.suffixWidget != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.suffixWidget!,
                          ],
                        ),
                      )
                    : widget.suffixIcon != null
                        ? IconButton(
                            icon: Icon(
                              widget.suffixIcon,
                              color: widget.suffixIconColor,
                            ),
                            onPressed: widget.suffixPressed ?? () {},
                            splashRadius: 1,
                          )
                        : null,
                prefixIcon: widget.prefix,
                focusedBorder: border,
                enabledBorder: border,
                disabledBorder: border,
                focusedErrorBorder: border,
                border: border),
          ),
        ),
      ],
    );
  }
}
