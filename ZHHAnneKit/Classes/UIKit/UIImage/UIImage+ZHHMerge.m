//
//  UIImage+ZHHMerge.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHMerge.h"

@implementation UIImage (ZHHMerge)

/// @brief  合并两张图片
/// @discussion
/// 该方法会将两张图片绘制到一个画布中，合并后的图片尺寸取两张图片宽度的最大值和高度的最大值。
/// 合并后图片的背景透明，图片绘制的起点为(0,0)。
/// @param firstImage 第一张图片
/// @param secondImage 第二张图片
/// @return 合并后的图片（UIImage 对象）
+ (UIImage *)zhh_mergeImage:(UIImage *)firstImage withImage:(UIImage *)secondImage {
    // 获取第一张图片的宽度和高度
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);

    // 获取第二张图片的宽度和高度
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);

    // 合并图片的尺寸：宽和高分别取两张图片的最大值
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));

    // 开启一个透明背景的上下文，尺寸为合并图片的大小
    UIGraphicsBeginImageContextWithOptions(mergedSize, NO, 0.0);

    // 绘制第一张图片到画布中，起点为 (0, 0)，大小为图片的原始尺寸
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];

    // 绘制第二张图片到画布中，起点为 (0, 0)，大小为图片的原始尺寸
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];

    // 获取合成后的图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图形上下文
    UIGraphicsEndImageContext();

    // 返回合并后的图片
    return resultImage;
}
@end
