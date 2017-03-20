//
//  AppnextUIMoviePlayerControlsExample.h
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 11/02/2016.
//  Copyright © 2016 Appnext. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppnextUIMoviePlayerControllerExample;

typedef NS_ENUM(Byte, AppnextUIMoviePlayerControlsExampleState)
{
    //
    // Controls are not doing anything
    AppnextUIMoviePlayerControlsExampleStateIdle,

    //
    // Controls are waiting for movie to finish loading
    AppnextUIMoviePlayerControlsExampleStateLoading,

    //
    // Controls are ready to play and/or playing
    AppnextUIMoviePlayerControlsExampleStateReady,
};

#pragma mark - AppnextUIMoviePlayerControlsExampleDelegate

@protocol AppnextUIMoviePlayerControlsExampleDelegate <NSObject>
@optional
- (void) controlsStateChanged:(AppnextUIMoviePlayerControlsExampleState)state;
- (void) videoPlayerPlaybackDidStart;
- (void) videoPlayerPlaybackDidEnd;
@end

#pragma mark - AppnextUIMoviePlayerControlsExample

@interface AppnextUIMoviePlayerControlsExample : UIView

//
// The state of the controls.
@property (nonatomic, assign, readonly) AppnextUIMoviePlayerControlsExampleState state;

@property (nonatomic, strong) NSString *coverImageUrl;
@property (nonatomic, weak) id<AppnextUIMoviePlayerControlsExampleDelegate> delegate;

- (instancetype) initWithMoviePlayer:(AppnextUIMoviePlayerControllerExample *)moviePlayer;

- (void) onPlay;
- (void) onPause;
- (void) onStop;

@end
