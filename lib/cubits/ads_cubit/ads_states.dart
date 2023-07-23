//
abstract class AdsStates {}

class IntitalAdsState extends AdsStates {}

//RewardAd online fetch data
class RewardAdLoadingState extends AdsStates {}

class RewardAdSuccessState extends AdsStates {}

class RewardAdGrantedState extends AdsStates {}

class RewardAdErrorState extends AdsStates {
  final String error;
  RewardAdErrorState({required this.error});
}

class BannerLoadedSuccess extends AdsStates {}

//ShowRewardAdv online fetch data
class ShowRewardAdvLoadingState extends AdsStates {}

class ShowRewardAdvSuccessState extends AdsStates {}

class ShowRewardAdvErrorState extends AdsStates {
  final String error;
  ShowRewardAdvErrorState({required this.error});
}
