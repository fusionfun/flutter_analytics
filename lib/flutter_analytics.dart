library analytics;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

part 'analytics.dart';

part 'analytics_common.dart';

part 'analytics_constants.dart';

class FlutterAnalytics {
  static const MethodChannel _channel = const MethodChannel('game.app.cradle.flutter_analytics');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get appInstanceId async {
    final String appInstanceId = await _channel.invokeMethod('getAppInstanceId');
    return appInstanceId;
  }
}
