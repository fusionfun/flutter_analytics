part of "flutter_analytics.dart";

class FacebookAppEventsConstants {
  static const String EVENT_NAME_AD_CLICK = "AdClick";
  static const String EVENT_NAME_AD_IMPRESSION = "AdImpression";
  static const String EVENT_NAME_COMPLETED_TUTORIAL = "fb_mobile_tutorial_completion";
  static const String EVENT_NAME_SPENT_CREDITS = "fb_mobile_spent_credits";
  static const String EVENT_NAME_ACHIEVED_LEVEL = "fb_mobile_level_achieved";
  static const String EVENT_NAME_PURCHASED = "fb_mobile_purchase";

  static const String EVENT_PARAM_AD_TYPE = "ad_type";
  static const String EVENT_PARAM_CONTENT = "fb_content";
  static const String EVENT_PARAM_CONTENT_ID = "fb_content_id";
  static const String EVENT_PARAM_CONTENT_TYPE = "fb_content_type";
  static const String EVENT_PARAM_SUCCESS = "fb_success";
  static const String EVENT_PARAM_LEVEL = "fb_level";
}

class AnalyticsCapabilities {
  static const int firebase = 0x01;
  static const int facebook = 0x02;

  static const fullCapabilities = const AnalyticsCapabilities(firebase | facebook);
  static const firebaseCapabilities = const AnalyticsCapabilities(firebase);
  static const facebookCapabilities = const AnalyticsCapabilities(facebook);

  final int value;

  const AnalyticsCapabilities(this.value);

  bool hasCapability(int capability) {
    return (value & capability) == capability;
  }
}

class AdTypeName {
  static const String AD_TYPE_BANNER = "banner";
  static const String AD_TYPE_INTERSTITIAL = "interstitial";
  static const String AD_TYPE_REWARDED_VIDEO = "rewarded_video";
  static const String AD_TYPE_NATIVE = "native";
}
