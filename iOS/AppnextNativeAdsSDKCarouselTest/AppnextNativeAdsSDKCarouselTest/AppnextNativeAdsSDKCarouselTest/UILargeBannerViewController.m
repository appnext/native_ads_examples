//
//  UILargeBannerViewController.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 17/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "UILargeBannerViewController.h"
#import "AppnextUILargeBannerViewExample.h"
#import "UIView+Toast.h"

@interface UILargeBannerViewController ()<AppnextNativeAdsRequestDelegate, AppnextUILargeBannerViewExampleDelegate>

@property (nonatomic, strong) AppnextNativeAdsSDKApi *api;
@property (nonatomic, strong) IBOutlet AppnextUILargeBannerViewExample *bannerView;

@end

@implementation UILargeBannerViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Large Banner";
    self.api = [[AppnextNativeAdsSDKApi alloc] initWithPlacementID:@"PUT_YOUR_IOS_PLACEMENT_ID_HERE"];
    self.bannerView.api = self.api;
    self.bannerView.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.bannerView stop];
}

#pragma mark - Actions

- (IBAction) loadAd:(id)sender
{
    AppnextNativeAdsRequest *request = [[AppnextNativeAdsRequest alloc] init];
    NSUInteger count = 1;
    request.count = count;
    request.creativeType = ANCreativeTypeManaged;
    [self.api loadAds:request withRequestDelegate:self];
    [self showActivity];
}

#pragma mark - Internal

- (void) showActivity
{
    self.view.userInteractionEnabled = NO;
    [self.view makeToastActivity];
}

- (void) hideActivity
{
    self.view.userInteractionEnabled = YES;
    [self.view hideToastActivity];
}

#pragma mark - AppnextNativeAdsRequestDelegate

- (void) onAdsLoaded:(NSArray<AppnextAdData *> *)ads forRequest:(AppnextNativeAdsRequest *)request
{
    [self hideActivity];

    NSString *description = [NSString stringWithFormat:@"onAdsLoaded:\r\n"];
    NSLog(@"%@", description);
    AppnextAdData *adData = ads.firstObject;
    self.bannerView.adData = adData;
    [self.bannerView play];
    [self.bannerView adImpression];
}

- (void) onError:(NSString *)error forRequest:(AppnextNativeAdsRequest *)request
{
    [self hideActivity];

    NSString *description = [NSString stringWithFormat:@"onError:forRequest: %@\r\n", error];
    NSLog(@"%@", description);
    [self.view makeToast:description];
}

#pragma mark - AppnextUILargeBannerViewExampleDelegate

- (void) installClicked:(AppnextUILargeBannerViewExample *)banner
{
    NSString *description = [NSString stringWithFormat:@"installClicked:\r\n"];
    NSLog(@"%@", description);
    [self.view makeToast:description];
}

- (void) privacyClicked:(AppnextUILargeBannerViewExample *)banner
{
    NSString *description = [NSString stringWithFormat:@"privacyClicked:\r\n"];
    NSLog(@"%@", description);
    [self.view makeToast:description];
}

- (void) willLeaveApplication:(AppnextUILargeBannerViewExample *)banner
{
    NSString *description = [NSString stringWithFormat:@"willLeaveApplication:\r\n"];
    NSLog(@"%@", description);
    [self.view makeToast:description];
}

- (void) onError:(NSString *)error forBanner:(AppnextUILargeBannerViewExample *)banner
{
    NSString *description = [NSString stringWithFormat:@"onError:forBanner: %@\r\n", error];
    NSLog(@"%@", description);
    [self.view makeToast:description];
}

@end
