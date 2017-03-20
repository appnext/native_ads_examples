//
//  AppnextUIBannerViewExample.m
//  AppnextNativeAdsSDKBannerTest
//
//  Created by Eran Mausner on 10/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "AppnextUIBannerViewExample.h"
#import <QuartzCore/QuartzCore.h>
#import <AppnextNativeAdsSDK/AppnextNativeAdsSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define kDefaultAutoRefrashInterval 60.f
#define kMinAutoRefrashInterval 15.f

#define kDefaultBannerWidth 320.f
#define kDefaultBannerHeight 50.f
#define kDefaultBannerBorderWidth 1.f

#define kDetailsViewSpacing 6.f
#define kDetailsIntenalViewSpacing 2.f

#define kAppImageCornerRadius 4.f
#define kAppImageRightSpacing 8.f

#define kAppTitleHeight 20.f
#define kAppTitleToStarRatingSpacing 3.f
#define kAppRatingHeight 12.f
#define kAppRatingWidth 20.f
#define kAppRatingToStarSpacing 3.f
#define kStarsImageSize 11.f
#define kStarsImageYAddition 1.f

#define kInstallButtonWidth 75.f
#define kInstallButtonHeight 28.f

#define kPrivacyButtonSize 13.f
#define kPrivacyButtonSpacing 0.f
#define kPrivacyButtonOpacity 0.15f

static BOOL kHidePrivacy = NO;

static NSString * const kAppnextStarImage = @"iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAALAAAAKAAAAAsAAAALAAAA0hPfvzsAAACeSURBVEgNrJBNCoAgFIS9RMcJWgadosMErf3BU3gHV9W2w7SueZJgYPkgheGRznyNCsFcxpiexLTzbUqpjcRPMJzUFNCTVLU1gGsEYy6MLmULQF0CDa1pr5wsOADxGbAvxL6PpZRDBhpa09lnGoYGagEYtdYTpsP3jnm8QZP94/a6OzsSC2oETDYxxjf8O224Df4w14IT6/FENeAp9AIAAP//VqLwwgAAALJJREFUrZLBCYQwFERlK9iKZDuwgr1bgsdc9hxIcvZuCXZgAbZgHbszi0rI/x9UFILJ5M1DEqsqe1JKnxjj98pgN1PJKaTdBXEnTUoSQhiOyskqCj2CdDwqJqtblBTwckK8KAoZee+fJ6T/i2ZHmooEt1sbYh6PekTsFBq5RLktxBPWr43kHINZ/lu22775xi2ntTTjSxoL5B64mSw7FrfnAHuU3s65xx4aEzJk2TGQ++Mf+5paZPtkX+8AAAAASUVORK5CYII=";

static NSString * const kAppnextPrivacyImage = @"iVBORw0KGgoAAAANSUhEUgAAABoAAAAaCAYAAACpSkzOAAAAAXNSR0IArs4c6QAAABxpRE9UAAAAAgAAAAAAAAANAAAAKAAAAA0AAAANAAABVSJ2o9sAAAEhSURBVEgN5NO/K4RxHAfwO3WpY/CzDJJiJZGUUmZ/wk3KoqRMFsttymqRVbKbZBZJLIyKLFYiynJe38vdc/d95EE2T73q+/2839/nuXu6y+X+/VWpVNrp+vMX4aa9rHHCM7Xr1eKKDYZ//WCHWynzxCmrTDNAD6MscsAb23T/6IEO9BFufs1c1mGdCY65YySrX80Vi5xxSOe3DinpFtjinv7Mc0o7nFPMLEcFZ/LscUEhipOtcIoXhpJp80o2z0rzNNnJ2rhlOZlGK+E+m9G4vpWNUbtm60G0UFjghpYoqr7j8P8Iv57xVPgxkHUQPu0Dg1/0wrcKP//JVMdwhkfyqbBhIC8HDaNPlzpHLKVCwxKXqSAa6FSvaJzaKu2yXgveAQAA//+4ZjxoAAABKUlEQVTlkjFLglEUhpVCDAdBdGgqcFEcWiUkbYiGhgia/AfO/gOJoEZXdweXwFGnBqEfYD8hBwnUWmqQr+dcPB/cj3MH5w48nHve9z33g8uXSu0qiqI2vOsc6mRchXzVCQ3hWee4I17BKhYCBzKuAnYsE3qFbizoAbEIW6ipZnV8V5anGoEj+IZL1byOMYOeJyYGfFcJ2RsJ3MMnZDxDB4w72EBJtWTHc5XUdcY8hDk8qmZ2AvK2YziwAugtwfJEw3uAD8iHMk4ncAJL6IP5sdAF5DvwAxehjKcTPIMFTOHUM42BTAEGIM9+Y0TCEgvH8AK/IJdcQ043OGfgHJ5gBW9QVX/vznIdRvAFUmuQp5WSZ5rALaT3vtxa4CL5m8rQgCZUIGtl/4f2B2suaLPKK6SwAAAAAElFTkSuQmCC";

@interface AppnextUIBannerViewExample()<AppnextNativeAdsRequestDelegate, AppnextNativeAdOpenedDelegate, AppnextPrivacyClickedDelegate>

@property (nonatomic, strong) AppnextNativeAdsSDKApi *api;
@property (nonatomic, strong) AppnextAdData *adData;
@property (nonatomic, assign) BOOL startedAutoRefresh;

@property (nonatomic, strong) UIView *detailsView;
@property (nonatomic, strong) UIView *detailsInternalView;
@property (nonatomic, strong) UIImageView *appImageView;

@property (nonatomic, strong) UIView *middleDetailsView;
@property (nonatomic, strong) UILabel *appTitleLabel;
@property (nonatomic, strong) UILabel *appRatingLabel;
@property (nonatomic, strong) UIImageView *appRatingImageView;

@property (nonatomic, strong) UIButton *installButton;
@property (nonatomic, strong) UIButton *coverInstallButton;
@property (nonatomic, strong) UIButton *privacyButton;

@end

@implementation AppnextUIBannerViewExample

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
    CGRect rect = CGRectMake(0, 0, kDefaultBannerWidth, kDefaultBannerHeight);
    if (self = [super initWithFrame:rect])
    {
        [self internalInit];
        self.placementID = placementID;
    }
    
    return self;
}

- (void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendAdImpression) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshAd) object:nil];
    [self.installButton removeTarget:self action:@selector(installButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.coverInstallButton removeTarget:self action:@selector(installButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
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

- (void) loadAd
{
    if (self.api)
    {
        AppnextNativeAdsRequest *request = [[AppnextNativeAdsRequest alloc] init];
        request.count = 1;
        request.creativeType = ANCreativeTypeManaged;
        request.categories = self.categories;
        request.postback = self.postback;
        [self.api loadAds:request withRequestDelegate:self];

        self.startedAutoRefresh = self.autoRefrash;
        if (self.autoRefrash)
        {
            [self performSelector:@selector(refreshAd) withObject:nil afterDelay:self.refrashInterval];
        }
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

- (void) setAutoRefrash:(BOOL)autoRefrash
{
    if (_autoRefrash != autoRefrash)
    {
        _autoRefrash = autoRefrash;
        if (!_autoRefrash)
        {
            self.startedAutoRefresh = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshAd) object:nil];
        }
    }
}

- (void) setRefrashInterval:(NSTimeInterval)refrashInterval
{
    if (refrashInterval < kMinAutoRefrashInterval)
    {
        refrashInterval = kMinAutoRefrashInterval;
    }

    _refrashInterval = refrashInterval;
}

- (void) setAdData:(AppnextAdData *)adData
{
    _adData = adData;
    [self reloadViews];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendAdImpression) object:nil];
    [self performSelector:@selector(sendAdImpression) withObject:nil afterDelay:2.0f];
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

- (void) sendAdImpression
{
    if (self.api && self.adData)
    {
        [self.api adImpression:self.adData];
    }
}

- (void) refreshAd
{
    [self loadAd];
}

- (void) reloadViews
{
    self.appTitleLabel.text = (self.adData && self.adData.title.length) ? self.adData.title : @"";
    self.appRatingLabel.text = (self.adData && self.adData.storeRating.length) ? self.adData.storeRating : @"";
    [self.class setButton:self.installButton titleForAllStates:((self.adData && self.adData.buttonText.length) ? self.adData.buttonText : @"Install")];
    [self.appImageView setImage:[self.class imageWithColor:[self.class colorFromHexString:@"#818285"]]];
    if (self.adData && self.adData.urlImg.length)
    {
        [self.appImageView sd_setImageWithURL:[NSURL URLWithString:self.adData.urlImg]
                             placeholderImage:[self.class imageWithColor:[self.class colorFromHexString:@"#818285"]]];
    }

    [self layoutInternalViews];
}

- (void) layoutInternalViews
{
    self.detailsView.frame = CGRectMake(kDetailsViewSpacing, kDetailsViewSpacing, self.frame.size.width - (2 * kDetailsViewSpacing), kDefaultBannerHeight - (2 * kDetailsViewSpacing));
    self.detailsInternalView.frame = CGRectMake(0.f, 0.f, self.detailsView.bounds.size.width - kInstallButtonWidth - kDetailsIntenalViewSpacing, self.detailsView.bounds.size.height);
    self.appImageView.frame = CGRectMake(0.f, 0.f, self.detailsInternalView.bounds.size.height, self.detailsInternalView.bounds.size.height);
    
    CGFloat middleComponentsXPos = self.appImageView.frame.origin.x + self.appImageView.frame.size.width + kAppImageRightSpacing;
    CGFloat middleComponentsWidth = self.detailsInternalView.frame.size.width - middleComponentsXPos;
    
    self.middleDetailsView.frame = CGRectMake(middleComponentsXPos, 0.f, middleComponentsWidth, self.detailsInternalView.bounds.size.height);
    self.appTitleLabel.frame = CGRectMake(0.f, 0.f, middleComponentsWidth, kAppTitleHeight);
    
    CGFloat ratingYPos = self.appTitleLabel.frame.origin.y + self.appTitleLabel.frame.size.height + kAppTitleToStarRatingSpacing;
    
    CGSize appRatingLabelFitSize = [self.appRatingLabel sizeThatFits:CGSizeMake(kAppRatingWidth, kAppRatingHeight)];
    self.appRatingLabel.frame = CGRectMake(0.f, ratingYPos, appRatingLabelFitSize.width, kAppRatingHeight);
    self.appRatingImageView.frame = CGRectMake(self.appRatingLabel.frame.origin.x + self.appRatingLabel.frame.size.width + kAppRatingToStarSpacing, ratingYPos + kStarsImageYAddition, kStarsImageSize, kStarsImageSize);
    self.coverInstallButton.frame = self.detailsInternalView.bounds;
    self.installButton.frame = CGRectMake(self.detailsView.bounds.size.width - kInstallButtonWidth, self.detailsView.bounds.size.height - kInstallButtonHeight, kInstallButtonWidth, kInstallButtonHeight);
    self.privacyButton.frame = CGRectMake(self.bounds.size.width - kPrivacyButtonSize, kPrivacyButtonSpacing, kPrivacyButtonSize, kPrivacyButtonSize);
}

#pragma mark - Class Methods

+ (void) setButton:(UIButton *)button titleForAllStates:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateApplication];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateReserved];
    [button setTitle:title forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateSelected];
}

+ (void) setButton:(UIButton *)button titleColorForAllStates:(UIColor *)color
{
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateApplication];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    [button setTitleColor:color forState:UIControlStateReserved];
    [button setTitleColor:color forState:UIControlStateDisabled];
    [button setTitleColor:color forState:UIControlStateSelected];
}

+ (void) setButton:(UIButton *)button imageForAllStates:(UIImage *)image
{
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateApplication];
    [button setImage:image forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateReserved];
    [button setImage:image forState:UIControlStateDisabled];
    [button setImage:image forState:UIControlStateSelected];
}

+ (UIImage *) imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *) colorFromHexString:(NSString *)hexString
{
    if (hexString && hexString.length > 0)
    {
        unsigned rgbValue = 0;
        NSRange colorSignRange = [hexString rangeOfString:@"#"];
        if ([self rangeIsValid:colorSignRange onString:hexString])
        {
            hexString = [hexString substringFromIndex:(colorSignRange.location + colorSignRange.length)];
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner scanHexInt:&rgbValue];
        
        float t1 = ((rgbValue & 0xFF0000) >> 16)/255.0;
        float t2 = ((rgbValue & 0xFF00) >> 8)/255.0;
        float t3 = (rgbValue & 0xFF)/255.0;
        
        UIColor *col = [UIColor colorWithRed:t1 green:t2 blue:t3 alpha:1.0];
        return col;
    }
    
    return nil;
}

+ (BOOL) rangeIsValid:(NSRange)range onString:(NSString *)str
{
    if ((range.location != NSNotFound) &&
        (range.length != NSNotFound) &&
        (range.location <= str.length) &&
        ((range.location + range.length) <= str.length))
    {
        return YES;
    }
    
    return NO;
}

+ (NSData *) dataFromBase64String:(NSString *)aString
{
    NSData *data = [aString dataUsingEncoding:NSASCIIStringEncoding];
    size_t outputLength;
    void *outputBuffer = NewBase64Decode([data bytes], [data length], &outputLength);
    NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
    free(outputBuffer);
    return result;
}

//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
#define xx 65

//
// Mapping from ASCII character to 6 bit pattern.
//
static unsigned char base64DecodeLookup[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
};

#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength)
{
    if (length == -1)
    {
        length = strlen(inputBuffer);
    }
    
    size_t outputBufferSize =
    ((length+BASE64_UNIT_SIZE-1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
    unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize);
    
    size_t i = 0;
    size_t j = 0;
    while (i < length)
    {
        //
        // Accumulate 4 valid characters (ignore everything else)
        //
        unsigned char accumulated[BASE64_UNIT_SIZE];
        size_t accumulateIndex = 0;
        while (i < length)
        {
            unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
            if (decode != xx)
            {
                accumulated[accumulateIndex] = decode;
                accumulateIndex++;
                
                if (accumulateIndex == BASE64_UNIT_SIZE)
                {
                    break;
                }
            }
        }
        
        //
        // Store the 6 bits from each of the 4 characters as 3 bytes
        //
        // (Uses improved bounds checking suggested by Alexandre Colucci)
        //
        if(accumulateIndex >= 2)
            outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        if(accumulateIndex >= 3)  
            outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);  
        if(accumulateIndex >= 4)  
            outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
        j += accumulateIndex - 1;
    }
    
    if (outputLength)
    {
        *outputLength = j;
    }
    return outputBuffer;
}

# pragma mark - Construct/Destruct Helpers

- (void) internalInit
{
    self.autoRefrash = NO;
    self.refrashInterval = kDefaultAutoRefrashInterval;
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.borderColor = [self.class colorFromHexString:@"#6f6f6f"].CGColor;
    self.layer.borderWidth = kDefaultBannerBorderWidth;
    
    [self createUIComponents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void) createUIComponents
{
    self.detailsView = [[UIView alloc] initWithFrame:CGRectMake(kDetailsViewSpacing, kDetailsViewSpacing, self.frame.size.width - (2 * kDetailsViewSpacing), kDefaultBannerHeight - (2 * kDetailsViewSpacing))];
    self.detailsView.backgroundColor = [UIColor clearColor];
    self.detailsView.hidden = NO;
    self.detailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.detailsView];

    self.detailsInternalView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.detailsView.bounds.size.width - kInstallButtonWidth - kDetailsIntenalViewSpacing, self.detailsView.bounds.size.height)];
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
    self.middleDetailsView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.detailsInternalView addSubview:self.middleDetailsView];

    self.appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, middleComponentsWidth, kAppTitleHeight)];
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

    self.appRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, ratingYPos, kAppRatingWidth, kAppRatingHeight)];
    self.appRatingLabel.numberOfLines = 1;
    self.appRatingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.f];
    self.appRatingLabel.textAlignment = NSTextAlignmentLeft;
    self.appRatingLabel.lineBreakMode = NSLineBreakByClipping;
    self.appRatingLabel.textColor = [self.class colorFromHexString:@"#818285"];
    self.appRatingLabel.backgroundColor = [UIColor clearColor];
    self.appRatingLabel.alpha = 1.0f;
    self.appRatingLabel.hidden = NO;
    self.appRatingLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.middleDetailsView addSubview:self.appRatingLabel];

    CGSize appRatingLabelFitSize = [self.appRatingLabel sizeThatFits:CGSizeMake(kAppRatingWidth, kAppRatingHeight)];
    self.appRatingLabel.frame = CGRectMake(0.f, ratingYPos, appRatingLabelFitSize.width, kAppRatingHeight);

    NSData *appRatingImageData = [self.class dataFromBase64String:kAppnextStarImage];
    UIImage *appRatingImage = [UIImage imageWithData:appRatingImageData];
    self.appRatingImageView = [[UIImageView alloc] initWithImage:appRatingImage];
    self.appRatingImageView.hidden = NO;
    self.appRatingImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.appRatingImageView.frame = CGRectMake(self.appRatingLabel.frame.origin.x + self.appRatingLabel.frame.size.width + kAppRatingToStarSpacing, ratingYPos + kStarsImageYAddition, kStarsImageSize, kStarsImageSize);
    [self.middleDetailsView addSubview:self.appRatingImageView];

    self.coverInstallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverInstallButton.frame = self.detailsInternalView.bounds;
    self.coverInstallButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.coverInstallButton.hidden = NO;
    self.coverInstallButton.backgroundColor = [UIColor clearColor];
    [self.class setButton:self.coverInstallButton titleForAllStates:@""];
    [self.class setButton:self.coverInstallButton titleColorForAllStates:[UIColor clearColor]];
    [self.coverInstallButton addTarget:self action:@selector(installButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsInternalView addSubview:self.coverInstallButton];
    
    self.installButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.installButton.frame = CGRectMake(self.detailsView.bounds.size.width - kInstallButtonWidth, self.detailsView.bounds.size.height - kInstallButtonHeight, kInstallButtonWidth, kInstallButtonHeight);
    self.installButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    self.installButton.hidden = NO;
    self.installButton.layer.masksToBounds = YES;
    self.installButton.layer.cornerRadius = 4.0f;
    self.installButton.titleLabel.numberOfLines = 1;
    self.installButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f];
    self.installButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.installButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.installButton.backgroundColor = [self.class colorFromHexString:@"#55a11e"];
    [self.class setButton:self.installButton titleForAllStates:@"Install"];
    [self.class setButton:self.installButton titleColorForAllStates:[UIColor whiteColor]];
    [self.installButton addTarget:self action:@selector(installButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView addSubview:self.installButton];

    NSData *privacyImageData = [self.class dataFromBase64String:kAppnextPrivacyImage];
    UIImage *privacyImage = [UIImage imageWithData:privacyImageData];
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privacyButton.frame = CGRectMake(self.bounds.size.width - kPrivacyButtonSize, kPrivacyButtonSpacing, kPrivacyButtonSize, kPrivacyButtonSize);
    self.privacyButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kPrivacyButtonOpacity];
    self.privacyButton.hidden = kHidePrivacy;
    [self.class setButton:self.privacyButton imageForAllStates:privacyImage];
    [self.class setButton:self.privacyButton titleForAllStates:@""];
    self.privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.privacyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.privacyButton addTarget:self action:@selector(privacyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.privacyButton];

    [self reloadViews];
}

#pragma mark - App NSNotifications

- (void) applicationWillResignActive:(NSNotification *)aNotfication
{
    if (self.startedAutoRefresh)
    {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshAd) object:nil];
    }
}

- (void) applicationDidBecomeActive:(NSNotification *)aNotfication
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    if (self.autoRefrash)
    {
        [self performSelector:@selector(refreshAd) withObject:nil afterDelay:self.refrashInterval];
    }
}

#pragma mark - AppnextNativeAdsRequestDelegate Methods

- (void) onAdsLoaded:(NSArray<AppnextAdData *> *)ads forRequest:(AppnextNativeAdsRequest *)request
{
    if (!ads || (ads.count == 0))
    {
        [self performOnError:kAdErrorNoAds];
        return;
    }

    AppnextAdData *adData = ads.firstObject;
    if (adData)
    {
        self.adData = adData;
    }
}

- (void) onError:(NSString *)error forRequest:(AppnextNativeAdsRequest *)request
{
    [self performOnError:error];
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
    // Do Nothing
}

#pragma mark - AppnextUIBannerViewExampleDelegate Callbacks

- (void) performInstallClicked
{
    __strong id<AppnextUIBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(installClicked:)])
    {
        [strongDelegate installClicked:self];
    }
}

- (void) performPrivacyClicked
{
    __strong id<AppnextUIBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(privacyClicked:)])
    {
        [strongDelegate privacyClicked:self];
    }
}

- (void) performWillLeaveApplication
{
    __strong id<AppnextUIBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(willLeaveApplication:)])
    {
        [strongDelegate willLeaveApplication:self];
    }
}

- (void) performOnError:(NSString *)error
{
    __strong id<AppnextUIBannerViewExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(onError:forBanner:)])
    {
        [strongDelegate onError:error forBanner:self];
    }
}

@end
