//
//  AppnextNativeAdsCarouselViewExample.h
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 18/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppnextUILargeBannerViewExample.h"

@class AppnextNativeAdsCarouselViewExample;

@protocol AppnextNativeAdsCarouselViewExampleDelegate <NSObject>
@optional
- (void) installClicked:(AppnextNativeAdsCarouselViewExample *)carousel forBanner:(AppnextUILargeBannerViewExample *)banner;
- (void) privacyClicked:(AppnextNativeAdsCarouselViewExample *)carousel forBanner:(AppnextUILargeBannerViewExample *)banner;
- (void) willLeaveApplication:(AppnextNativeAdsCarouselViewExample *)carousel forBanner:(AppnextUILargeBannerViewExample *)banner;
- (void) onError:(NSString *)error forCarousel:(AppnextNativeAdsCarouselViewExample *)carousel forBanner:(AppnextUILargeBannerViewExample *)banner;
@end

@interface AppnextNativeAdsCarouselViewExample : UIView

@property (nonatomic, weak) id<AppnextNativeAdsCarouselViewExampleDelegate> delegate;
@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *postback;
@property (nonatomic, assign) NSUInteger count;

- (instancetype) initWithPlacementID:(NSString *)placementID;
- (void) loadAds;
- (void) stop;

@end
