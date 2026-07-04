import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  // Test Ad Units from Google
  static String get bannerAdUnitId {
    if (kIsWeb) return '';

    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/9214589741';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }

    // Real Ad Unit IDs
    if (Platform.isAndroid) {
      return 'ca-app-pub-8566221264434021/8028606122';
    } else if (Platform.isIOS) {
      // Add your iOS banner ID here if available
      return 'ca-app-pub-8566221264434021/8028606122';
    } else {
      return '';
    }
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';

    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }

    if (Platform.isAndroid) {
      return 'ca-app-pub-8566221264434021/8028606122';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID for iOS if not provided
    } else {
      return '';
    }
  }
}
