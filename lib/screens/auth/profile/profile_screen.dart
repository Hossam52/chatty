import 'package:chatgpt/models/auth/user_model.dart';
import 'package:chatgpt/screens/auth/edit/change_password_screen.dart';
import 'package:chatgpt/screens/auth/widgets/auth_text_field.dart';
import 'package:chatgpt/screens/settings/widgets/setting_item.dart';
import 'package:chatgpt/screens/settings/widgets/setting_section.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/person_image_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:queen_validators/queen_validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController currentPasswordController;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    currentPasswordController = TextEditingController();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const TextWidget(
        label: 'Profile',
      )),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12.w),
          children: [
            PersonImageWidget(
              user: widget.user,
              factor: 0.13,
            ),
            SettingsSectionWidget(title: 'Subscription', items: [
              SettingItem(
                  title: 'Subscription',
                  contentWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _SubscriptionItem('Subscription plan', 'Free'),
                      _SubscriptionItem('Remaining messages', '10'),
                    ],
                  ),
                  onTap: () {}),
            ]),
            Form(
              key: formKey,
              child:
                  SettingsSectionWidget(title: 'Personal information', items: [
                AuthTextField(
                    controller: TextEditingController(),
                    label: 'Current password',
                    hint: 'Current password',
                    validationRules: const []),
                AuthTextField(
                    controller: TextEditingController(text: widget.user.name),
                    label: 'Name',
                    hint: 'Your name',
                    validationRules: const []),
                AuthTextField(
                    controller: TextEditingController(text: widget.user.email),
                    label: 'Email',
                    hint: 'Your Email',
                    validationRules: const [
                      IsEmail(),
                    ]),
                CustomButton(
                  text: 'Update',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class _SubscriptionItem extends StatelessWidget {
  const _SubscriptionItem(this.title, this.value, {super.key});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: getMediumStyle(fontSize: FontSize.s12),
        ),
        Text(
          value,
          style: getRegularStyle(color: ColorManager.primary),
        ),
      ],
    );
  }
}
