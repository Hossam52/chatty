import '../models/auth/user_model.dart';
import '../shared/presentation/resourses/color_manager.dart';
import '../shared/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonImageWidget extends StatelessWidget {
  const PersonImageWidget({
    Key? key,
    required this.user,
    this.factor,
  }) : super(key: key);

  final User user;
  final double? factor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: CircleAvatar(
        radius: size.width * (factor ?? 0.1),
        backgroundColor: ColorManager.accentColor,
        foregroundColor: ColorManager.grey,
        child: Text(
          user.name[0].toUpperCase(),
          style: getBoldStyle(fontSize: 19.sp),
        ),
      ),
    );
  }
}
