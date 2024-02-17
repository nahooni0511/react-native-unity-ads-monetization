import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-unity-ads-monetization' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const UnityAdsMonetizationNativeModule = NativeModules.UnityAdsMonetization
  ? NativeModules.UnityAdsMonetization
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const eventEmitter = new NativeEventEmitter(UnityAdsMonetizationNativeModule);
class UnityAds {
  static initialize(gameId: string, test: boolean): Promise<boolean> {
    return UnityAdsMonetizationNativeModule.initialize(gameId, test);
  }

  static loadAd(placementId: string): Promise<boolean> {
    return UnityAdsMonetizationNativeModule.loadAd(placementId);
  }

  static isLoad(placementId: string): Promise<boolean> {
    return UnityAdsMonetizationNativeModule.isLoad(placementId);
  }

  static showAd(placementId: string): Promise<boolean> {
    return UnityAdsMonetizationNativeModule.showAd(placementId);
  }

  //TODO remove listener
  static setOnUnityAdsLoadListener(option: {
    onAdLoaded: (placementId: string) => void;
    onAdLoadFailed: (placementId: string, message: string) => void;
  }) {
    const { onAdLoaded, onAdLoadFailed } = option;
    eventEmitter.addListener(
      'unityAdsAdLoaded', // 네이티브 모듈에서 보낸 이벤트와 동일한 이름을 사용합니다.
      (event) => {
        onAdLoaded(event.placementId);
      }
    );
    eventEmitter.addListener(
      'unityAdsAdFailed', // 네이티브 모듈에서 보낸 이벤트와 동일한 이름을 사용합니다.
      (event) => {
        onAdLoadFailed(event.placementId, event.message)
      }
    );
  }

  //TODO remove listener
  static setOnUnityAdsShowListener(option: {
    onShowStart: (placementId: string) => void;
    onShowComplete: (placementId: string, state: 'SKIPPED' | 'COMPLETED') => void;
    onShowFailed: (placementId: string, message: string) => void;
    onShowClick: (placementId: string) => void;
  }) {
    const { onShowStart, onShowComplete, onShowFailed, onShowClick } = option;
    eventEmitter.addListener(
      'unityAdsShowStart', // 네이티브 모듈에서 보낸 이벤트와 동일한 이름을 사용합니다.
      (event) => {
        onShowStart(event.placementId);
      }
    );
    eventEmitter.addListener(
      'unityAdsShowComplete', // 네이티브 모듈에서 보낸 이벤트와 동일한 이름을 사용합니다.
      (event) => {
        onShowComplete(event.placementId, event.state);
      }
    );
    eventEmitter.addListener(
      'unityAdsShowFailed', // 네이티브 모듈에서 보낸 이벤트와 동일한 이름을 사용합니다.
      (event) => {
        onShowFailed(event.placementId, event.message);
      }
    );
    eventEmitter.addListener(
      'unityAdsShowClick', // 네이티브 모듈에서 보낸 이벤트와 동일한 이름을 사용합니다.
      (event) => {
        onShowClick(event.placementId);
      }
    );
  }

}
export default UnityAds;
