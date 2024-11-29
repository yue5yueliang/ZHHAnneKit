//
//  UIImage+ZHHMerge.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHMerge)
/// @brief  合并两张图片
/// @discussion
/// 该方法会将两张图片绘制到一个画布中，合并后的图片尺寸取两张图片宽度的最大值和高度的最大值。
/// 合并后图片的背景透明，图片绘制的起点为(0,0)。
/// @param firstImage 第一张图片
/// @param secondImage 第二张图片
/// @return 合并后的图片（UIImage 对象）
+ (UIImage *)zhh_mergeImage:(UIImage *)firstImage withImage:(UIImage *)secondImage;
@end

NS_ASSUME_NONNULL_END
