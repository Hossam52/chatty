import '../../../cubits/app_cubit/app_cubit.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/auth_cubit/auth_states.dart';
import 'change_password_screen.dart';
import '../../../shared/methods.dart';
import '../../../shared/presentation/resourses/color_manager.dart';
import '../../../shared/presentation/resourses/styles_manager.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/default_loader.dart';
import '../../../widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({Key? key}) : super(key: key);

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final currentPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String _completePhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TextWidget(
        label: 'Change Phone',
      )),
      body: AuthBlocConsumer(
        listener: (context, state) {
          if (state is UpdateProfileDataSuccessState) {
            AppCubit.instance(context).updateCurrentUser(state.user);
            Methods.showSuccessSnackBar(context, 'Updated successfully');
          }
          if (state is UpdateProfileDataErrorState) {
            Methods.showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    CustomAuthField(
                        controller: currentPasswordController,
                        label: 'Current password',
                        hint: 'Your current password',
                        validationRules: const []),
                    CustomAuthField.customTextField(
                      label: 'Phone',
                      textField: PhoneField(
                        controller: phoneController,
                        onChange: (phoneNumber) =>
                            _completePhoneNumber = phoneNumber,
                      ),
                      controller: phoneController,
                    ),
                    if (state is UpdateProfileDataLoadingState)
                      const DefaultLoader()
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: CustomButton(
                          text: 'Save',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AuthCubit.instance(context).updateProfileData(
                                  password: currentPasswordController.text,
                                  phone: _completePhoneNumber);
                            }
                          },
                          backgroundColor: ColorManager.accentColor,
                        ),
                      )
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PhoneField extends StatelessWidget {
  const PhoneField(
      {super.key, required this.controller, required this.onChange});
  final TextEditingController controller;
  final void Function(String phoneNumber) onChange;
  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
        borderRadius: BorderRadius.all(Radius.circular(10)));
    return IntlPhoneField(
      controller: controller,
      disableLengthCheck: false,
      dropdownTextStyle: getRegularStyle(),
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: border,
        // errorBorder: border,
        focusedBorder: border,
        enabledBorder: border,
        focusedErrorBorder: border,
      ),
      initialCountryCode: 'EG',
      onSaved: (newValue) {},
      onChanged: (phone) {
        onChange(phone.completeNumber);
        print(phone.completeNumber);
      },
    );
  }
}
