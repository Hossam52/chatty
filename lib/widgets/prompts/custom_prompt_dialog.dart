import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/models/prompts/prompt_types_interfaces.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/prompts/all_prompts_widgets.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPromptDialog extends StatefulWidget {
  const CustomPromptDialog({super.key});

  @override
  State<CustomPromptDialog> createState() => _CustomPromptDialogState();
}

class _CustomPromptDialogState extends State<CustomPromptDialog> {
  BasePromptType? _selected;

  @override
  Widget build(BuildContext context) {
    var buttonStyleData2 = ButtonStyleData(
      height: 50.h,
      width: 160.w,
      padding: const EdgeInsets.only(left: 14, right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black26,
        ),
        color: ColorManager.accentColor.withOpacity(0.7),
      ),
      elevation: 2,
    );
    var dropdownStyleData2 = DropdownStyleData(
        maxHeight: 200.h,
        width: 250.w,
        padding: null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: ColorManager.accentColor.withOpacity(0.6),
        ),
        elevation: 8,
        offset: const Offset(-20, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all(6),
          thumbVisibility: MaterialStateProperty.all(true),
        ));
    var iconStyleData2 = IconStyleData(
      icon: const Icon(
        Icons.arrow_forward_ios_outlined,
      ),
      iconSize: 14,
      iconEnabledColor: ColorManager.white,
      iconDisabledColor: Colors.grey,
    );
    return Dialog(
      backgroundColor: scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const TextWidget(label: 'Prompt: '),
                Expanded(
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                    isExpanded: true,
                    hint: _dropDownHint(),
                    items: items(context),
                    value: _selected,
                    onChanged: _onchanged,
                    buttonStyleData: buttonStyleData2,
                    iconStyleData: iconStyleData2,
                    dropdownStyleData: dropdownStyleData2,
                    menuItemStyleData: MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                    ),
                  )),
                ),
              ],
            ),
            if (_selected != null) ...[
              _promptFields(),
              // Text(_selected!.generate()),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'Apply',
                onPressed: () {
                  Services.sendMessage(
                    context: context,
                    alternateText: 'Prompt about ${_selected!.name}',
                    text: _selected!.generate(),
                  );
                  Navigator.pop(context);
                },
              )
            ]
          ],
        ),
      ),
    );
  }

  Flexible _promptFields() {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getPromptQueryWidget(_selected!.queries[index]);
        },
        itemCount: _selected!.queries.length,
      ),
    );
  }

  Row _dropDownHint() {
    return Row(
      children: [
        Icon(
          Icons.list,
          size: 16,
          color: ColorManager.white,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            'Select Item',
            style: getMediumStyle(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _onchanged(value) {
    setState(() {
      _selected = value;
    });
  }

  List<DropdownMenuItem<BasePromptType>> items(BuildContext context) {
    if (AppCubit.instance(context).promptModel == null) return [];
    return AppCubit.instance(context)
        .promptModel!
        .data
        .map((e) => DropdownMenuItem<BasePromptType>(
              value: e,
              child: TextWidget(label: e.name),
            ))
        .toList();
  }
}
