//
//  AppnextNativeAdsCarouselViewExample.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 18/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "AppnextNativeAdsCarouselViewExample.h"
#import <AppnextNativeAdsSDK/AppnextNativeAdsSDK.h>
#import "iCarousel.h"
#import "AppnextUILargeBannerViewExample.h"

#define kDefaultAdsCount 100

@interface AppnextNativeAdsCarouselViewExample() <AppnextNativeAdsRequestDelegate, iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) AppnextNativeAdsSDKApi *api;
@property (nonnull, strong) NSMutableArray<AppnextUILargeBannerViewExample *> *adViews;
@property (nonatomic, strong) iCarousel *carousel;

@end

@implementation AppnextNativeAdsCarouselViewExample

#pragma mark - Lifecycle

- (instancetype) init
{
    if (self = [super init])
    {
        [self internalInit];
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self internalInit];
    }
    
    return self;
}

- (nullable instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self internalInit];
    }
    
    return self;
}

- (instancetype) initWithPlacementID:(NSString *)placementID
{
    if (self = [super initWithFrame:CGRectZero])
    {
        [self internalInit];
        self.placementID = placementID;
    }
    
    return self;
}

- (void) dealloc
{
    self.carousel.delegate = nil;
    self.carousel.dataSource = nil;

    [self stop];

    // notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self layoutInternalViews];
}

#pragma mark - Public Methods

- (void) loadAds
{
    if (self.api)
    {
        AppnextNativeAdsRequest *request = [[AppnextNativeAdsRequest alloc] init];
        request.count = self.count;
        request.creativeType = ANCreativeTypeManaged;
        request.categories = self.categories;
        request.postback = self.postback;
        [self.api loadAds:request withRequestDelegate:self];
    }
}

- (void) stop
{
    UIView *item = self.carousel.currentItemView;
    if (item && [item isKindOfClass:[AppnextUILargeBannerViewExample class]])
    {
        AppnextUILargeBannerViewExample *banner = (AppnextUILargeBannerViewExample *)item;
        [banner stop];
    }
}

#pragma mark - Setters/Getters

- (void) setPlacementID:(NSString *)placementID
{
    self.api = [[AppnextNativeAdsSDKApi alloc] initWithPlacementID:placementID];
}

- (NSString *) getPlacementID
{
    return self.api.placementID;
}

# pragma mark - Construct/Destruct Helpers

- (void) internalInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.count = kDefaultAdsCount;
    [self createUIComponents];
}

- (void) createUIComponents
{
    self.carousel = [[iCarousel alloc] initWithFrame:self.bounds];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.pagingEnabled = YES;
    self.carousel.bounces = NO;
    self.carousel.type = iCarouselTypeLinear;
    [self addSubview:self.carousel];
}

#pragma mark - Internal Methods

- (void) layoutInternalViews
{
    self.carousel.frame = self.bounds;
}

#pragma mark - AppnextNativeAdsRequestDelegate Methods

- (void) onAdsLoaded:(NSArray<AppnextAdData *> *)ads forRequest:(AppnextNativeAdsRequest *)request
{
    if (!ads || (ads.count == 0))
    {
        [self performOnError:kAdErrorNoAds forBanner:nil];
        return;
    }

    self.adViews = [NSMutableArray array];
    for (int i = 0 ; i < ads.count ; i++)
    {
        [self.adViews addObject:[[AppnextUILargeBannerViewExample alloc] initWithAdData:ads[i] withNativeAdsSDKApi:self.api]];
    }

    self.carousel.scrollEnabled = (self.adViews.count > 1);
    [self.carousel reloadData];
}

- (void) onError:(NSString *)error forRequest:(AppnextNativeAdsRequest *)request
{
    [self performOnError:error forBanner:nil];
}

#pragma mark - iCarouselDataSource methods

- (NSInteger) numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSInteger count = 0;
    if (self.adViews)
    {
        count = (NSInteger)(self.adViews.count);
    }

    return count;
}

- (UIView *) carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index < self.adViews.count)
    {
        view = self.adViews[index];
    }

    return view;
}

#pragma mark - iCarouselDelegate methods

- (void) carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (self.carousel == carousel)
    {
        UIView *item = self.carousel.currentItemView;
        if (item && [item isKindOfClass:[AppnextUILargeBannerViewExample class]])
        {
            AppnextUILargeBannerViewExample *banner = (AppnextUILargeBannerViewExample *)item;
            [banner play];
            [banner adImpression];
        }
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    if (self.carousel == carousel)
    {
        [self stop];
    }
}

- (CGFloat) carouselItemWidth:(iCarousel *)carousel
{
    return kDefaultBannerWidth;
}


- (CGFloat) carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return (self.adViews && (self.adViews.count > 2));
        }
        case iCarouselOptionSpacing:
        {
            // add a bit of spacing between the item views
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark - AppnextUIBannerViewExampleDelegate Callbacks

- (void) performInstallClickedForBanner:(AppnextUILargeBannerViewExample *)banner
{
    __strong id<AppnextNativeAdsCarouselViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(installClicked:forBanner:)])
    {
        [strongDelegate installClicked:self forBanner:banner];
    }
}

- (void) performPrivacyClickedForBanner:(AppnextUILargeBannerViewExample *)banner
{
    __strong id<AppnextNativeAdsCarouselViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(privacyClicked:forBanner:)])
    {
        [strongDelegate privacyClicked:self forBanner:banner];
    }
}

- (void) performWillLeaveApplicationForBanner:(AppnextUILargeBannerViewExample *)banner
{
    __strong id<AppnextNativeAdsCarouselViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(willLeaveApplication:forBanner:)])
    {
        [strongDelegate willLeaveApplication:self forBanner:banner];
    }
}

- (void) performOnError:(NSString *)error forBanner:(AppnextUILargeBannerViewExample *)banner
{
    __strong id<AppnextNativeAdsCarouselViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(onError:forCarousel:forBanner:)])
    {
        [strongDelegate onError:error forCarousel:self forBanner:banner];
    }
}

@end
