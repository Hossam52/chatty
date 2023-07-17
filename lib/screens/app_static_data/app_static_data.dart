import 'package:flutter/material.dart';

import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/screens/app_static_data/widgets/base_app_static_data.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/strings_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});
  Future<void> _launchURLInBrowser(String link) async {
    final url = link;
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

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
              'You can contact to support from the facebook page:\n',
              textAlign: TextAlign.center,
              style: getMediumStyle(fontSize: FontSize.s14),
            ),
            TextButton(
              onPressed: () async {
                _launchURLInBrowser(appCubit.contactEmail);
              },
              child: Text(
                '${appCubit.contactEmail}',
                textAlign: TextAlign.center,
                style: getMediumStyle(fontSize: FontSize.s14)
                    .copyWith(decoration: TextDecoration.underline),
              ),
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
