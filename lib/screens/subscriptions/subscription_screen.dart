import 'package:chatgpt/models/subscriptions/subscription_model.dart';
import 'package:chatgpt/models/subscriptions/subscription_plans_model.dart';
import 'package:chatgpt/shared/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/subscription_cubit/subscription_cubit.dart';
import 'package:chatgpt/cubits/subscription_cubit/subscription_states.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/font_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:chatgpt/widgets/default_loader.dart';
import 'package:chatgpt/widgets/text_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key, required this.appCubit});
  final AppCubit appCubit;
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    SubscriptionCubit.instance(context).init();
    SubscriptionCubit.instance(context).changeSelected(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubscriptionBlocConsumer(
      listener: (context, state) async {
        if (state is StoreSubscriptionsSuccessState) {
          await showDialog(
              context: context,
              builder: (context) {
                final subscription = state.user.active_subscription!;
                final plan = subscription.plan;
                return _RewardAnimation(plan: plan, subscription: subscription);
              });
          widget.appCubit.updateCurrentUser(state.user);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = SubscriptionCubit.instance(context);
        final products = cubit.products;
        return Scaffold(
          appBar: AppBar(
            title: Text('Available subscriptions'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              if (state is FetchOffersLoadingState ||
                  state is GetPlansLoadingState)
                return Center(
                  child: DefaultLoader(),
                );
              if (cubit.errorInPlans)
                return _ErrorWidget(
                  cubit: cubit,
                  onPress: () {
                    cubit.getPlans();
                  },
                );
              if (products.isEmpty) {
                return _ErrorWidget(
                  cubit: cubit,
                  onPress: () {
                    cubit.fetchOffers();
                  },
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20.h,
                          crossAxisSpacing: 20.h,
                        ),
                        itemBuilder: (_, index) =>
                            _SubscriptionItem(package: products[index]),
                        itemCount: products.length,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (products.isNotEmpty && cubit.isPackageSelected)
                      if (state is StoreSubscriptionsLoadingState ||
                          state is PurchasePackageLoadingState)
                        DefaultLoader()
                      else if (state is StoreSubscriptionsSuccessState)
                        SizedBox.shrink()
                      else
                        CustomButton(
                          text: 'Upgrade now',
                          onPressed: () {
                            cubit.purchasePackage(
                                widget.appCubit.currentUser.id.toString());
                          },
                        )
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    super.key,
    required this.cubit,
    required this.onPress,
  });

  final SubscriptionCubit cubit;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(label: 'Error when loading data'),
        SizedBox(height: 20.h),
        Center(
          child: CustomButton(text: 'Reload data', onPressed: onPress),
        ),
      ],
    );
  }
}

class _RewardAnimation extends StatelessWidget {
  const _RewardAnimation({
    super.key,
    required this.plan,
    required this.subscription,
  });

  final Plan plan;
  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/reward_lottie.json'),
            SizedBox(height: 20),
            Text(
              'Congratulations!\nYou are now subscriped for ${plan.formattedDuration} until ${DateFormat('yyyy-MM-dd').format(subscription.period_end_date)}',
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(fontSize: FontSize.s16),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _SubscriptionItem extends StatelessWidget {
  const _SubscriptionItem({super.key, required this.package});
  final Package package;
  @override
  Widget build(BuildContext context) {
    return SubscriptionBlocBuilder(builder: (context, state) {
      final cubit = SubscriptionCubit.instance(context);
      final isSelected = cubit.isProductSelected(package: package);
      final product = package.storeProduct;
      return GestureDetector(
        onTap: () {
          cubit.changeSelected(package);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color:
                isSelected ? ColorManager.accentColor.withOpacity(0.4) : null,
            border: Border.all(color: ColorManager.accentColor),
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                label: product.title,
                color: isSelected ? null : ColorManager.accentColor,
              ),
              Expanded(
                child: Center(
                  child: TextWidget(
                    label: product.description,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
              TextWidget(
                label: product.priceString,
                color: isSelected ? null : ColorManager.accentColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}
