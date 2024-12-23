#import "VcheckPlugin.h"
#if __has_include(<vcheck/vcheck-Swift.h>)
#import <vcheck/vcheck-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vcheck-Swift.h"
#endif

@implementation VcheckPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVcheckPlugin registerWithRegistrar:registrar];
}
@end
