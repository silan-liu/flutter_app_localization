#import "FlutterPlugin_cPlugin.h"
#if __has_include(<flutter_plugin_c/flutter_plugin_c-Swift.h>)
#import <flutter_plugin_c/flutter_plugin_c-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_plugin_c-Swift.h"
#endif

@implementation FlutterPlugin_cPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPlugin_cPlugin registerWithRegistrar:registrar];
}
@end
