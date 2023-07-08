//
abstract class AdsStates {}

class IntitalAdsState extends AdsStates {}

//
class RewardAdLoadedSuccess extends AdsStates {}

class BannerLoadedSuccess extends AdsStates {}

//ShowRewardAdv online fetch data
class ShowRewardAdvLoadingState extends AdsStates {}

class ShowRewardAdvSuccessState extends AdsStates {}

class ShowRewardAdvErrorState extends AdsStates {
  final String error;
  ShowRewardAdvErrorState({required this.error});
}
