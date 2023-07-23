import 'package:chatgpt/screens/prompts/custom_prompt_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chatgpt/screens/app_static_data/app_static_data.dart';
import 'package:chatgpt/screens/settings/widgets/subscription_setting_item.dart';

import '../../cubits/app_cubit/app_cubit.dart';
import '../../cubits/app_cubit/app_states.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/auth_cubit/auth_states.dart';
import '../../models/auth/user_model.dart';
import '../../shared/methods.dart';
import '../../shared/presentation/resourses/color_manager.dart';
import '../../shared/presentation/resourses/font_manager.dart';
import '../../widgets/default_loader.dart';
import '../../widgets/person_image_widget.dart';
import '../../widgets/text_widget.dart';
import '../auth/edit/change_password_screen.dart';
import '../auth/edit/change_phone_screen.dart';
import '../auth/profile/profile_screen.dart';
import '../onboarding/onboarding_screen.dart';
import 'widgets/setting_item.dart';
import 'widgets/setting_section.dart';

//my account, share with friends, privacy, about
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.instance(context).getUser();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // bottomNavigationBar: const _LogoutButton(),
      appBar: AppBar(
        title: const TextWidget(label: 'Settings'),
        actions: [
          _LogoutButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: AppBlocBuilder(builder: (context, state) {
          final cubit = AppCubit.instance(context);
          if (state is GetUserLoadingState) {
            return const DefaultLoader();
          }
          if (cubit.userError) {
            return Center(
              child: TextButton(
                  onPressed: () {
                    AppCubit.instance(context).currentUser;
                    build(context);
                  },
                  child: const TextWidget(
                    label: 'Error happened Retry',
                  )),
            );
          }
          final user = cubit.currentUser;
          return Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.01),
                _profile(context, user),
                _divider(),
                SettingsSectionWidget(title: 'Account info', items: [
                  SettingItem(
                    title: 'Change phone',
                    icon: FontAwesomeIcons.phone,
                    onTap: () {
                      Methods.navigateTo(
                          context,
                          BlocProvider.value(
                            value: AppCubit.instance(context),
                            child: const ChangePhoneScreen(),
                          ));
                    },
                  ),
                  SettingItem(
                    title: 'Change password',
                    icon: FontAwesomeIcons.lock,
                    onTap: () {
                      Methods.navigateTo(context, const ChangePasswordScreen());
                    },
                  ),
                ]),
                _divider(),
                SubscriptionSettingItem(),
                // _divider(),
                // SettingsSectionWidget(title: 'App sharing', items: [
                //   SettingItem(
                //       title: 'Share app',
                //       icon: FontAwesomeIcons.shareFromSquare,
                //       onTap: () {}),
                // ]),
                _divider(),
                SettingsSectionWidget(title: 'General', items: [
                  SettingItem(
                      title: 'Chat with support',
                      icon: FontAwesomeIcons.solidMessage,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                                  value: AppCubit.instance(context),
                                  child: ContactSupportScreen(),
                                )));
                      }),
                  SettingItem(
                      title: 'Custom prompt',
                      icon: Icons.file_copy,
                      color: Colors.amber.withOpacity(0.7),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CustomPromptScreen()));
                      }),
                  SettingItem(
                      title: 'About app',
                      icon: FontAwesomeIcons.circleInfo,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AboutAppScreen()));
                      }),
                  SettingItem(
                      title: 'Privacy policy',
                      icon: FontAwesomeIcons.fileCode,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PrivacyPolicyScreen()));
                      }),
                  SettingItem(
                      title: 'Terms of use',
                      icon: FontAwesomeIcons.fileCircleCheck,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => TermsOfUseScreen()));
                      })
                ])
              ],
            ),
          );
        }),
      ),
    );
  }

  Divider _divider() => Divider(
        thickness: 1,
        color: ColorManager.accentColor.withOpacity(0.5),
        endIndent: 20.w,
        indent: 20.w,
      );

  Widget _profile(BuildContext context, User user) {
    return AppBlocBuilder(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Methods.navigateTo(
              context,
              BlocProvider.value(
                value: AppCubit.instance(context),
                child: ProfileScreen(user: user),
              ),
            );
          },
          child: Row(
            children: [
              PersonImageWidget(user: user, factor: 0.06),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      label: user.name,
                      fontWeight: FontWeightManager.semiBold,
                      fontSize: FontSize.s20,
                    ),
                    TextWidget(
                      label: user.phone,
                      fontWeight: FontWeightManager.regular,
                      fontSize: FontSize.s12,
                    ),
                    TextWidget(
                      label: user.email,
                      fontWeight: FontWeightManager.regular,
                      fontSize: FontSize.s12,
                    ),
                  ],
                ),
              )),
              Icon(CupertinoIcons.forward, color: ColorManager.grey)
            ],
          ),
        );
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: AuthBlocConsumer(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnBoardingScreen()));
            }
          },
          builder: (context, snapshot) {
            return IconButton(
              icon: Icon(
                Icons.logout,
                color: ColorManager.error,
              ),
              onPressed: () async {
                await AuthCubit.instance(context).logout();
              },
            );
          },
        ));
  }
}
