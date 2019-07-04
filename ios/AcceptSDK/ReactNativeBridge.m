//
//  ReactNativeBridge.m
//  AcceptSDK
//
//  Created by Madhavi  Solanki on 26/06/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

//  ReactNativeBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNAccept, NSObject)
RCT_EXTERN_METHOD(getAPI);
RCT_EXTERN_METHOD(doCardPayment: (NSString) cardNumber
                  expirationMonth:(NSString)value
                  expirationYear:(NSString)value
                  cvvCode:(NSString)value
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(configure: (NSString) clientName
                  clientKey:(NSString)value
                  isProduction:(Bool)value);

@end
