//
//  UICarouselViewController.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 17/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "UICarouselViewController.h"
#import "AppnextNativeAdsCarouselViewExample.h"

@interface UICarouselViewController ()

@property (nonatomic, strong) IBOutlet AppnextNativeAdsCarouselViewExample *carouselView;

@end

@implementation UICarouselViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Carousel";
    self.carouselView.placementID = @"PUT_YOUR_IOS_PLACEMENT_ID_HERE";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.carouselView loadAds];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.carouselView stop];
}

@end
