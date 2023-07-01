import '../../../shared/presentation/resourses/color_manager.dart';
import '../../../widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.icon,
    this.contentWidget,
    this.trailing,
  }) : super(key: key);
  final String title;
  final Widget? contentWidget;
  final IconData? icon;
  final VoidCallback onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 4,
          color: ColorManager.settingsColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: ListTile(
            onTap: onTap,
            minLeadingWidth: 20.w,
            leading: icon == null
                ? null
                : Icon(
                    icon,
                    size: 20.r,
                    color: Colors.white,
                  ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            title: contentWidget ?? TextWidget(label: title),
            trailing: trailing ??
                Icon(
                  CupertinoIcons.forward,
                  color: ColorManager.white,
                ),
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
