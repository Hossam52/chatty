import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/screens/app_static_data/widgets/base_app_static_data.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/strings_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.instance(context);
    return BaseAppStaticData(
      title: 'Customer support',
      content: appCubit.contactEmail,
      widget: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You can contact to support from the facebook page:\n${appCubit.facebookLink}',
              textAlign: TextAlign.center,
              style: getMediumStyle(fontSize: FontSize.s14),
            ),
            SizedBox(height: 20.h),
            Text(
              'or via email through:\n ${appCubit.contactEmail}',
              textAlign: TextAlign.center,
              style: getMediumStyle(fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAppStaticData(
      title: 'About app',
      content: AppStrings.aboutApp,
    );
  }
}

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAppStaticData(
        title: 'Terms of use', content: AppStrings.termsOfUse);
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAppStaticData(
        title: 'Privacy policy', content: AppStrings.privacyPolicy);
  }
}
