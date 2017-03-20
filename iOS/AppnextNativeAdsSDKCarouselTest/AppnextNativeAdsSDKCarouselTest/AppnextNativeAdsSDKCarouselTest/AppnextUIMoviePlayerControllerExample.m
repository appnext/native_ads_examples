//
//  AppnextUIMoviePlayerControllerExample.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 11/02/2016.
//  Copyright © 2016 Appnext. All rights reserved.
//

#import "AppnextUIMoviePlayerControllerExample.h"

@interface AppnextUIMoviePlayerControllerExample()

@property (nonatomic, assign) BOOL playRequested;

@end

@implementation AppnextUIMoviePlayerControllerExample

# pragma mark - Construct/Destruct

- (instancetype) init
{
    return [self initWithFrame:CGRectZero];
}

//
// URL should be set after initialization so don't use this constructor
- (instancetype) initWithContentURL:(NSURL *)url
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self = [super initWithContentURL:url];
        [self initialize];
        return self; // ios8 changed MPMoviePlayer API - now it enters here every time the movie player is created
    }
    else
    {
        [[NSException exceptionWithName:@"AppnextUIMoviePlayerControllerExample Exception" reason:@"Set contentURL after initialization." userInfo:nil] raise];
        return nil;
    }
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super init])
    {
        self.view.frame = frame;
        [self initialize];
    }
    
    return self;
}

- (void) initialize
{
    self.view.backgroundColor = [UIColor blackColor];
    [self setControlStyle:MPMovieControlStyleNone];
}

- (void) dealloc
{
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - Public Methods

- (void) setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.controls setFrame:self.view.bounds];
}

# pragma mark - Overrided Methods

- (void) setContentURL:(NSURL *)contentURL
{
    //
    // Catch case if url is going to be set defore controls initialization
    if (!self.controls)
    {
        [[NSException exceptionWithName:@"AppnextUIMoviePlayerControllerExample Exception" reason:@"Set contentURL after setting controls." userInfo:nil] raise];
    }

    //
    // Set url
    [super setContentURL:contentURL];

    //
    // Notify listeners that the url was changed
    [[NSNotificationCenter defaultCenter] postNotificationName:AppnextUIMoviePlayerExampleContentURLDidChangeNotification object:self];
}

- (void) play
{
    if (!self.contentURL)
    {
        return;
    }

    if (self.controls)
    {
        [self.controls onPlay];
    }

    MPMovieLoadState state = self.loadState;
    if (state == MPMovieLoadStateUnknown)
    {
        self.playRequested = YES;
        [self prepareToPlay];

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(videoLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

        [self performSelector:@selector(movieTimedOut) withObject:nil afterDelay:15.f];
        return;
    }

    [super play];
}

- (void) pause
{
    if (!self.contentURL)
    {
        return;
    }

    [super pause];
    if (self.controls)
    {
        [self.controls onPause];
    }
}

- (void) stop
{
    if (!self.contentURL)
    {
        return;
    }

    [super stop];
    if (self.controls)
    {
        [self.controls onStop];
    }
}

# pragma mark - Setters/Getters

- (void) setControls:(AppnextUIMoviePlayerControlsExample *)controls
{
    if (_controls != controls)
    {
        // Remove previous controls
        if (_controls)
        {
            [_controls removeFromSuperview];
        }

        _controls = controls;
        _controls.frame = self.view.bounds;
        _controls.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_controls];
    }
}

#pragma mark - Notifications

- (void) videoLoadStateChanged:(NSNotification *)note
{
    if (note.object != self)
    {
        return;
    }

    if (self.loadState & MPMovieLoadStatePlayable)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        if (self.playRequested)
        {
            self.playRequested = NO;
            [self play];
        }
    }
}

# pragma mark - Internal Methods

- (void) movieTimedOut
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    if (!(self.loadState & MPMovieLoadStatePlayable) || !(self.loadState & MPMovieLoadStatePlaythroughOK))
    {
        if ([self.delegate respondsToSelector:@selector(movieTimedOut)])
        {
            [self.delegate performSelector:@selector(movieTimedOut)];
        }
    }
}

@end
