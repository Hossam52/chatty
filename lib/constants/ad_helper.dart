import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6209088586214779/1211172877';
    }
    // else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/2934735716';
    // }
    else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6209088586214779/3310706693';
    }
    // else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/3964253750';
    // }
    else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6209088586214779/9257183851';
    }
    // else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/7552160883';
    // }
    else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
