//
//  AppnextUILargeBannerViewExample.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 12/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "AppnextUILargeBannerViewExample.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppnextExampleUtils.h"
#import "AppnextUIMoviePlayerControllerExample.h"

#define kDefaultBannerBorderWidth 1.f

#define kContentViewSpacing 4.f

#define kDetailsViewHeight 44.f
#define kDetailsViewSideSpacing 6.f
#define kDetailsViewTopSpacing 20.f
#define kDetailsViewBottomSpacing 14.f
#define kDetailsIntenalViewSpacing 2.f

#define kAppImageCornerRadius 4.f
#define kAppImageRightSpacing 8.f

#define kAppTitleHeight 20.f
#define kAppTitleTopMargin 5.f
#define kAppTitleToStarRatingSpacing 3.f
#define kAppRatingHeight 12.f
#define kAppRatingWidth 20.f
#define kAppRatingLeftSpacing 1.f
#define kAppRatingToStarSpacing 3.f
#define kStarsImageSize 11.f
#define kStarsImageYAddition 1.f

#define kInstallButtonWidth 75.f
#define kInstallButtonHeight 28.f

#define kPrivacyButtonSize 17.f
#define kPrivacyButtonOpacity 0.15f

static BOOL kHidePrivacy = NO;

static NSString * const kAppnextStarImage = @"iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAALAAAAKAAAAAsAAAALAAAA0hPfvzsAAACeSURBVEgNrJBNCoAgFIS9RMcJWgadosMErf3BU3gHV9W2w7SueZJgYPkgheGRznyNCsFcxpiexLTzbUqpjcRPMJzUFNCTVLU1gGsEYy6MLmULQF0CDa1pr5wsOADxGbAvxL6PpZRDBhpa09lnGoYGagEYtdYTpsP3jnm8QZP94/a6OzsSC2oETDYxxjf8O224Df4w14IT6/FENeAp9AIAAP//VqLwwgAAALJJREFUrZLBCYQwFERlK9iKZDuwgr1bgsdc9hxIcvZuCXZgAbZgHbszi0rI/x9UFILJ5M1DEqsqe1JKnxjj98pgN1PJKaTdBXEnTUoSQhiOyskqCj2CdDwqJqtblBTwckK8KAoZee+fJ6T/i2ZHmooEt1sbYh6PekTsFBq5RLktxBPWr43kHINZ/lu22775xi2ntTTjSxoL5B64mSw7FrfnAHuU3s65xx4aEzJk2TGQ++Mf+5paZPtkX+8AAAAASUVORK5CYII=";

static NSString * const kAppnextPrivacyImage = @"iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAARAAAAKAAAABEAAAARAAAB423Zj6gAAAGvSURBVFgJ7JRPKARRHMd38yfZgy0pbltc3LhqD5tkT3IXJ2c5cNiDwx6UlJKDzUFxcEAOQlyUvTmJlLNCDrRRIrQZn9+a3XbmvXm9aa6+9dlmft/v7/d2Z+e9WOxfEZ+A4zgJGIYcrMMu7MEmzMEIJCMuE9zO8AHYhg8Q/cADXMIF3EEZRN9wAFmIB08N4TCoB05A9AwrMAQJ/xhqLZCGBbgH0Tn0+7Oh7hkwAW/wAjPQajuAbBNMwiPIE5q17fXkaJT/W3QKXR4zxA29bbADojWw/6sIy68XbUBjiHW1UWbEYR5Ey9qQv0hwEMqwBQ1+P8o98xZBNG6cQ0C25i3cgPX7YBxaZzKzAc5A3rnOOst7iSlng2zLtNfR35FLQt7F6uwgK7vwEwraqRjN8ASH2oCmSFYOsar2NRFtiYZV+IIOJUBxFERZxQwokC1WOv4+igExpUy81+2b0pmytUpg/YKS7YNXl4wy1FCg5xqOlQjFKzhSDEOBfAoyLilDVLHoKUBJZ7xjLCmGoUA+D1XlDVHFomnabWyvmRTkOBblakWLC/JRvshYZUXH6ZalfgEAAP//r87SwQAAAaFJREFU7ZXPK0RRFMdnDBYoKYo1Fra2s5lYjI3sFeUPkJSEolmwkQULEwvJRshuJjaytSIpa6EslGwQkutznjc979375v3aOvWZ++453++5pzfvzaRShFKqDiRmZB820Bcs1+9HIaxPdFiGbW+ny0fyFVZcyYAN+iSDTNiDtLqOIXkJZVcyYJNwkCL+J+0IkhtSgIxW9EmgTXJHrvAfaa1JDoFEXiv6JNDGGgRfjxxEjGutSdbDI5S0ok8CbdxB1vF+QJuxNYVZ+IasUeBJoos8CJ4ueIeip52zpdgIN3ANDU7FfIUmBzKMkDOrnCyaDJzCM3Q4FcMVgn74gl2oMUhip+i3DBIjoZognLLkSm2z1oYyVRHRIw2LILFWRaqXMMxbNqVOWNt1RbgM3mbYs3ttsqbDOf+oMI3CC8h3OgmBz03Fjlb+NsbgAT5hulKLtdKgG45BQl7vVegDbShy8hOQhSW4A4kz6I11uMlEMzlgH95AQl7ze7iAc7gFecgl5A6UYACifxWmAbw5GjdBHuZgCw7gEHZgAQahxev730e9Az/BiyZ6pCIxFgAAAABJRU5ErkJggg==";

@interface AppnextUILargeBannerViewExample()<AppnextNativeAdOpenedDelegate, AppnextUIMoviePlayerControlsExampleDelegate, AppnextPrivacyClickedDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) AppnextUIMoviePlayerControllerExample *moviePlayer;

@property (nonatomic, strong) UIView *detailsView;
@property (nonatomic, strong) UIView *detailsInternalView;
@property (nonatomic, strong) UIImageView *appImageView;

@property (nonatomic, strong) UIView *middleDetailsView;
@property (nonatomic, strong) UILabel *appTitleLabel;
@property (nonatomic, strong) UILabel *appRatingLabel;
@property (nonatomic, strong) UIImageView *appRatingImageView;

@property (nonatomic, strong) UIButton *installButton;
@property (nonatomic, strong) UIButton *privacyButton;

@property (nonatomic, assign) BOOL impressionAlreadySent;

@end

@implementation AppnextUILargeBannerViewExample

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

- (instancetype) initWithAdData:(AppnextAdData *)adData withNativeAdsSDKApi:(AppnextNativeAdsSDKApi *)api
{
    CGRect rect = CGRectMake(0, 0, kDefaultBannerWidth, kDefaultBannerHeight);
    if (self = [super initWithFrame:rect])
    {
        [self internalInit];
        self.adData = adData;
        self.api = api;
    }

    return self;
}

- (void) dealloc
{
    [self.installButton removeTarget:self action:@selector(installButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.privacyButton removeTarget:self action:@selector(privacyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    // notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self layoutInternalViews];
}

#pragma mark - Public Methods

- (void) adImpression
{
    if (self.api && self.adData && !self.impressionAlreadySent)
    {
        [self.api adImpression:self.adData];
        self.impressionAlreadySent = YES;
    }
}

- (void) play
{
    if (self.moviePlayer)
    {
        [self.moviePlayer play];
    }
}

- (void) pause
{
    if (self.moviePlayer)
    {
        [self.moviePlayer pause];
    }
}

- (void) stop
{
    if (self.moviePlayer)
    {
        [self.moviePlayer stop];
    }
}

#pragma mark - Setters/Getters

- (void) setAdData:(AppnextAdData *)adData
{
    _adData = adData;
    self.impressionAlreadySent = NO;
    [self reloadViews];
}

# pragma mark - Actions

- (void) installButtonTouchUpInside:(id)sender
{
    [self performInstallClicked];
    if (self.api && self.adData)
    {
        [self.api adClicked:self.adData withAdOpenedDelegate:self];
    }
}

- (void) privacyButtonTouchUpInside:(id)sender
{
    [self performPrivacyClicked];
    if (self.api && self.adData)
    {
        [self.api privacyClicked:self.adData withPrivacyClickedDelegate:self];
    }
}

#pragma mark - Internal Methods

- (void) reloadViews
{
    [self.moviePlayer stop];
    NSString *videoUrlString = [self getVideoUrlStringForAd:self.adData];
    [self.moviePlayer setContentURL:(videoUrlString.length ? [NSURL URLWithString:videoUrlString] : nil)];
    [self.moviePlayer.controls setCoverImageUrl:(self.adData && self.adData.urlImgWide.length) ? self.adData.urlImgWide : @""];

    self.appTitleLabel.text = (self.adData && self.adData.title.length) ? self.adData.title : @"";
    self.appRatingLabel.text = (self.adData && self.adData.storeRating.length) ? self.adData.storeRating : @"";
    [AppnextExampleUtils setButton:self.installButton titleForAllStates:((self.adData && self.adData.buttonText.length) ? self.adData.buttonText : @"Install")];

    [self.appImageView setImage:[AppnextExampleUtils imageWithColor:[AppnextExampleUtils colorFromHexString:@"#818285"]]];
    if (self.adData && self.adData.urlImg.length)
    {
        [self.appImageView sd_setImageWithURL:[NSURL URLWithString:self.adData.urlImg]
                             placeholderImage:[AppnextExampleUtils imageWithColor:[AppnextExampleUtils colorFromHexString:@"#818285"]]];
    }
    [self layoutInternalViews];
}

- (void) layoutInternalViews
{
    self.contentView.frame = CGRectMake(kContentViewSpacing, kContentViewSpacing, self.frame.size.width - (2 * kContentViewSpacing), self.frame.size.height - (2 * kContentViewSpacing));
    [self.moviePlayer setFrame:CGRectMake(0.f, 0.f, self.contentView.bounds.size.width, self.contentView.bounds.size.height - (kDetailsViewHeight + kDetailsViewTopSpacing + kDetailsViewBottomSpacing))];

    self.detailsView.frame = CGRectMake(kDetailsViewSideSpacing, self.contentView.bounds.size.height - (kDetailsViewHeight + kDetailsViewBottomSpacing), self.contentView.bounds.size.width - (2 * kDetailsViewSideSpacing), kDetailsViewHeight);
    self.detailsInternalView.frame = CGRectMake(0.f, 0.f, self.detailsView.bounds.size.width - (kInstallButtonWidth + kDetailsIntenalViewSpacing), self.detailsView.bounds.size.height);
    self.appImageView.frame = CGRectMake(0.f, 0.f, self.detailsInternalView.bounds.size.height, self.detailsInternalView.bounds.size.height);

    CGFloat middleComponentsXPos = self.appImageView.frame.origin.x + self.appImageView.frame.size.width + kAppImageRightSpacing;
    CGFloat middleComponentsWidth = self.detailsInternalView.frame.size.width - middleComponentsXPos;

    self.middleDetailsView.frame = CGRectMake(middleComponentsXPos, 0.f, middleComponentsWidth, self.detailsInternalView.bounds.size.height);
    self.appTitleLabel.frame = CGRectMake(0.f, kAppTitleTopMargin, middleComponentsWidth, kAppTitleHeight);

    CGFloat ratingYPos = self.appTitleLabel.frame.origin.y + self.appTitleLabel.frame.size.height + kAppTitleToStarRatingSpacing;

    CGSize appRatingLabelFitSize = [self.appRatingLabel sizeThatFits:CGSizeMake(kAppRatingWidth, kAppRatingHeight)];
    self.appRatingLabel.frame = CGRectMake(kAppRatingLeftSpacing, ratingYPos, appRatingLabelFitSize.width, kAppRatingHeight);

    self.appRatingImageView.frame = CGRectMake(self.appRatingLabel.frame.origin.x + self.appRatingLabel.frame.size.width + kAppRatingToStarSpacing, ratingYPos + kStarsImageYAddition, kStarsImageSize, kStarsImageSize);
    self.installButton.frame = CGRectMake(self.detailsView.bounds.size.width - kInstallButtonWidth, self.detailsView.bounds.size.height - kInstallButtonHeight, kInstallButtonWidth, kInstallButtonHeight);
    self.privacyButton.frame = CGRectMake(self.contentView.bounds.size.width - kPrivacyButtonSize, 0.f, kPrivacyButtonSize, kPrivacyButtonSize);
}

- (NSString *) getVideoUrlStringForAd:(AppnextAdData *)adData
{
    NSString *videoUrl = @"";

    if (adData)
    {
        switch ([self getPreferredVideoLengthType])
        {
            case ANVideoLengthLong:
                if (adData.urlVideo30SecHigh.length)
                {
                    videoUrl = adData.urlVideo30SecHigh;
                }
                else if (adData.urlVideo30Sec.length)
                {
                    videoUrl = adData.urlVideo30Sec;
                }
                else if (adData.urlVideoHigh.length)
                {
                    videoUrl = adData.urlVideoHigh;
                }
                else if (adData.urlVideo.length)
                {
                    videoUrl = adData.urlVideo;
                }
                break;
            case ANVideoLengthShort:
            case ANVideoLengthManaged:
            default:
                if (adData.urlVideoHigh.length)
                {
                    videoUrl = adData.urlVideoHigh;
                }
                else if (adData.urlVideo.length)
                {
                    videoUrl = adData.urlVideo;
                }
                else if (adData.urlVideo30SecHigh.length)
                {
                    videoUrl = adData.urlVideo30SecHigh;
                }
                else if (adData.urlVideo30Sec.length)
                {
                    videoUrl = adData.urlVideo30Sec;
                }
                break;
        }
    }
    
    return videoUrl;
}

- (ANVideoLength) getPreferredVideoLengthType
{
    ANVideoLength videoLengthType = ANVideoLengthLong;
    return videoLengthType;
}

# pragma mark - Construct/Destruct Helpers

- (void) internalInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.borderColor = [AppnextExampleUtils colorFromHexString:@"#6f6f6f"].CGColor;
    self.layer.borderWidth = kDefaultBannerBorderWidth;

    [self createUIComponents];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void) createUIComponents
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(kContentViewSpacing, kContentViewSpacing, self.frame.size.width - (2 * kContentViewSpacing), self.frame.size.height - (2 * kContentViewSpacing))];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.hidden = NO;
    self.contentView.clipsToBounds = YES;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.contentView];

    self.moviePlayer = [[AppnextUIMoviePlayerControllerExample alloc] initWithFrame:CGRectMake(0.f, 0.f, self.contentView.bounds.size.width, self.contentView.bounds.size.height - (kDetailsViewHeight + kDetailsViewTopSpacing + kDetailsViewBottomSpacing))];
    self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.moviePlayer setMovieSourceType:MPMovieSourceTypeUnknown];
    [self.moviePlayer setShouldAutoplay:NO];
    [self.contentView addSubview:self.moviePlayer.view];

    //
    // Create the controls
    AppnextUIMoviePlayerControlsExample *movieControls = [[AppnextUIMoviePlayerControlsExample alloc] initWithMoviePlayer:self.moviePlayer];
    [self.moviePlayer setControls:movieControls];
    self.moviePlayer.controls.delegate = self;

    self.detailsView = [[UIView alloc] initWithFrame:CGRectMake(kDetailsViewSideSpacing, self.contentView.bounds.size.height - (kDetailsViewHeight + kDetailsViewBottomSpacing), self.contentView.bounds.size.width - (2 * kDetailsViewSideSpacing), kDetailsViewHeight)];
    self.detailsView.backgroundColor = [UIColor clearColor];
    self.detailsView.hidden = NO;
    self.detailsView.clipsToBounds = YES;
    self.detailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:self.detailsView];

    self.detailsInternalView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.detailsView.bounds.size.width - (kInstallButtonWidth + kDetailsIntenalViewSpacing), self.detailsView.bounds.size.height)];
    self.detailsInternalView.backgroundColor = [UIColor clearColor];
    self.detailsInternalView.hidden = NO;
    self.detailsInternalView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.detailsView addSubview:self.detailsInternalView];

    self.appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.detailsInternalView.bounds.size.height, self.detailsInternalView.bounds.size.height)];
    self.appImageView.hidden = NO;
    self.appImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.appImageView.layer.cornerRadius = kAppImageCornerRadius;
    self.appImageView.layer.masksToBounds = YES;
    [self.detailsInternalView addSubview:self.appImageView];

    CGFloat middleComponentsXPos = self.appImageView.frame.origin.x + self.appImageView.frame.size.width + kAppImageRightSpacing;
    CGFloat middleComponentsWidth = self.detailsInternalView.frame.size.width - middleComponentsXPos;

    self.middleDetailsView = [[UIView alloc] initWithFrame:CGRectMake(middleComponentsXPos, 0.f, middleComponentsWidth, self.detailsInternalView.bounds.size.height)];
    self.middleDetailsView.backgroundColor = [UIColor clearColor];
    self.middleDetailsView.hidden = NO;
    self.middleDetailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.detailsInternalView addSubview:self.middleDetailsView];

    self.appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, kAppTitleTopMargin, middleComponentsWidth, kAppTitleHeight)];
    self.appTitleLabel.numberOfLines = 1;
    self.appTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];
    self.appTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.appTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.appTitleLabel.textColor = [UIColor blackColor];
    self.appTitleLabel.backgroundColor = [UIColor clearColor];
    self.appTitleLabel.alpha = 1.0f;
    self.appTitleLabel.hidden = NO;
    self.appTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.middleDetailsView addSubview:self.appTitleLabel];

    CGFloat ratingYPos = self.appTitleLabel.frame.origin.y + self.appTitleLabel.frame.size.height + kAppTitleToStarRatingSpacing;

    self.appRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAppRatingLeftSpacing, ratingYPos, kAppRatingWidth, kAppRatingHeight)];
    self.appRatingLabel.numberOfLines = 1;
    self.appRatingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.f];
    self.appRatingLabel.textAlignment = NSTextAlignmentLeft;
    self.appRatingLabel.lineBreakMode = NSLineBreakByClipping;
    self.appRatingLabel.textColor = [AppnextExampleUtils colorFromHexString:@"#818285"];
    self.appRatingLabel.backgroundColor = [UIColor clearColor];
    self.appRatingLabel.alpha = 1.0f;
    self.appRatingLabel.hidden = NO;
    self.appRatingLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.middleDetailsView addSubview:self.appRatingLabel];

    CGSize appRatingLabelFitSize = [self.appRatingLabel sizeThatFits:CGSizeMake(kAppRatingWidth, kAppRatingHeight)];
    self.appRatingLabel.frame = CGRectMake(0.f, ratingYPos, appRatingLabelFitSize.width, kAppRatingHeight);

    NSData *appRatingImageData = [AppnextExampleUtils dataFromBase64String:kAppnextStarImage];
    UIImage *appRatingImage = [UIImage imageWithData:appRatingImageData];
    self.appRatingImageView = [[UIImageView alloc] initWithImage:appRatingImage];
    self.appRatingImageView.hidden = NO;
    self.appRatingImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.appRatingImageView.frame = CGRectMake(self.appRatingLabel.frame.origin.x + self.appRatingLabel.frame.size.width + kAppRatingToStarSpacing, ratingYPos + kStarsImageYAddition, kStarsImageSize, kStarsImageSize);
    [self.middleDetailsView addSubview:self.appRatingImageView];

    self.installButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.installButton.frame = CGRectMake(self.detailsView.bounds.size.width - kInstallButtonWidth, self.detailsView.bounds.size.height - kInstallButtonHeight, kInstallButtonWidth, kInstallButtonHeight);
    self.appRatingImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    self.installButton.hidden = NO;
    self.installButton.layer.masksToBounds = YES;
    self.installButton.layer.cornerRadius = 4.0f;
    self.installButton.titleLabel.numberOfLines = 1;
    self.installButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.f];
    self.installButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.installButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.installButton.backgroundColor = [AppnextExampleUtils colorFromHexString:@"#55a11e"];
    [AppnextExampleUtils setButton:self.installButton titleForAllStates:@"Install"];
    [AppnextExampleUtils setButton:self.installButton titleColorForAllStates:[UIColor whiteColor]];
    [self.installButton addTarget:self action:@selector(installButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView addSubview:self.installButton];

    NSData *privacyImageData = [AppnextExampleUtils dataFromBase64String:kAppnextPrivacyImage];
    UIImage *privacyImage = [UIImage imageWithData:privacyImageData];
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privacyButton.frame = CGRectMake(self.contentView.bounds.size.width - kPrivacyButtonSize, 0.f, kPrivacyButtonSize, kPrivacyButtonSize);
    self.privacyButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kPrivacyButtonOpacity];
    self.privacyButton.hidden = kHidePrivacy;
    [AppnextExampleUtils setButton:self.privacyButton imageForAllStates:privacyImage];
    [AppnextExampleUtils setButton:self.privacyButton titleForAllStates:@""];
    self.privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.privacyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.privacyButton addTarget:self action:@selector(privacyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.privacyButton];

    [self reloadViews];
}

#pragma mark - App NSNotifications

- (void) applicationWillResignActive:(NSNotification *)aNotfication
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) applicationDidBecomeActive:(NSNotification *)aNotfication
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - AppnextNativeAdOpenedDelegate Methods

- (void) storeOpened:(AppnextAdData *)adData
{
    [self performWillLeaveApplication];
}

- (void) onError:(NSString *)error forAdData:(AppnextAdData *)adData
{
    [self performOnError:error];
}

#pragma mark - AppnextPrivacyClickedDelegate Methods

- (void) successOpeningAppnextPrivacy:(AppnextAdData *)adData
{
    [self performWillLeaveApplication];
}

- (void) failureOpeningAppnextPrivacy:(AppnextAdData *)adData
{
}

#pragma mark - AppnextUIMoviePlayerControlsExampleDelegate Methods

- (void) videoPlayerPlaybackDidStart
{
    if (self.api && self.adData)
    {
        [self.api videoStarted:self.adData];
    }
}

- (void) videoPlayerPlaybackDidEnd
{
    if (self.api && self.adData)
    {
        [self.api videoEnded:self.adData];
    }
}

#pragma mark - AppnextUIBannerViewExampleDelegate Callbacks

- (void) performInstallClicked
{
    __strong id<AppnextUILargeBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(installClicked:)])
    {
        [strongDelegate installClicked:self];
    }
}

- (void) performPrivacyClicked
{
    __strong id<AppnextUILargeBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(privacyClicked:)])
    {
        [strongDelegate privacyClicked:self];
    }
}

- (void) performWillLeaveApplication
{
    __strong id<AppnextUILargeBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(willLeaveApplication:)])
    {
        [strongDelegate willLeaveApplication:self];
    }
}

- (void) performOnError:(NSString *)error
{
    __strong id<AppnextUILargeBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(onError:forBanner:)])
    {
        [strongDelegate onError:error forBanner:self];
    }
}

@end
