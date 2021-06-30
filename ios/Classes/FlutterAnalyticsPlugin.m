#import "FlutterAnalyticsPlugin.h"
#if __has_include(<flutter_analytics/flutter_analytics-Swift.h>)
#import <flutter_analytics/flutter_analytics-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_analytics-Swift.h"
#endif

@implementation FlutterAnalyticsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAnalyticsPlugin registerWithRegistrar:registrar];
}
@end
