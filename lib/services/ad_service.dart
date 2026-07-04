import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdLoaded = false;
  static int _navigationCounter = 0;
  static const int _adFrequency = 3; // Show ad every 3rd navigation

  static void loadInterstitialAd() {
    if (kIsWeb || _isInterstitialAdLoaded) return;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              // Don't immediately load next ad, wait for next navigation
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Failed to show interstitial ad: ${error.message}');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
            },
          );
        },
        onAdFailedToLoad: (err) {
          _isInterstitialAdLoaded = false;
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (kIsWeb) return;

    _navigationCounter++;

    // Only show ad every Nth navigation
    if (_navigationCounter % _adFrequency != 0) {
      return;
    }

    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
    } else {
      debugPrint('Interstitial ad not loaded yet.');
      loadInterstitialAd(); // Load for next time
    }
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
  }
}
