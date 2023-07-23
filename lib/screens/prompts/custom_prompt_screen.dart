import 'package:chatgpt/shared/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chatgpt/cubits/prompts_cubit/prompts_cubit.dart';
import 'package:chatgpt/cubits/prompts_cubit/prompts_states.dart';
import 'package:chatgpt/models/prompts/fields_types/prompt_field_type_details_model.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:chatgpt/widgets/default_loader.dart';
import 'package:chatgpt/widgets/text_widget.dart';

class CustomPromptScreen extends StatefulWidget {
  const CustomPromptScreen({super.key});

  @override
  State<CustomPromptScreen> createState() => _CustomPromptScreenState();
}

class _CustomPromptScreenState extends State<CustomPromptScreen> {
  final controller = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    PromptsCubit.instance(context)
      ..removeAddedFields()
      ..getPromptFieldTypes();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: TextWidget(
          label: 'Custom prompt construction',
        )),
        body: PromptsBlocConsumer(
          listener: (context, state) {
            if (state is AddCustomPromptErrorState)
              Methods.showSnackBar(context, state.error, 3);
            if (state is AddCustomPromptSuccessState) {
              Methods.showSuccessSnackBar(context, state.msg, 3);

              Navigator.pop(context);
            }
            if (state is AddCustomPromptErrorState)
              Methods.showSnackBar(context, state.error, 4);
          },
          builder: (context, state) {
            if (state is GetPromptFieldTypesLoadingState)
              return DefaultLoader();
            if (state is GetPromptFieldTypesErrorState) {
              return _ErrorPromptField();
            }
            final cubit = PromptsCubit.instance(context);
            final addedFields = cubit.addedFields;
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          label:
                              'HINT: you must specify the paramter in the prompt text by square brackets [ ] to be identified',
                          fontSize: FontSize.s11,
                          color: ColorManager.grey,
                        ),
                        SizedBox(height: 10.h),
                        _PromptTextField(
                            label: 'Prompt name', controller: nameController),
                        SizedBox(height: 10.h),
                        _PromptTextField(
                            label: 'Prompt',
                            controller: controller,
                            minLines: 4,
                            maxLines: 10),
                        SizedBox(height: 10.h),
                        for (int i = 0; i < addedFields.length; i++)
                          _FieldItem(
                            field: addedFields[i],
                            onDeleted: () {
                              cubit.removeAddedField(i);
                            },
                          ),
                        _AddNewField(addedFields: addedFields, cubit: cubit),
                        SizedBox(height: 20.h),
                        if (state is AddCustomPromptLoadingState)
                          DefaultLoader()
                        else
                          CustomButton(
                            text: 'Apply',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                cubit.addCustomPrompt(
                                    nameController.text, controller.text);
                              }
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldItem extends StatelessWidget {
  const _FieldItem({super.key, required this.field, required this.onDeleted});

  final FieldType field;
  final void Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          TextWidget(
            label: field.fieldName,
          ),
          TextWidget(
            label: ' (' + field.fieldType.description + ')',
            color: ColorManager.accentColor,
          )
        ],
      ),
      trailing: InkWell(
        onTap: onDeleted,
        child: Icon(
          Icons.delete,
          color: ColorManager.error.withOpacity(0.8),
        ),
      ),
    );
  }
}

class _AddNewField extends StatefulWidget {
  _AddNewField({
    super.key,
    required this.addedFields,
    required this.cubit,
  });
  final List<FieldType> addedFields;
  final PromptsCubit cubit;

  @override
  State<_AddNewField> createState() => _AddNewFieldState();
}

class _AddNewFieldState extends State<_AddNewField> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool displayAddField = false;
  void changeVisibilty() {
    setState(() {
      displayAddField = !displayAddField;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!displayAddField)
      return InkWell(
          onTap: changeVisibilty,
          child: Icon(Icons.add, color: ColorManager.accentColor));
    return Column(
      children: [
        Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(child: TextWidget(label: 'Field')),
              Expanded(
                  flex: 4,
                  child: CustomTextFormField(
                    borderColor: ColorManager.accentColor,
                    controller: controller,
                    validation: (val) => val == null || val.isEmpty
                        ? 'Enter field name first'
                        : null,
                  )),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (widget.cubit.selectedField == null)
                            Methods.showSnackBar(
                                context, 'Select the field type first');
                          else {
                            widget.cubit.addField(controller.text);
                            controller.clear();
                            changeVisibilty();
                          }
                        }
                      },
                      child: Icon(
                        Icons.add,
                        color: ColorManager.accentColor,
                      )))
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _PromptFieldSelection(
            fields: widget.cubit.fieldTypes, cubit: widget.cubit),
      ],
    );
  }
}

class _PromptTextField extends StatelessWidget {
  const _PromptTextField({
    super.key,
    required this.controller,
    required this.label,
    this.minLines = 1,
    this.maxLines = 1,
  });
  final int minLines;
  final int maxLines;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextWidget(label: '$label: '),
        Expanded(
            child: CustomTextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          onChange: (val) {},
          validation: (val) =>
              val == null || val.isEmpty ? 'Enter $label' : null,
          borderColor: ColorManager.accentColor,
        )),
      ],
    );
  }
}

class _PromptFieldSelection extends StatelessWidget {
  const _PromptFieldSelection({
    super.key,
    required this.fields,
    required this.cubit,
  });

  final List<PromptFieldType> fields;
  final PromptsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final field = fields[index];
        return RadioListTile<PromptFieldType>.adaptive(
            value: field,
            groupValue: cubit.selectedField,
            activeColor: Colors.white,
            selected: field != cubit.selectedField,
            tileColor:
                field == cubit.selectedField ? ColorManager.accentColor : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: TextWidget(label: field.description),
            onChanged: (val) {
              cubit.setSelectedField(val);
            });
      },
      itemCount: fields.length,
    );
  }
}

class _ErrorPromptField extends StatelessWidget {
  const _ErrorPromptField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextWidget(label: 'Error happened try again'),
          CustomButton(
            text: 'Try again',
            onPressed: () {
              PromptsCubit.instance(context).getPromptFieldTypes();
            },
          ),
        ],
      ),
    );
  }
}
