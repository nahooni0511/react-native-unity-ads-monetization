package com.yourappmodule

import com.facebook.react.bridge.*
import com.unity3d.ads.UnityAds
import com.unity3d.ads.UnityAds.UnityAdsInitializationError
import com.unity3d.ads.UnityAds.UnityAdsLoadError
import com.unity3d.ads.UnityAds.UnityAdsShowError
import com.unity3d.ads.UnityAds.UnityAdsShowCompletionState
import com.unity3d.ads.IUnityAdsInitializationListener
import com.unity3d.ads.IUnityAdsLoadListener
import com.unity3d.ads.IUnityAdsShowListener
import com.facebook.react.modules.core.DeviceEventManagerModule

class UnityAdsMonetizationModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext), IUnityAdsInitializationListener, IUnityAdsLoadListener, IUnityAdsShowListener {

  private val hasLoaded = mutableMapOf<String, Boolean>()
  private var initializePromise: Promise? = null

  override fun getName(): String {
    return "UnityAdsMonetization"
  }

  @ReactMethod
  fun initialize(gameId: String, testMode: Boolean, promise: Promise) {
    this.initializePromise = promise
    UnityAds.initialize(reactApplicationContext.applicationContext, gameId, testMode, this)
  }

  @ReactMethod
  fun loadAd(placementId: String, promise: Promise) {
    UnityAds.load(placementId, this)
    // 로드 성공 또는 실패는 UnityAdsLoadListener의 콜백에서 처리됩니다.
    promise.resolve(null)
  }

  @ReactMethod
  fun isLoad(placementId: String, promise: Promise) {
    val isLoaded = hasLoaded[placementId] ?: false
    promise.resolve(isLoaded)
  }

  @ReactMethod
  fun showAd(placementId: String, promise: Promise) {
    UnityAds.show(currentActivity, placementId, this)
    promise.resolve(null)
  }

  override fun onInitializationComplete() {
    this.initializePromise?.resolve(true)
    this.initializePromise = null
  }

  override fun onInitializationFailed(error: UnityAdsInitializationError, message: String) {
    this.initializePromise?.reject("INITIALIZATION_ERROR", message)
    this.initializePromise = null
  }

  // Unity Ads 로드 리스너
  override fun onUnityAdsAdLoaded(placementId: String) {
    hasLoaded[placementId] = true
    val params = Arguments.createMap().apply {
      putString("placementId", placementId)
    }
    sendEvent("unityAdsAdLoaded", params)
  }

  override fun onUnityAdsFailedToLoad(placementId: String, error: UnityAdsLoadError, message: String) {
    hasLoaded[placementId] = false
    val data = mutableMapOf<String, Any>()
    val params = Arguments.createMap().apply {
      putString("placementId", placementId)
      putString("message", message)
    }
    sendEvent("unityAdsAdFailed", params)
  }

  // Unity Ads 표시 리스너
  override fun onUnityAdsShowComplete(placementId: String, state: UnityAdsShowCompletionState) {
    val params = Arguments.createMap().apply {
      putString("placementId", placementId)
      putString("state", state.name)
    }
    sendEvent("unityAdsShowComplete", params)
  }

  override fun onUnityAdsShowStart(placementId: String) {
    val params = Arguments.createMap().apply {
      putString("placementId", placementId)
    }
    sendEvent("unityAdsShowStart", params)
  }

  override fun onUnityAdsShowClick(placementId: String) {
    val params = Arguments.createMap().apply {
      putString("placementId", placementId)
    }
    sendEvent("unityAdsShowClick", params)
  }

  override fun onUnityAdsShowFailure(placementId: String, error: UnityAdsShowError, message: String) {
    val data = mutableMapOf<String, Any>()
    val params = Arguments.createMap().apply {
      putString("placementId", placementId)
      putString("message", message)
    }
    sendEvent("unityAdsShowFailed", params)
  }

  private fun sendEvent(eventName: String, eventData: WritableMap) {
    reactApplicationContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, eventData)
  }
}
