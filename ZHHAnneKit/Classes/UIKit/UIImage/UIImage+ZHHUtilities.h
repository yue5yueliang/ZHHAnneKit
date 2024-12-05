//
//  UIImage+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHUtilities)
/// 根据不同的nickname给不同的群设置含有群名的群头像。
+ (UIImage *)zhh_createTextImageWithString:(NSString *)string imageSize:(CGSize)size;
/// @brief  根据main bundle中的文件名读取图片
/// @param name 图片名
/// @return 无缓存的图片
+ (UIImage *)zhh_imageWithFileName:(NSString *)name;
/// 根据指定bundle中的文件名读取图片
/// @param name   图片名
/// @param bundle bundle
/// @return 无缓存的图片
+ (UIImage *)zhh_imageWithFileName:(NSString *)name inBundle:(NSBundle*)bundle;
/// 获取网络图片大小
/// @param URL image link
+ (CGSize)zhh_imageSizeWithURL:(NSURL *)URL;

/// 同步获取网络图片大小和信号量
/// @param URL image link
+ (CGSize)zhh_imageAsyncGetSizeWithURL:(NSURL *)URL;

/// 动态调整图片尺寸并指定背景颜色的辅助方法
/// @discussion 此方法将当前图片调整为指定尺寸，并可设置背景颜色。原图片居中绘制于目标画布内，若图片尺寸超出目标尺寸，则直接返回原图片。
/// @param size 目标尺寸，图片会调整到此大小的画布上
/// @param backgroundColor 背景颜色，为 nil 时背景透明
/// @return 调整后的图片，或在特定情况下返回原图片
- (UIImage *)zhh_resizeImageToSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor;
@end

NS_ASSUME_NONNULL_END
