import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.validationRules,
    this.password = false,
    this.onIconPressed,
  });
  final TextEditingController controller;
  final bool password;
  final String label;
  final String hint;
  final List<TextValidationRule> validationRules;
  final void Function()? onIconPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(label,
                    style: getMediumStyle(color: ColorManager.white))),
            SizedBox(width: 20.w),
            Expanded(
              flex: 4,
              child: CustomTextFormField(
                  controller: controller,
                  isSecure: password,
                  hasBorder: true,
                  suffixIconColor: ColorManager.white,
                  suffixIcon: password
                      ? Icons.visibility_off
                      : onIconPressed != null
                          ? Icons.visibility
                          : null,
                  suffixPressed: onIconPressed,
                  borderColor: Colors.white54,
                  hint: hint,
                  validation: qValidator([IsRequired(), ...validationRules])),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
