import UnityAds

extension UIViewController {
    static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(selected)
        } else if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

@objc(UnityAdsMonetization)
class UnityAdsMonetization: RCTEventEmitter, UnityAdsLoadDelegate, UnityAdsShowDelegate, UnityAdsInitializationDelegate {
  var initializePromiseResolver:RCTPromiseResolveBlock?
  var initializePromiseRejecter:RCTPromiseRejectBlock?
  var hasLoaded: [String: Bool] = [:] // Create a dictionary to hold the loaded state by placementId

  @objc
  func initialize(_ gameId: String, testMode: Bool, promise: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    UnityAds.initialize(gameId, testMode: testMode, initializationDelegate: self)
    initializePromiseResolver = promise;
    initializePromiseRejecter = reject
  }

  @objc
  func loadAd(_ placementId: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    hasLoaded[placementId] = false

    UnityAds.load(placementId, loadDelegate: self)
    resolve(nil)
  }

  @objc
  func isLoad(_ placementId: String, resolver resolve: RCTPromiseResolveBlock) {
    if let isLoaded = hasLoaded[placementId] {
        resolve(isLoaded)
    } else {
        print("No information available for \(placementId)")
        resolve(false)
    }
  }

  @objc
  func showAd(_ placementId: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
      DispatchQueue.main.async {
          if let viewController = UIViewController.topViewController() {
            UnityAds.show(viewController, placementId: placementId, showDelegate: self)
            resolve(nil)
          } else {
            reject("ERROR", "Unable to find a top UIViewController", nil)
          }
      }
  }

  // UnityAdsInitializationDelegate methods
  func initializationComplete() {
    if let resolve = initializePromiseResolver {
      resolve(true)
      initializePromiseResolver = nil
      initializePromiseRejecter = nil
    }
  }
  func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
    if let reject = initializePromiseRejecter {
      reject("INITIALIZATION_ERROR", message, nil)
      initializePromiseResolver = nil
      initializePromiseRejecter = nil
    }
  }

  // UnityAdsLoadDelegate methods
  func unityAdsAdLoaded(_ placementId: String) {
    hasLoaded[placementId] = true
    sendEvent(withName: "unityAdsAdLoaded", body: ["placementId": placementId])
  }
  func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
    hasLoaded[placementId] = false
    sendEvent(withName: "unityAdsAdFailed", body: ["placementId": placementId, "message": message])
  }

  // UnityAdsShowDelegate methods
  func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
      
      var stateDescription: String
      switch state {
      case .showCompletionStateCompleted:
          stateDescription = "COMPLETED"
      case .showCompletionStateSkipped:
          stateDescription = "SKIPPED"
      }
      
    sendEvent(withName: "unityAdsShowComplete", body: ["placementId": placementId, "state": stateDescription])
  }

  func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
    sendEvent(withName: "unityAdsShowFailed", body: ["placementId": placementId, "message": message])
  }

  func unityAdsShowStart(_ placementId: String) {
    sendEvent(withName: "unityAdsShowStart", body: ["placementId": placementId])
  }

  func unityAdsShowClick(_ placementId: String) {
//    EventEmitter.shared.sendEvent(withName: "unityAdsShowClick", body: ["placementId": placementId])
  }

  override func supportedEvents() -> [String]! {
      return [
          "unityAdsAdLoaded",
          "unityAdsAdFailed",
          "unityAdsShowComplete",
          "unityAdsShowFailed",
          "unityAdsShowStart",
          "unityAdsShowClick"
      ]
  }
}
