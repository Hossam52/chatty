import 'package:chatgpt/shared/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';

import 'package:chatgpt/screens/app_static_data/widgets/base_app_static_data.dart';

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
