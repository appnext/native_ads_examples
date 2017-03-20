//
//  AppnextUIBannerViewExample.h
//  AppnextNativeAdsSDKBannerTest
//
//  Created by Eran Mausner on 10/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppnextUIBannerViewExample;

@protocol AppnextUIBannerViewExampleDelegate <NSObject>
@optional
- (void) installClicked:(AppnextUIBannerViewExample *)banner;
- (void) privacyClicked:(AppnextUIBannerViewExample *)banner;
- (void) willLeaveApplication:(AppnextUIBannerViewExample *)banner;
- (void) onError:(NSString *)error forBanner:(AppnextUIBannerViewExample *)banner;
@end

@interface AppnextUIBannerViewExample : UIView

@property (nonatomic, weak) id<AppnextUIBannerViewExampleDelegate> delegate;
@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *postback;
@property (nonatomic, assign) BOOL autoRefrash; // Default is NO. If you wish to autoRefrash you must call loadAd after setting to YES in order to start the refresh cycle.
@property (nonatomic, assign) NSTimeInterval refrashInterval;  // Default is 60 seconds. Minimum is 15 sec.

- (instancetype) initWithPlacementID:(NSString *)placementID;
- (void) loadAd;

@end
