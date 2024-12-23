import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vcheck/vcheck.dart';

import 'vcheck_method_channel.dart';

abstract class VcheckPlatform extends PlatformInterface {
  /// Constructs a VcheckTestPlatform.
  VcheckPlatform() : super(token: _token);

  static final Object _token = Object();

  static VcheckPlatform _instance = MethodChannelVcheck();

  /// The default instance of [VcheckPlatform] to use.
  ///
  /// Defaults to [MethodChannelVcheck].
  static VcheckPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VcheckPlatform] when
  /// they register themselves.
  static set instance(VcheckPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void start({
    required String verificationToken,
    required VerificationSchemeType verificationScheme,
    required String languageCode,
    required Function partnerEndCallback,
    required Function onVerificationExpired,
    required VCheckEnvironment environment,
    String? designConfig,
    bool? showPartnerLogo,
    bool? showCloseSDKButton,
    String? verificationApiBaseUrl,
    String? verificationServiceUrl,
  }) {
    throw UnimplementedError('start() has not been implemented.');
  }
}
