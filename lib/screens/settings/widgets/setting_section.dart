import '../../../shared/presentation/resourses/font_manager.dart';
import '../../../shared/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({required this.title, required this.items});
  final String title;
  final List<Widget> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getRegularStyle(fontSize: FontSize.s14),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              ...items,
            ],
          ),
        )
      ],
    );
  }
}
