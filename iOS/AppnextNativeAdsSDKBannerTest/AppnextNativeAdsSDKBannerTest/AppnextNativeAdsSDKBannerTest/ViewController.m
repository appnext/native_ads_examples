//
//  ViewController.m
//  AppnextNativeAdsSDKBannerTest
//
//  Created by Eran Mausner on 02/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "ViewController.h"
#import "AppnextUIBannerViewExample.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet AppnextUIBannerViewExample *bannerView;
//@property (nonatomic, strong) AppnextUIBannerViewExample *bannerView2;

@end

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.bannerView.placementID = @"PUT_YOUR_IOS_PLACEMENT_ID_HERE";
/*
    self.bannerView2 = [[AppnextUIBannerViewExample alloc] initWithPlacementID:@"PUT_YOUR_IOS_PLACEMENT_ID_HERE"];
    self.bannerView2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.bannerView2];
*/
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bannerView.autoRefrash = NO;
    self.bannerView.refrashInterval = 19.f;
    [self.bannerView loadAd];
/*
    self.bannerView2.frame = CGRectMake(0.f, 100.f, self.view.frame.size.width, self.bannerView2.frame.size.height);
    self.bannerView2.autoRefrash = YES;
    self.bannerView2.refrashInterval = 17.f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bannerView2 loadAd];
    });
*/
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // This will stop the auto refresh when the view controller is gone.
    self.bannerView.autoRefrash = NO;
//    self.bannerView2.autoRefrash = NO;
}

@end
