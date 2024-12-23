// ignore_for_file: constant_identifier_names
import 'vcheck_platform_interface.dart';

//** -------------- Upper-level SDK dev interface class

class VCheckSDK {
  VCheckSDK._privateConstructor();

  static final VCheckSDK instance = VCheckSDK._privateConstructor();

  static void start({
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
    VcheckPlatform.instance.start(
      verificationToken: verificationToken,
      verificationScheme: verificationScheme,
      languageCode: languageCode,
      environment: environment,
      partnerEndCallback: partnerEndCallback,
      onVerificationExpired: onVerificationExpired,
      designConfig: designConfig,
      showCloseSDKButton: showCloseSDKButton,
      showPartnerLogo: showPartnerLogo,
      verificationApiBaseUrl: verificationApiBaseUrl,
      verificationServiceUrl: verificationServiceUrl,
    );
  }
}

//** -------------- Deprecated: Final verification status should be
//** -------------- retrieved by partners' service via VCheck API

class FinalVerificationStatus {
  bool? _isFinalizedAndSuccessful;
  bool? _isFinalizedAndFailed;
  bool? _isWaitingForManualCheck;
  String? _status;
  String? _scheme;
  String? _createdAt;
  String? _finalizedAt;
  List<String>? _rejectionReasons;

  FinalVerificationStatus(
      {bool? isFinalizedAndSuccessful,
      bool? isFinalizedAndFailed,
      bool? isWaitingForManualCheck,
      String? status,
      String? scheme,
      String? createdAt,
      String? finalizedAt,
      List<String>? rejectionReasons}) {
    if (isFinalizedAndSuccessful != null) {
      _isFinalizedAndSuccessful = isFinalizedAndSuccessful;
    }
    if (isFinalizedAndFailed != null) {
      _isFinalizedAndFailed = isFinalizedAndFailed;
    }
    if (isWaitingForManualCheck != null) {
      _isWaitingForManualCheck = isWaitingForManualCheck;
    }
    if (status != null) {
      _status = status;
    }
    if (scheme != null) {
      _scheme = scheme;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (finalizedAt != null) {
      _finalizedAt = finalizedAt;
    }
    if (rejectionReasons != null) {
      _rejectionReasons = rejectionReasons;
    }
  }

  bool? get isFinalizedAndSuccessful => _isFinalizedAndSuccessful;
  bool? get isFinalizedAndFailed => _isFinalizedAndFailed;
  bool? get isWaitingForManualCheck => _isWaitingForManualCheck;
  String? get status => _status;
  String? get scheme => _scheme;
  String? get createdAt => _createdAt;
  String? get finalizedAt => _finalizedAt;
  List<String>? get rejectionReasons => _rejectionReasons;

  FinalVerificationStatus.fromJson(Map<String, dynamic> json) {
    _isFinalizedAndSuccessful = json['isFinalizedAndSuccessful'];
    _isFinalizedAndFailed = json['isFinalizedAndFailed'];
    _isWaitingForManualCheck = json['isWaitingForManualCheck'];
    _status = json['status'];
    _scheme = json['scheme'];
    _createdAt = json['createdAt'];
    _finalizedAt = json['finalizedAt'];
    _rejectionReasons = json['rejectionReasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isFinalizedAndSuccessful'] = _isFinalizedAndSuccessful;
    data['isFinalizedAndFailed'] = _isFinalizedAndFailed;
    data['isWaitingForManualCheck'] = _isWaitingForManualCheck;
    data['status'] = _status;
    data['scheme'] = _scheme;
    data['createdAt'] = _createdAt;
    data['finalizedAt'] = _finalizedAt;
    data['rejectionReasons'] = _rejectionReasons;
    return data;
  }
}

enum VerificationSchemeType {
  FULL_CHECK, // = «full_check»
  DOCUMENT_UPLOAD_ONLY, // = «document_upload_only»
  LIVENESS_CHALLENGE_ONLY // = «liveness_challenge_only»
}

enum VCheckEnvironment { DEV, PARTNER }
