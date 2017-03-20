//
//  AppnextExampleUtils.h
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 16/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppnextExampleUtils : NSObject

+ (void) setButton:(UIButton *)button titleForAllStates:(NSString *)title;
+ (void) setButton:(UIButton *)button titleColorForAllStates:(UIColor *)color;
+ (void) setButton:(UIButton *)button imageForAllStates:(UIImage *)image;
+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (BOOL) rangeIsValid:(NSRange)range onString:(NSString *)str;
+ (NSData *) dataFromBase64String:(NSString *)aString;

@end
