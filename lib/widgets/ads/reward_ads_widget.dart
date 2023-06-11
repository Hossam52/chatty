import 'dart:developer';

import 'package:chatgpt/cubits/ads_cubit/ads_cubit.dart';
import 'package:chatgpt/cubits/ads_cubit/ads_states.dart';
import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAdsWidget extends StatelessWidget {
  const RewardAdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorManager.primary,
      title: const TextWidget(label: 'Need more messages?'),
      content: const TextWidget(label: 'Watch an Ad to get a 5 messages!'),
      actions: [
        TextButton(
          child: Text('cancel'.toUpperCase()),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        AdsBlocConsumer(
          listener: (context, state) {
            if (state is RewardAdLoadedSuccess) Navigator.pop(context);
          },
          builder: (context, state) {
            return TextButton(
              child: Text('ok'.toUpperCase()),
              onPressed: () async {
                final ad = await AdsCubit.instance(context).rewardAd;
                ad?.show(
                  onUserEarnedReward: (_, RewardItem reward) async {
                    log(reward.toString());
                    await AppCubit.instance(context).claimAdReward();

                    log('User earned the reward');
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
