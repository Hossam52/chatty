import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../cubits/ads_cubit/ads_cubit.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdsCubit(),
      child: AdsBlocBuilder(
        builder: (context, state) {
          final ads = AdsCubit.instance(context);
          return FutureBuilder(
              future: ads.bannerAd,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final bannerAd = snapshot.data;
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: bannerAd!.size.width.toDouble(),
                      height: bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              });
        },
      ),
    );
  }
}
