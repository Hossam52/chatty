import 'package:chatgpt/shared/presentation/resourses/assets_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseAppStaticData extends StatelessWidget {
  const BaseAppStaticData(
      {super.key, required this.title, required this.content, this.widget});
  final String title;
  final String content;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.accentColor.withOpacity(0.5),
      appBar: AppBar(title: TextWidget(label: title)),
      body: Padding(
        padding: EdgeInsets.all(12.0.w),
        child: SafeArea(
          child: ListView(
            children: [
              Image.asset(
                AssetsManager.logoVertical,
                width: width * 0.5,
                height: height * 0.2,
              ),
              if (widget != null) widget! else TextWidget(label: content),
            ],
          ),
        ),
      ),
    );
  }
}
