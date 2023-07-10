import 'package:chatgpt/cubits/ads_cubit/ads_cubit.dart';
import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/screens/subscriptions/subscription_screen.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExcceedQuotaDialog extends StatelessWidget {
  const ExcceedQuotaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorManager.primary,
      title: TextWidget(
        label: 'No available messages remaining',
        color: ColorManager.error,
      ),
      content: TextWidget(
          label:
              'You excceed the quota limit\m Watch ads to get more messages or subscripe to new plan'),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Watch ads',
                onPressed: () async {
                  await AdsCubit.instance(context)
                      .showAds(AppCubit.instance(context));
                },
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: CustomButton(
                text: 'Subscripe',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: AppCubit.instance(context),
                        child: SubscriptionScreen(
                          appCubit: AppCubit.instance(context),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
