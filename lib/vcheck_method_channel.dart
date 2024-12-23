import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vcheck/vcheck.dart';
import 'vcheck_platform_interface.dart';

const methodChannel = MethodChannel("com.sdk.vcheck");

const onFinishMethodName = "onFinish";
const onExpiredMethodName = "onExpired";

/// An implementation of [VcheckPlatform] that uses method channels.
class MethodChannelVcheck extends VcheckPlatform {
  /// The method channel used to interact with the native platform.

  Function? _finishAction;
  Function? _expiredAction;

  @override
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
  }) async {
    methodChannel.setMethodCallHandler((methodCall) async {
      debugPrint("Caught method call with Dart handler: ${methodCall.method}");
      switch (methodCall.method) {
        case onFinishMethodName:
          Future.delayed(const Duration(milliseconds: 500), () {
            _finishAction!();
          });
          return;
        case onExpiredMethodName:
          Future.delayed(const Duration(milliseconds: 500), () {
            _expiredAction!();
          });
          return;
        default:
          throw MissingPluginException('Not Implemented');
      }
    });

    _finishAction = partnerEndCallback;
    _expiredAction = onVerificationExpired;

    methodChannel.invokeMethod<void>('start', <String, dynamic>{
      'verifToken': verificationToken,
      'verifScheme': verificationScheme.name.toLowerCase(),
      'languageCode': languageCode,
      'environment': environment.name.toLowerCase(),
      'designConfigStr': designConfig,
      'showPartnerLogo': showPartnerLogo ?? false,
      'showCloseSDKButton': showCloseSDKButton ?? true,
      'verificationApiBaseUrl': verificationApiBaseUrl,
      'verificationServiceUrl': verificationServiceUrl,
    });
  }
}
