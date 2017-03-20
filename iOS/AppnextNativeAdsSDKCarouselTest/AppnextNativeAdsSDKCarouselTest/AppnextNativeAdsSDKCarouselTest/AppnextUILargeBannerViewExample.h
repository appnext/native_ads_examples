//
//  AppnextUILargeBannerViewExample.h
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 12/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppnextNativeAdsSDK/AppnextNativeAdsSDK.h>

#define kDefaultBannerWidth 300.f
#define kDefaultBannerHeight 250.f

@class AppnextUILargeBannerViewExample;

@protocol AppnextUILargeBannerViewExampleDelegate <NSObject>
@optional
- (void) installClicked:(AppnextUILargeBannerViewExample *)banner;
- (void) privacyClicked:(AppnextUILargeBannerViewExample *)banner;
- (void) willLeaveApplication:(AppnextUILargeBannerViewExample *)banner;
- (void) onError:(NSString *)error forBanner:(AppnextUILargeBannerViewExample *)banner;
@end

@interface AppnextUILargeBannerViewExample : UIView

@property (nonatomic, weak) id<AppnextUILargeBannerViewExampleDelegate> delegate;
@property (nonatomic, strong) AppnextAdData *adData;
@property (nonatomic, strong) AppnextNativeAdsSDKApi *api; // This is used for the Install Click and Impression

- (instancetype) initWithAdData:(AppnextAdData *)adData withNativeAdsSDKApi:(AppnextNativeAdsSDKApi *)api;

- (void) adImpression;

- (void) play;
- (void) pause;
- (void) stop;

@end
