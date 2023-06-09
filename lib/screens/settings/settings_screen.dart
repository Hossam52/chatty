import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/app_cubit/app_states.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_states.dart';
import 'package:chatgpt/models/auth/user_model.dart';
import 'package:chatgpt/screens/auth/edit/change_password_screen.dart';
import 'package:chatgpt/screens/auth/edit/change_phone_screen.dart';
import 'package:chatgpt/screens/auth/profile/profile_screen.dart';
import 'package:chatgpt/screens/onboarding/onboarding_screen.dart';
import 'package:chatgpt/screens/settings/widgets/setting_item.dart';
import 'package:chatgpt/screens/settings/widgets/setting_section.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:chatgpt/widgets/default_loader.dart';
import 'package:chatgpt/widgets/person_image_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      bottomNavigationBar: const _LogoutButton(),
      appBar: AppBar(
        title: const TextWidget(label: 'Settings'),
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
                    title: 'Change Phone',
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
                    title: 'Change Password',
                    icon: FontAwesomeIcons.lock,
                    onTap: () {
                      Methods.navigateTo(context, const ChangePasswordScreen());
                    },
                  ),
                ]),
                _divider(),
                SettingsSectionWidget(title: 'App sharing', items: [
                  SettingItem(
                      title: 'Share app',
                      icon: FontAwesomeIcons.shareFromSquare,
                      onTap: () {}),
                ]),
                _divider(),
                SettingsSectionWidget(title: 'General', items: [
                  SettingItem(
                      title: 'About app',
                      icon: FontAwesomeIcons.circleInfo,
                      onTap: () {}),
                  SettingItem(
                      title: 'Privacy policy',
                      icon: FontAwesomeIcons.fileCode,
                      onTap: () {}),
                  SettingItem(
                      title: 'Terms of use',
                      icon: FontAwesomeIcons.fileCircleCheck,
                      onTap: () {})
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
      padding: EdgeInsets.only(bottom: 100.h),
      child: Padding(
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
              return CustomButton(
                onPressed: () async {
                  await AuthCubit.instance(context).logout();
                },
                text: 'Logout',
                backgroundColor: Colors.black54,
                textStyle: getRegularStyle(
                    color: ColorManager.error, fontSize: FontSize.s14),
              );
            },
          )),
    );
  }
}
