//
//  UIImage+ZHHAlpha.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  用于向图像添加alpha层的辅助方法
 */
@interface UIImage (ZHHAlpha)
/// @brief 检查图片是否包含 Alpha 通道
/// 此方法用于判断图片是否支持透明背景，主要通过图片的 Alpha 通道信息进行检测。
/// @return YES 表示图片包含 Alpha 通道，NO 表示图片不包含 Alpha 通道。
- (BOOL)zhh_hasAlpha ;
/// @brief 为图片添加 Alpha 通道
/// 如果图片本身不包含 Alpha 通道，则创建一个新的 UIImage 实例并添加 Alpha 通道。
/// 如果图片已包含 Alpha 通道，则直接返回自身。
/// @return 包含 Alpha 通道的 UIImage 实例。
- (UIImage *)zhh_imageWithAlpha;
/// 此方法会在图片的四周添加指定尺寸的透明边框。如果图片本身不包含 Alpha 通道，则会自动添加 Alpha 通道。
/// @param borderSize 边框的宽度（单位：像素）。
/// @return 添加透明边框后的 UIImage 实例。
- (UIImage *)zhh_transparentBorderImage:(NSUInteger)borderSize;

@end

NS_ASSUME_NONNULL_END
