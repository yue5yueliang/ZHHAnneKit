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

/// 聚焦人脸区域并生成目标尺寸的图片
/// @param targetSize 目标图片尺寸
/// @param accuracy 人脸检测精度（高或低）
/// @return 聚焦人脸的裁剪图片，未检测到人脸时返回 nil
- (UIImage *)zhh_focusedImageOnFacesWithTargetSize:(CGSize)targetSize accuracy:(ZHHAccuracy)accuracy;
@end

NS_ASSUME_NONNULL_END
