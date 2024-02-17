#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(UnityAdsMonetization, NSObject)

RCT_EXTERN_METHOD(initialize:(NSString *)gameId testMode:(BOOL)testMode promise:(RCTPromiseResolveBlock)promise rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(loadAd:(NSString *)placementId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isLoad:(NSString *)placementId resolver:(RCTPromiseResolveBlock)resolve)

RCT_EXTERN_METHOD(showAd:(NSString *)placementId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
