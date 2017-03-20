//
//  UIMainViewController.m
//  AppnextSDKSampleApp
//
//  Created by Eran Mausner on 08/12/2016.
//  Copyright © 2016 Appnext. All rights reserved.
//

#import "UIMainViewController.h"
#import "UILargeBannerViewController.h"
#import "UICarouselViewController.h"

@interface UIMainViewController ()

@end

@implementation UIMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Main";
}

- (IBAction) moveToLargeBanner:(id)sender
{
    UILargeBannerViewController *viewControler = [[UILargeBannerViewController alloc] initWithNibName:@"UILargeBannerViewController" bundle:nil];
    [self.navigationController pushViewController:viewControler animated:YES];
}

- (IBAction) moveToCarousel:(id)sender
{
    UICarouselViewController *viewControler = [[UICarouselViewController alloc] initWithNibName:@"UICarouselViewController" bundle:nil];
    [self.navigationController pushViewController:viewControler animated:YES];
}

@end
