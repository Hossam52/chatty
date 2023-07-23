import 'package:chatgpt/cubits/ads_cubit/ads_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/app_cubit/app_states.dart';
import 'package:chatgpt/screens/settings/widgets/setting_item.dart';
import 'package:chatgpt/screens/settings/widgets/setting_section.dart';
import 'package:chatgpt/screens/subscriptions/subscription_screen.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/ads/reward_ads_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class SubscriptionSettingItem extends StatelessWidget {
  const SubscriptionSettingItem({super.key});
  String formatDate(DateTime? date) {
    if (date == null) return 'Undefined';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer(
      // buildWhen: (previous, current) => current is ClaimAdRewardSuccessState,
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
          _SubscriptionItem(
            user.isFreeSubscription,
            [
              if (user.isFreeSubscription) ...[
                _RowItem('Subscription plan', 'Free'),
              ] else ...[
                _RowItem(
                    'Subscription plan', user.active_subscription!.plan.name),
                _RowItem('End date',
                    formatDate(user.active_subscription?.period_end_date)),
              ]
            ],
            actionTitle: 'Upgrade',
            onAction: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SubscriptionScreen(
                            appCubit: AppCubit.instance(context),
                          )));
            },
          ),
          if (user.isFreeSubscription)
            AdsBlocBuilder(
              builder: (context, state) {
                return _SubscriptionItem(
                    user.isFreeSubscription,
                    [
                      _RowItem(
                        'Remaining messages',
                        user.remaining_messages.toString(),
                      ),
                    ],
                    displayLoadinOnAction:
                        AdsCubit.instance(context).loadingReward,
                    actionTitle: 'Get more', onAction: () async {
                  await AdsCubit.instance(context)
                      .showAds(AppCubit.instance(context));
                }
                    // () async {
                    //   await _showAwardAdDialog(context);
                    // },
                    );
              },
            ),
        ]);
      },
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
  const _SubscriptionItem(
    this.isFreeSubscription,
    this.items, {
    super.key,
    required this.actionTitle,
    required this.onAction,
    this.displayLoadinOnAction = false,
  });
  final List<_RowItem> items;
  final bool isFreeSubscription;
  final String actionTitle;
  final VoidCallback onAction;
  final bool displayLoadinOnAction;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: SettingItem(
                  title: 'Subscription',
                  contentWidget: Column(children: items),
                  trailing: SizedBox.shrink(),
                  onTap: () async {}),
            ),
            SizedBox(width: 10.w),
            if (isFreeSubscription)
              Expanded(
                  flex: 2,
                  child: displayLoadinOnAction
                      ? SpinKitCubeGrid(color: Colors.white, size: 30)
                      : SettingItem(
                          onTap: onAction,
                          trailing: SizedBox.shrink(),
                          title: actionTitle,
                        ))
            // CustomButton(
            //   height: double.infinity,
            //   text: actionTitle,
            //   backgroundColor: ColorManager.settingsColor,
            //   onPressed: onAction,
            // )
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem(
    this.title,
    this.value, {
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Text(
            '$title: ',
            style: getMediumStyle(fontSize: FontSize.s14),
          ),
        ),
        Text(
          value,
          style: getRegularStyle(
              color: ColorManager.primary, fontSize: FontSize.s14),
        ),
      ],
    );
  }
}
