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
    this.color,
  }) : super(key: key);
  final String title;
  final Widget? contentWidget;
  final IconData? icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color ?? ColorManager.settingsColor,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                icon == null
                    ? SizedBox.shrink()
                    : Icon(
                        icon,
                        size: 20.r,
                        color: Colors.white,
                      ),
                if (icon != null) SizedBox(width: 10.w),
                Expanded(child: contentWidget ?? TextWidget(label: title)),
                trailing != null
                    ? trailing!
                    : Icon(
                        CupertinoIcons.forward,
                        color: ColorManager.white,
                      )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}
