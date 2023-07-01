import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteChatDialog extends StatelessWidget {
  const DeleteChatDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorManager.primary,
      title: TextWidget(
        label: 'Delete chat',
        color: ColorManager.error,
      ),
      content: TextWidget(label: 'Are you sure to delet ethis chat'),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Yes',
                backgroundColor: ColorManager.error.withOpacity(0.8),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: CustomButton(
                text: 'No',
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
