//
//  AppnextExampleUtils.m
//  AppnextNativeAdsSDKCarouselTest
//
//  Created by Eran Mausner on 16/01/2017.
//  Copyright © 2017 Appnext. All rights reserved.
//

#import "AppnextExampleUtils.h"

@implementation AppnextExampleUtils

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

@end
