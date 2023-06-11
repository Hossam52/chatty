import 'package:chatgpt/constants/ad_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './ads_states.dart';

//Bloc builder and bloc consumer methods
typedef AdsBlocBuilder = BlocBuilder<AdsCubit, AdsStates>;
typedef AdsBlocConsumer = BlocConsumer<AdsCubit, AdsStates>;

//
class AdsCubit extends Cubit<AdsStates> {
  AdsCubit() : super(IntitalAdsState());
  static AdsCubit instance(BuildContext context) =>
      BlocProvider.of<AdsCubit>(context);

  //----------------------Rewarded ads-------------------
  RewardedAd? _rewardedAd;
  Future<RewardedAd?> get rewardAd async {
    if (_rewardedAd == null) await _loadRewardedAd();
    return _rewardedAd;
  }

//For loading rewarded ads
  Future<void> _loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd();
            },
          );
          _rewardedAd = ad;
          emit(RewardAdLoadedSuccess());
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  //-----------------------------------------------
  //--------------------Banner ads---------------------------
  BannerAd? _bannerAd;
  Future<BannerAd?> get bannerAd async {
    if (_bannerAd == null) await _loadBanner();
    return _bannerAd;
  }

  Future<void> _loadBanner() async {
    await BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          emit(BannerLoadedSuccess());
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
}
