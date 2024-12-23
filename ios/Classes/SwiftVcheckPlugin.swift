import Flutter
import UIKit
import VCheckSDK

public class SwiftVcheckPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate {

    private var application: UIApplication? = nil
    private var verificationToken: String? = nil
    private var verifScheme: VerificationSchemeType? = nil
    private var environment: VCheckEnvironment? = nil
    private var languageCode: String? = nil
    private var showPartnerLogo: Bool? = false
    private var showCloseSDKButton: Bool? = true
    private var designConfig: VCheckDesignConfig? = nil
    private var channel: FlutterMethodChannel? = nil
    
    private var customVerificationApiBaseUrl: String? = nil
    private var customVerificationServiceUrl: String? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.sdk.vcheck", binaryMessenger: registrar.messenger())
        let instance = SwiftVcheckPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "start") {
            self.startSDKFlow(call, result: result);
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startSDKFlow(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! [String: Any]
        
        self.verificationToken = arguments["verifToken"] as? String
        self.verifScheme = convertStrToVerifScheme(str: (arguments["verifScheme"] as? String)?.lowercased())
        self.environment = convertStrToEnvironment(str: (arguments["environment"] as? String)?.lowercased())
        self.languageCode = arguments["languageCode"] as? String
        self.showPartnerLogo = arguments["showPartnerLogo"] as? Bool
        self.showCloseSDKButton = arguments["showCloseSDKButton"] as? Bool
        
        self.customVerificationApiBaseUrl = arguments["verificationApiBaseUrl"] as? String
        self.customVerificationServiceUrl = arguments["verificationServiceUrl"] as? String

        setDesignConfig(designConfigStr: arguments["designConfigStr"] as? String)

        if let vs = self.verifScheme {
            print("VCheck_iOS : Using \(String(describing: vs.description.uppercased())) verification scheme")
        }
        if let env = self.environment {
            print("VCheck_iOS : Using \(String(describing: env.description.uppercased())) environment")
        }
        if (environment == VCheckEnvironment.DEV) {
            print("VCheck_iOS : Warning - SDK environment is not set or default; using DEV environment by default")
        }

        result("VCheck_iOS : iOS SDK start() method called")
        
        self.launchSDK()
    }

    private func launchSDK() {
        // Создаем базовую конфигурацию SDK
        var sdkConfig = VCheckSDK.shared
            .verificationToken(token: self.verificationToken!)
            .verificationType(type: self.verifScheme!)
            .languageCode(langCode: self.languageCode!)
            .environment(env: self.environment!)
            .showPartnerLogo(show: self.showPartnerLogo!)
            .showCloseSDKButton(show: self.showCloseSDKButton!)
            .designConfig(config: self.designConfig!)
            .partnerEndCallback(callback: {
                self.onVCheckSDKFlowFinish()
            })
            .onVerificationExpired(callback: {
                self.onVerificationExpired()
            })
        
        if let apiBaseUrl = self.customVerificationApiBaseUrl,
           let serviceUrl = self.customVerificationServiceUrl,
           let url = URL(string: apiBaseUrl) {
            let urlConfig = VCheckURLConfig(
                verificationApiBaseUrl: url,
                verificationServiceUrl: serviceUrl
            )
            sdkConfig = sdkConfig.urlConfig(config: urlConfig)
        }
        
        sdkConfig.start(
            partnerAppRW: getOwnRootWindow()!,
            partnerAppVC: (UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController)!,
            replaceRootVC: false
        )
    }
    
    private func onVCheckSDKFlowFinish() {
        DispatchQueue.main.async {
            self.channel!.invokeMethod("onFinish", arguments: nil, result: {(r:Any?) -> () in
                print(r.debugDescription);
            })
        }
    }

    private func onVerificationExpired() {
        DispatchQueue.main.async {
            self.channel!.invokeMethod("onExpired", arguments: nil, result: {(r:Any?) -> () in
                print(r.debugDescription);
            })
        }
    }
    
    private func getOwnRootWindow() -> UIWindow? {
        if let window = UIApplication.shared.currentWindow {
            return window
        } else {
            return nil
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        self.application = application
    }

    private func setDesignConfig(designConfigStr: String?) {
        if let possibleJsonData = designConfigStr {
            if (!possibleJsonData.isEmpty) {
                if let value = try? JSONDecoder()
                    .decode(VCheckDesignConfig.self, from: possibleJsonData.data(using: .utf8)!) {
                    self.designConfig = value
                } else {
                    print("Non-valid JSON was passed while initializing "
                          + "VCheckDesignConfig instance. Persisting VCheck default theme")
                    self.designConfig = VCheckDesignConfig.getDefaultThemeConfig()
                }
            } else {
                print("No JSON data was passed while initializing "
                      + "VCheckDesignConfig instance. Persisting VCheck default theme")
            }
        }
    }
    
    private func convertStrToVerifScheme(str: String?) -> VerificationSchemeType? {
        let list = [
            VerificationSchemeType.FULL_CHECK,
            VerificationSchemeType.LIVENESS_CHALLENGE_ONLY,
            VerificationSchemeType.DOCUMENT_UPLOAD_ONLY
        ]
        return list.first { $0.description.lowercased() == str }
    }

    private func convertStrToEnvironment(str: String?) -> VCheckEnvironment? {
        let list = [
            VCheckEnvironment.DEV,
            VCheckEnvironment.PARTNER
        ]
        return list.first { $0.description.lowercased() == str }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        //Stub
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        //Stub
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        //Stub
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        //Stub
    }
}

extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}