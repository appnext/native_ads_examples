//
//  AppnextUIMoviePlayerControlsExample.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 11/02/2016.
//  Copyright © 2016 Appnext. All rights reserved.
//

#import "AppnextUIMoviePlayerControlsExample.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppnextUIMoviePlayerControllerExample.h"
#import "AppnextExampleUtils.h"

#define kPlayImageSize 56.f

static NSString * const kAppnextPlayImage = @"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";


#pragma mark - AppnextUIMoviePlayerControlsExample()

@interface AppnextUIMoviePlayerControlsExample()

@property (nonatomic, weak) AppnextUIMoviePlayerControllerExample *moviePlayer; // the player owns the controlls and not the other way around.

@property (nonatomic, strong) UIImageView *appWideImageView;
@property (nonatomic, strong) UIView *buttonBackgroundView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIView *activityBackgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AppnextUIMoviePlayerControlsExample

# pragma mark - Life Cycle

- (instancetype) initWithMoviePlayer:(AppnextUIMoviePlayerControllerExample *)moviePlayer
{
    if (moviePlayer == nil)
    {
        return nil;
    }

    if (self = [super initWithFrame:moviePlayer.view.bounds])
    {
        self.backgroundColor = [UIColor clearColor];
        self.moviePlayer = moviePlayer;
        self.state = AppnextUIMoviePlayerControlsExampleStateIdle;

        [self createUIComponents];

        [self resetViewState];
        [self addNotifications];
    }

    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    // use only initWithMoviePlayer
    return nil;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    // use only initWithMoviePlayer
    return nil;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resetViewState];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect myFrame = self.frame;
    CGRect playerFrame = self.moviePlayer.view.frame;
    if ((myFrame.size.width != playerFrame.size.width) || (myFrame.size.height != playerFrame.size.height))
    {
        self.frame = self.moviePlayer.view.bounds;
        self.activityBackgroundView.frame = self.bounds;
        self.activityIndicator.center = self.activityBackgroundView.center;
        self.appWideImageView.frame = self.bounds;
        self.buttonBackgroundView.frame = self.bounds;
        self.playImageView.center = self.buttonBackgroundView.center;
        self.playButton.frame = self.bounds;
    }
}

# pragma mark - Public Methods

- (void) onPlay
{
    self.appWideImageView.hidden = YES;
    self.buttonBackgroundView.hidden = YES;
}

- (void) onPause
{
    self.appWideImageView.hidden = YES;
    self.buttonBackgroundView.hidden = NO;
}

- (void) onStop
{
    self.appWideImageView.hidden = NO;
    self.buttonBackgroundView.hidden = NO;
}

# pragma mark - Setters/Getters
/*
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
*/
- (void) setState:(AppnextUIMoviePlayerControlsExampleState)state
{
    if (_state != state)
    {
        _state = state;
        
        switch (state)
        {
            case AppnextUIMoviePlayerControlsExampleStateLoading:
                [self showLoadingIndicators];
                break;
            case AppnextUIMoviePlayerControlsExampleStateReady:
                [self hideLoadingIndicators];
                break;
            case AppnextUIMoviePlayerControlsExampleStateIdle:
            default:
                break;
        }
        
        [self notifyDelegateControlsStateChanged];
    }
}

- (void) setCoverImageUrl:(NSString *)coverImageUrl
{
    _coverImageUrl = coverImageUrl;
    [self.appWideImageView setImage:[AppnextExampleUtils imageWithColor:[AppnextExampleUtils colorFromHexString:@"#818285"]]];
    if (self.coverImageUrl.length)
    {
        [self.appWideImageView sd_setImageWithURL:[NSURL URLWithString:self.coverImageUrl]
                                 placeholderImage:[AppnextExampleUtils imageWithColor:[AppnextExampleUtils colorFromHexString:@"#818285"]]];
    }
}

# pragma mark - Actions

- (void) playButtonTouchUpInside:(id)sender
{
    MPMoviePlaybackState playbackState = self.moviePlayer.playbackState;
    switch (playbackState)
    {
        case MPMoviePlaybackStatePlaying:
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
        case MPMoviePlaybackStateInterrupted:
            [self.moviePlayer pause];
            break;
        case MPMoviePlaybackStateStopped:
        case MPMoviePlaybackStatePaused:
        default:
            [self.moviePlayer play];
            break;
    }
}

# pragma mark - Construct/Destruct Helpers

- (void) createUIComponents
{
    // On top we add the wait screen and its activity indicator
    self.activityBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.activityBackgroundView.backgroundColor = [UIColor blackColor];
    self.activityBackgroundView.hidden = YES; // We starts hidden
    self.activityBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.activityBackgroundView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.hidden = YES; // We starts hidden
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.activityBackgroundView addSubview:self.activityIndicator];
    self.activityIndicator.center = self.activityBackgroundView.center;

    self.appWideImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.appWideImageView.hidden = NO;
    self.appWideImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.appWideImageView];

    self.buttonBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.buttonBackgroundView.backgroundColor = [UIColor blackColor];
    self.buttonBackgroundView.alpha = 0.3f;
    self.buttonBackgroundView.hidden = NO;
    self.buttonBackgroundView.clipsToBounds = YES;
    self.buttonBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.buttonBackgroundView];

    NSData *playImageData = [AppnextExampleUtils dataFromBase64String:kAppnextPlayImage];
    UIImage *playImage = [UIImage imageWithData:playImageData];
    self.playImageView = [[UIImageView alloc] initWithImage:playImage];
    self.playImageView.frame = CGRectMake(0.f, 0.f, kPlayImageSize, kPlayImageSize);
    self.playImageView.hidden = NO;
    self.playImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.buttonBackgroundView addSubview:self.playImageView];
    self.playImageView.center = self.buttonBackgroundView.center;

    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = self.bounds;
    self.playButton.hidden = NO;
    self.playButton.backgroundColor = [UIColor clearColor];
    [AppnextExampleUtils setButton:self.playButton titleForAllStates:@""];
    [AppnextExampleUtils setButton:self.playButton titleColorForAllStates:[UIColor clearColor]];
    self.playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.playButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.playButton addTarget:self action:@selector(playButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
}

# pragma mark - Notifications

- (void) addNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(movieLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(movieDurationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(movieContentURLDidChange:) name:AppnextUIMoviePlayerExampleContentURLDidChangeNotification object:nil];
}

- (void) movieLoadStateDidChange:(NSNotification *)note
{
    if (note.object != self.moviePlayer)
    {
        return;
    }

    switch (self.moviePlayer.loadState)
    {
        case MPMovieLoadStatePlayable:
        case MPMovieLoadStatePlaythroughOK:
            self.state = AppnextUIMoviePlayerControlsExampleStateReady;
            break;
        case MPMovieLoadStateStalled:
        case MPMovieLoadStateUnknown:
            break;
        default:
            break;
    }
}

- (void) moviePlaybackStateDidChange:(NSNotification *)note
{
    if (note.object != self.moviePlayer)
    {
        return;
    }

    MPMoviePlaybackState playbackState = self.moviePlayer.playbackState;
    switch (playbackState)
    {
        case MPMoviePlaybackStatePlaying:
            [self notifyDelegateVideoPlayerPlaybackDidStart];
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
            self.state = AppnextUIMoviePlayerControlsExampleStateReady;
            break;
        case MPMoviePlaybackStateInterrupted:
            self.state = AppnextUIMoviePlayerControlsExampleStateLoading;
            break;
        case MPMoviePlaybackStateStopped:
            [self resetViewState];
            self.state = AppnextUIMoviePlayerControlsExampleStateIdle;
            break;
        case MPMoviePlaybackStatePaused:
            self.state = AppnextUIMoviePlayerControlsExampleStateIdle;
            break;
        default:
            break;
    }
}

- (void) movieFinished:(NSNotification *)note
{
    if (note.object != self.moviePlayer)
    {
        return;
    }

    if (self.moviePlayer.isPreparedToPlay)
    {
        [self resetViewState];
        self.state = AppnextUIMoviePlayerControlsExampleStateIdle;
    }

    [self notifyDelegateVideoPlayerPlaybackDidEnd];
}

- (void) movieDurationAvailable:(NSNotification *)note
{
    if (note.object != self.moviePlayer)
    {
        return;
    }
}

- (void) movieContentURLDidChange:(NSNotification *)note
{
    if (note.object != self.moviePlayer)
    {
        return;
    }

    [self resetViewState];

    if ([self.moviePlayer.contentURL.scheme isEqualToString:@"file"])
    {
        self.state = AppnextUIMoviePlayerControlsExampleStateReady;
    }
    else
    {
        self.state = AppnextUIMoviePlayerControlsExampleStateLoading;
    }
}

# pragma mark - AppnextUIMoviePlayerControlsExampleDelegate Notifications

- (void) notifyDelegateControlsStateChanged
{
    __strong id<AppnextUIMoviePlayerControlsExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(controlsStateChanged:)])
    {
        [strongDelegate controlsStateChanged:self.state];
    }
}

- (void) notifyDelegateVideoPlayerPlaybackDidStart
{
    __strong id<AppnextUIMoviePlayerControlsExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(videoPlayerPlaybackDidStart)])
    {
        [strongDelegate videoPlayerPlaybackDidStart];
    }
}

- (void) notifyDelegateVideoPlayerPlaybackDidEnd
{
    __strong id<AppnextUIMoviePlayerControlsExampleDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(videoPlayerPlaybackDidEnd)])
    {
        [strongDelegate videoPlayerPlaybackDidEnd];
    }
}

# pragma mark - Internal Methods

- (void) resetViewState
{
    self.appWideImageView.hidden = NO;
    self.buttonBackgroundView.hidden = !(self.moviePlayer && self.moviePlayer.contentURL);
}

- (void) showLoadingIndicators
{
    [self.activityIndicator startAnimating];
    self.activityBackgroundView.alpha = 0.0f;
    self.activityIndicator.alpha = 0.0f;
    self.activityBackgroundView.hidden = NO;
    self.activityIndicator.hidden = NO;

    [UIView animateWithDuration:0.2f animations:^{
        self.activityBackgroundView.alpha = 1.0f;
        self.activityIndicator.alpha = 1.0f;
    }];
}

- (void) hideLoadingIndicators
{
    [UIView animateWithDuration:0.2f delay:0.0f options:0 animations:^{
        self.activityBackgroundView.alpha = 0.0f;
        self.activityIndicator.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.activityBackgroundView.hidden = YES;
        self.activityIndicator.hidden = YES;
    }];
}

@end
