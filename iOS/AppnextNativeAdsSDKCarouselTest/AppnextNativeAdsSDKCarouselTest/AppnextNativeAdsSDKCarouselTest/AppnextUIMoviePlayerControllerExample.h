//
//  AppnextUIMoviePlayerControllerExample.h
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 11/02/2016.
//  Copyright © 2016 Appnext. All rights reserved.
//

#import <MediaPlayer/MPMoviePlayerController.h>
#import "AppnextUIMoviePlayerControlsExample.h"

//
// Notification
static NSString * const AppnextUIMoviePlayerExampleContentURLDidChangeNotification = @"AppnextUIMoviePlayerExampleContentURLDidChangeNotification";

#pragma mark - AppnextUIMoviePlayerControllerExampleDelegate

@protocol AppnextUIMoviePlayerControllerExampleDelegate <NSObject>
@optional
- (void) movieTimedOut;
@end

#pragma mark - AppnextUIMoviePlayerControllerExample

@interface AppnextUIMoviePlayerControllerExample : MPMoviePlayerController

@property (nonatomic, weak) id<AppnextUIMoviePlayerControllerExampleDelegate> delegate;
@property (nonatomic, strong) AppnextUIMoviePlayerControlsExample *controls;

- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

@end
