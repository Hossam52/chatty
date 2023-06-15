import '../../../cubits/app_cubit/app_cubit.dart';
import '../../../cubits/app_cubit/app_states.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/auth_cubit/auth_states.dart';
import '../../../models/auth/user_model.dart';
import '../widgets/auth_text_field.dart';
import '../../settings/widgets/setting_item.dart';
import '../../settings/widgets/setting_section.dart';
import '../../../shared/methods.dart';
import '../../../shared/presentation/resourses/color_manager.dart';
import '../../../shared/presentation/resourses/font_manager.dart';
import '../../../shared/presentation/resourses/styles_manager.dart';
import '../../../widgets/ads/reward_ads_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/default_loader.dart';
import '../../../widgets/person_image_widget.dart';
import '../../../widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            child: ListView(
              padding: EdgeInsets.all(12.w),
              children: [
                PersonImageWidget(
                  user: widget.user,
                  factor: 0.13,
                ),
                AppBlocConsumer(
                  buildWhen: (previous, current) =>
                      current is ClaimAdRewardSuccessState,
                  listener: (context, state) {
                    if (state is ClaimAdRewardSuccessState) {
                      Methods.showSuccessSnackBar(context, state.message);
                    }

                    if (state is ClaimAdRewardErrorState) {
                      Methods.showSnackBar(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    final user = AppCubit.instance(context).currentUser;
                    return SettingsSectionWidget(title: 'Subscription', items: [
                      SettingItem(
                          title: 'Subscription',
                          contentWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SubscriptionItem(
                                  'Subscription plan', 'Free'),
                              _SubscriptionItem('Remaining messages',
                                  user.remaining_messages.toString()),
                            ],
                          ),
                          onTap: () async {
                            await _showAwardAdDialog(context);
                          }),
                    ]);
                  },
                ),
                Form(
                  key: formKey,
                  child: SettingsSectionWidget(
                      title: 'Personal information',
                      items: [
                        AuthTextField(
                            controller: currentPasswordController,
                            label: 'Current password',
                            hint: 'Current password',
                            validationRules: const []),
                        AuthTextField(
                            controller: nameController,
                            label: 'Name',
                            hint: 'Your name',
                            validationRules: const []),
                        AuthTextField(
                            controller: emailController,
                            label: 'Email',
                            hint: 'Your Email',
                            validationRules: const [
                              IsEmail(),
                            ]),
                        if (state is UpdateProfileDataLoadingState)
                          const DefaultLoader()
                        else
                          CustomButton(
                            text: 'Update',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                AuthCubit.instance(context).updateProfileData(
                                    password: currentPasswordController.text,
                                    name: nameController.text,
                                    email: emailController.text);
                              }
                            },
                          )
                      ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _showAwardAdDialog(BuildContext parentContext) async {
    return showDialog<bool>(
      context: parentContext,
      builder: (context) {
        return BlocProvider.value(
          value: AppCubit.instance(parentContext),
          child: const RewardAdsWidget(),
        );
      },
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
