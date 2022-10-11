//
//  UIImage+ZHHBetterFace.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//
//  https://github.com/croath/UIImageView-BetterFace
//  a UIImageView category to let the picture-cutting with faces showing better

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZHHAccuracy) {
    ZHHAccuracyLow = 0,
    ZHHAccuracyHigh,
};

@interface UIImage (ZHHBetterFace)
- (UIImage *)zhh_betterFaceImageForSize:(CGSize)size accuracy:(ZHHAccuracy)accurary;
@end

NS_ASSUME_NONNULL_END
