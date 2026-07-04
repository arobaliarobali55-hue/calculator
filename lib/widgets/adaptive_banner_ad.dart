import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class AdaptiveBannerAd extends StatefulWidget {
  const AdaptiveBannerAd({super.key});

  @override
  State<AdaptiveBannerAd> createState() => _AdaptiveBannerAdState();
}

class _AdaptiveBannerAdState extends State<AdaptiveBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only load ad once
    if (!_isLoading && _adSize == null) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    if (kIsWeb || _isLoading || _adSize != null) return;

    _isLoading = true;

    try {
      // MediaQuery ব্যবহার করে ডিভাইসের উইডথ বের করা
      final queryData = MediaQuery.of(context);

      // AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize ব্যবহার করে বিজ্ঞাপনের সাইজ নির্ধারণ
      final size =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        queryData.size.width.truncate(),
      );

      if (size == null) {
        debugPrint('Unable to get adaptive banner size');
        _isLoading = false;
        return;
      }

      if (!mounted) return;

      _adSize = size;

      // ২. টেস্ট আইডি এবং ৩. বিজ্ঞাপন লোড করা
      // BannerAd ক্লাস ব্যবহার করে অবজেクト তৈরি এবং .load() কল
      _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            // ৩. লোড হয়ে গেলে setState() কল করে ইউআই আপডেট
            if (mounted) {
              setState(() {
                _isLoaded = true;
                _isLoading = false;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('BannerAd failed to load: $error');
            ad.dispose();
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
      debugPrint('Error loading banner ad: $e');
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    // ৫. মেমরি পরিষ্কার করা (Dispose)
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null && _adSize != null) {
      // ৪. বিজ্ঞাপন প্রদর্শন করা (AdWidget)
      // iOS সতর্কতা অনুযায়ী নির্দিষ্ট উইডথ এবং হাইট দেওয়া হয়েছে
      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: _adSize!.width.toDouble(),
          height: _adSize!.height.toDouble(),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }
    // Show placeholder while loading to prevent layout shift
    return const SafeArea(
      child: SizedBox(
        height: 50, // Standard banner height
        width: double.infinity,
      ),
    );
  }
}
