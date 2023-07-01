import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/app_cubit/app_states.dart';
import 'package:chatgpt/screens/settings/widgets/setting_item.dart';
import 'package:chatgpt/screens/settings/widgets/setting_section.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:chatgpt/widgets/ads/reward_ads_widget.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionSettingItem extends StatelessWidget {
  const SubscriptionSettingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer(
      buildWhen: (previous, current) => current is ClaimAdRewardSuccessState,
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
            [
              _RowItem('Subscription plan', 'Free'),
              _RowItem('End date', 'Not defined'),
            ],
            actionTitle: 'Upgrade',
            onAction: () {},
          ),
          _SubscriptionItem(
            [
              _RowItem(
                'Remaining messages',
                user.remaining_messages.toString(),
              ),
            ],
            actionTitle: 'Get more',
            onAction: () async {
              await _showAwardAdDialog(context);
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
  const _SubscriptionItem(this.items,
      {super.key, required this.actionTitle, required this.onAction});
  final List<_RowItem> items;
  final String actionTitle;
  final VoidCallback onAction;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SettingItem(
              title: 'Subscription',
              contentWidget: Column(children: items),
              trailing: SizedBox.shrink(),
              onTap: () async {}),
        ),
        SizedBox(width: 10.w),
        CustomButton(
          text: actionTitle,
          backgroundColor: ColorManager.settingsColor,
          onPressed: onAction,
        )
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
