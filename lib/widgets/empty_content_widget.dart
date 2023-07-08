import 'package:chatgpt/shared/presentation/resourses/assets_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyContentWidget extends StatelessWidget {
  const EmptyContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsManager.emptyData,
            color: ColorManager.accentColor.withOpacity(0.7),
            width: width * 0.4,
            height: width * 0.4,
          ),
          SizedBox(height: 20.h),
          TextWidget(
            label: 'No cotent found here!',
          ),
        ],
      ),
    );
  }
}
