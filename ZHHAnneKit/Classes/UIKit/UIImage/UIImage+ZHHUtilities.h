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
@end

NS_ASSUME_NONNULL_END
