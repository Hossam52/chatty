import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class RoleSelectionWidget extends StatelessWidget {
  const RoleSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileTheme(
      data: ExpansionTileThemeData(
        iconColor: ColorManager.grey,
        collapsedIconColor: ColorManager.grey,
        collapsedBackgroundColor: ColorManager.primary,
        backgroundColor: ColorManager.primary.withOpacity(0.8),
      ),
      child: ExpansionTile(
        title: Center(
          child: TextWidget(
            label: 'Select role',
            color: ColorManager.grey,
          ),
        ),
        children: [Services.roleSelection(context)],
      ),
    );
  }
}
