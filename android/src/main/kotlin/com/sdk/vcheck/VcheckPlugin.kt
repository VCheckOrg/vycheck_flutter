package com.sdk.vcheck

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import com.vcheck.sdk.core.VCheckSDK
import com.vcheck.sdk.core.domain.VCheckDesignConfig
import com.vcheck.sdk.core.domain.VCheckEnvironment
import com.vcheck.sdk.core.domain.VerificationSchemeType
import com.vcheck.sdk.core.domain.VCheckURLConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class VcheckPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private val TAG = "VCheck_Android"

  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var channel: MethodChannel

  private var verificationToken: String? = null

  private var verifScheme: VerificationSchemeType? = null

  private var environment: VCheckEnvironment? = null

  private var languageCode: String? = null

  private var showPartnerLogo: Boolean? = false
  private var showCloseSDKButton: Boolean? = true

  private var designConfig: VCheckDesignConfig? = null

  private var verificationApiBaseUrl: String? = null
  private var verificationServiceUrl: String? = null

  override fun onAttachedToEngine(
          @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  ) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.sdk.vcheck")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "start" -> {
        startSDKFlow(call, result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun startSDKFlow(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {

    verificationToken = call.argument("verifToken")

    verifScheme = convertStrToVerifScheme(call.argument("verifScheme"))

    environment = convertStrToEnvironment(call.argument("environment"))

    languageCode = call.argument("languageCode")

    showPartnerLogo = call.argument("showPartnerLogo")
    showCloseSDKButton = call.argument("showCloseSDKButton")

    verificationApiBaseUrl = call.argument("verificationApiBaseUrl")
    verificationServiceUrl = call.argument("verificationServiceUrl")

    setDesignConfig(call.argument<String>("designConfigStr"))

    if (verifScheme != null) {
      Log.i(TAG, "Using ${verifScheme!!.name.uppercase()} verification scheme")
    }
    if (environment != null) {
      Log.i(TAG, "Using ${environment!!.name.uppercase()} environment")
    }
    if (environment == VCheckEnvironment.DEV) {
      Log.i(TAG, "Warning: SDK environment is not set or default; using DEV environment by default")
    }

    result.success("$TAG: Android SDK start() method called")

    launchSDK(activity)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  private fun launchSDK(activity: Activity) {

    var sdkConfig =
            VCheckSDK.verificationToken(verificationToken!!)
                    .verificationType(verifScheme!!)
                    .languageCode(languageCode!!)
                    .environment(environment!!)
                    .showPartnerLogo(showPartnerLogo!!)
                    .showCloseSDKButton(showCloseSDKButton!!)
                    .designConfig(designConfig!!)
                    .partnerEndCallback { onVCheckSDKFlowFinish() }
                    .onVerificationExpired { onVerificationExpired() }

    if (!verificationApiBaseUrl.isNullOrEmpty() && !verificationServiceUrl.isNullOrEmpty()) {
      val urlConfig =
              VCheckURLConfig(
                      verificationApiBaseUrl = verificationApiBaseUrl!!,
                      verificationServiceUrl = verificationServiceUrl!!
              )
      sdkConfig = sdkConfig.urlConfig(urlConfig)
    }

    sdkConfig.start(activity)
  }

  private fun onVCheckSDKFlowFinish() {
    channel.invokeMethod("onFinish", null)
  }

  private fun onVerificationExpired() {
    channel.invokeMethod("onExpired", null)
  }

  private fun setDesignConfig(possibleJsonData: String?) {
    if (possibleJsonData != null && possibleJsonData.isNotEmpty()) {
      try {
        designConfig = Gson().fromJson(possibleJsonData, VCheckDesignConfig::class.java)
      } catch (e: JsonSyntaxException) {
        designConfig = VCheckDesignConfig.getDefaultThemeConfig()
        Log.i(
                TAG,
                "Non-valid JSON was passed while " +
                        "initializing VCheckDesignConfig instance. Persisting VCheck default theme"
        )
      }
    } else {
      Log.i(
              TAG,
              "No JSON data was passed while initializing VCheckDesignConfig instance. " +
                      "Persisting VCheck default theme"
      )
    }
  }

  private fun convertStrToVerifScheme(str: String?): VerificationSchemeType {
    return VerificationSchemeType.values().first { it.name.lowercase() == str }
  }

  private fun convertStrToEnvironment(str: String?): VCheckEnvironment {
    return VCheckEnvironment.values().first { it.name.lowercase() == str }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // Stub
  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    // Stub
  }
  override fun onDetachedFromActivity() {
    // Stub
  }
}
