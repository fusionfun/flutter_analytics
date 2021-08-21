part of "flutter_analytics.dart";

class Analytics {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  // static FacebookAppEvents facebook = FacebookAppEvents();
  static List<EventTransmitter> transmitters = [];

  static NavigatorObserver getLogScreenNavigatorObserver() {
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  static bool dumpLog = false;

  /// Creates a new map containing all of the key/value pairs from [parameters]
  /// except those whose value is `null`.
  static Map<String, dynamic> _filterOutNulls(Map<String, dynamic> parameters) {
    final Map<String, dynamic> filtered = <String, dynamic>{};
    parameters.forEach((String key, dynamic value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }

  static registerTransmitter(EventTransmitter transmitter) {
    transmitters.add(transmitter);
  }

  static unregisterTransmitter(EventTransmitter transmitter) {
    transmitters.remove(transmitter);
  }

  static transmit(String name, Map<String, dynamic> parameters) {
    transmitters.forEach((transmitter) {
      transmitter.transmit(name, parameters);
    });
  }

  static Future<String> getAppInstanceId() {
    return FlutterAnalytics.appInstanceId;
  }

  static void logFirebaseEvent({required String name, Map<String, dynamic> parameters = const <String, dynamic>{}}) {
    if (dumpLog) {
      print("[firebase] logEvent: $name $parameters");
    }
    analytics.logEvent(name: name, parameters: _filterOutNulls(parameters));
  }

  static void logFacebookEvent({required String name, Map<String, dynamic> parameters = const <String, dynamic>{}, double? valueToSum}) {
    if (dumpLog) {
      print("[facebook] logEvent: $name $parameters value:$valueToSum");
    }

    // facebook.logEvent(name: name, parameters: _filterOutNulls(parameters), valueToSum: valueToSum);
  }

  static setUserProperty(String name, String value) {
    analytics.setUserProperty(name: name, value: value);
  }

  static setUserId(String userId) {
    analytics.setUserId(userId);
  }

  static logScreen(String screenName) {
    debugPrint("log SCREEN " + screenName);
    analytics.setCurrentScreen(screenName: screenName);
//    final facebookAppEvents = FacebookAppEvents();
//    facebookAppEvents.logEvent(
//      name: 'screen',
//      parameters: <String, dynamic>{"name": screenName, "category": "screen"},
//    );
  }

  static logEvent(String eventName, Map<String, dynamic> parameters, {AnalyticsCapabilities capabilities = AnalyticsCapabilities.fullCapabilities}) {
    if (kReleaseMode) {
      if (capabilities.hasCapability(AnalyticsCapabilities.firebase)) {
        logFirebaseEvent(
          name: eventName,
          parameters: parameters,
        );
      }
      if (capabilities.hasCapability(AnalyticsCapabilities.facebook)) {
        logFacebookEvent(
          name: eventName,
          parameters: parameters,
        );
      }
    } else {
      print("logEvent: $eventName $parameters");
    }
    transmit(eventName, parameters);
  }

  static logEventEx(String eventName,
      {String? itemCategory,
      String? itemName,
      double? value,
      Map<String, dynamic> parameters = const {},
      AnalyticsCapabilities capabilities = AnalyticsCapabilities.fullCapabilities}) {
    Map<String, dynamic> map = Map<String, dynamic>.from(parameters);
    if (itemCategory != null) {
      map["item_category"] = itemCategory;
    }

    if (itemName != null) {
      map["item_name"] = itemName;
    }

    if (value != null) {
      map["value"] = value;
    }

    logEvent(eventName, map, capabilities: capabilities);
  }

  static logEventWithCategoryAndName(String eventName, String itemCategory, String itemName) {
    logEvent(eventName, <String, dynamic>{
      "item_category": itemCategory,
      "item_name": itemName,
    });
  }

  static logFbAdClick(String adType) {
    logFacebookEvent(
        name: FacebookAppEventsConstants.EVENT_NAME_AD_CLICK, parameters: <String, dynamic>{FacebookAppEventsConstants.EVENT_PARAM_AD_TYPE: adType});
  }

  static logFbAdImpression(String adType) {
    logFacebookEvent(
        name: FacebookAppEventsConstants.EVENT_NAME_AD_IMPRESSION,
        parameters: <String, dynamic>{FacebookAppEventsConstants.EVENT_PARAM_AD_TYPE: adType});
  }

  static logFbAchieveLevel(String level) {
    logFacebookEvent(
        name: FacebookAppEventsConstants.EVENT_NAME_ACHIEVED_LEVEL,
        parameters: <String, dynamic>{FacebookAppEventsConstants.EVENT_PARAM_LEVEL: level});
  }

  static logBeginTutorial(String contentId) {
    logEvent("tutorial_begin", <String, dynamic>{"item_name": contentId});
  }

  //contentData: Parameter key used to specify data for the one or more pieces of content being logged about.
  // Data should be a JSON encoded string.
  // Example: "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]"
  static logCompleteTutorial(String contentId, bool success, {String contentData = ""}) {
    logEvent("tutorial_complete", <String, dynamic>{"item_name": contentId});

    logFacebookEvent(name: FacebookAppEventsConstants.EVENT_NAME_COMPLETED_TUTORIAL, parameters: <String, dynamic>{
      FacebookAppEventsConstants.EVENT_PARAM_CONTENT: contentData,
      FacebookAppEventsConstants.EVENT_PARAM_CONTENT_ID: contentId,
      FacebookAppEventsConstants.EVENT_PARAM_SUCCESS: success ? 1 : 0
    });
  }

  static logSpendCredits(String contentId, String contentType, double totalValue, {String virtualCurrencyName = "", String contentData = ""}) {
    logEvent("spend_virtual_currency", <String, dynamic>{
      "item_name": contentId,
      "item_category": contentType,
      "virtual_currency_name": virtualCurrencyName,
      "value": totalValue,
    });

    logFacebookEvent(
        name: FacebookAppEventsConstants.EVENT_NAME_COMPLETED_TUTORIAL,
        parameters: <String, dynamic>{
          FacebookAppEventsConstants.EVENT_PARAM_CONTENT: contentData,
          FacebookAppEventsConstants.EVENT_PARAM_CONTENT_ID: contentId,
          FacebookAppEventsConstants.EVENT_PARAM_CONTENT_TYPE: contentType
        },
        valueToSum: totalValue);
  }

  static logFbPurchase(double amount, {String currency = "", String? contentId}) {
    final parameters = <String, dynamic>{};

    if (contentId?.isNotEmpty == true) {
      parameters[FacebookAppEventsConstants.EVENT_PARAM_CONTENT_ID] = contentId;
    }
    if (dumpLog) {
      print("[facebook] logPurchase: $amount $currency parameters: $parameters");
    }

    // facebook.logPurchase(amount: amount, currency: currency, parameters: parameters);
  }

  static logAdImpression(String name, String adType, {String scene = "", String adName = "", Map<String, dynamic> parameters = const {}}) {
    logEventEx(name, itemCategory: scene, itemName: adName);
    if (kReleaseMode) {
      Analytics.logFbAdImpression(adType);
      FirebaseCrashlytics.instance.log("adImp: name($name) scene($scene) adName($adName) adType($adType)");
    } else {
      print("[facebook] logEvent logFbAdImpression: $adType");
    }
  }

  static logAdClick(String name, String adType, {String scene = "", String adName = ""}) {
    logEventEx(name, itemCategory: scene, itemName: adName);
    if (kReleaseMode) {
      Analytics.logFbAdClick(adType);
    } else {
      print("[facebook] logEvent logAdClick: $adType");
    }
  }

  static Map<String, dynamic> filterOutNulls(Map<String, dynamic> parameters) {
    final Map<String, dynamic> filtered = <String, dynamic>{};
    parameters.forEach((String key, dynamic value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }
}
