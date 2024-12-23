import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vcheck/vcheck.dart';
import 'package:vcheck_example/result_widget.dart';

// You should get verification token from your service provider's side
// or by contacting VCheck team:
const String VERIFICATION_TOKEN = 'to-get-from-service';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  bool _isDefaultTheme = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VCheck Flutter demo'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 0, height: 50),
                MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      startSDK(
                          verificationScheme:
                              VerificationSchemeType.FULL_CHECK);
                    },
                    child: const Text("Full scheme")),
                const SizedBox(width: 0, height: 20),
                MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      startSDK(
                          verificationScheme:
                              VerificationSchemeType.DOCUMENT_UPLOAD_ONLY);
                    },
                    child: const Text("Document upload")),
                const SizedBox(width: 0, height: 20),
                MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      startSDK(
                          verificationScheme:
                              VerificationSchemeType.LIVENESS_CHALLENGE_ONLY);
                    },
                    child: const Text("Face check")),
                const SizedBox(width: 0, height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Use default theme"),
                    const SizedBox(width: 12),
                    CupertinoSwitch(
                      activeColor: Colors.blue.shade100,
                      thumbColor: Colors.blue,
                      trackColor: Colors.black12,
                      value: _isDefaultTheme,
                      onChanged: (value) => setState(() {
                        _isDefaultTheme = !_isDefaultTheme;
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize SDK in an async method
  Future<void> startSDK(
      {VerificationSchemeType verificationScheme =
          VerificationSchemeType.FULL_CHECK}) async {
    String designConfig;
    if (_isDefaultTheme == false) {
      designConfig = await DefaultAssetBundle.of(context)
          .loadString("assets/light_test_theme.json");
    } else {
      designConfig = await DefaultAssetBundle.of(context)
          .loadString("assets/default_dark_test_theme.json");
    }

    VCheckSDK.start(
        verificationToken: VERIFICATION_TOKEN,
        verificationScheme: verificationScheme,
        languageCode: "en",
        environment: VCheckEnvironment.DEV,
        partnerEndCallback: partnerEndCallback(),
        onVerificationExpired: onVerificationExpired(),
        designConfig: designConfig);
    if (!mounted) return;
  }

  Function partnerEndCallback() {
    return () {
      debugPrint("Triggered Dart callback for SDK finish");

      navigatorKey.currentState?.push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const ResultWidget(),
        ),
      );
    };
  }

  Function onVerificationExpired() {
    return () {
      debugPrint("Triggered callback for verification expiration case");
    };
  }
}
