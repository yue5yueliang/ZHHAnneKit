//
//  UIImage+ZHHQRCode.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHQRCode)
#pragma mark - 二维码生成

/// 生成二维码滤镜
/// @param content 二维码内容字符串
/// @return 生成的二维码 CIImage 对象
+ (CIImage *)zhh_generateQRCodeCIImageWithContent:(NSString *)content;

/// 生成指定尺寸的二维码图片
/// @param content 二维码内容字符串
/// @param size 生成的二维码图片尺寸
/// @return 生成的二维码 UIImage 对象
+ (UIImage *)zhh_generateQRCodeImageWithContent:(NSString *)content size:(CGFloat)size;

/// 生成指定尺寸和颜色的二维码图片
/// @param content 二维码内容字符串
/// @param size 生成的二维码图片尺寸
/// @param color 自定义颜色
/// @return 生成的二维码 UIImage 对象
+ (UIImage *)zhh_generateQRCodeImageWithContent:(NSString *)content size:(CGFloat)size color:(UIColor *)color;

#pragma mark - 条形码生成

/// 生成条形码滤镜
/// @param content 条形码内容字符串
/// @return 生成的条形码 CIImage 对象
+ (CIImage *)zhh_generateBarcodeCIImageWithContent:(NSString *)content;

/// 生成指定尺寸的条形码图片
/// @param content 条形码内容字符串
/// @param size 生成的条形码图片尺寸
/// @return 生成的条形码 UIImage 对象
+ (UIImage *)zhh_generateBarcodeImageWithContent:(NSString *)content size:(CGFloat)size;

/// 生成指定尺寸和颜色的条形码图片
/// @param content 条形码内容字符串
/// @param size 生成的条形码图片尺寸
/// @param color 自定义颜色
/// @return 生成的条形码 UIImage 对象
+ (UIImage *)zhh_generateBarcodeImageWithContent:(NSString *)content size:(CGFloat)size color:(UIColor *)color;

#pragma mark - 私有方法

/// 将 CIImage 转换为指定尺寸的高清 UIImage
/// @param image 输入的 CIImage
/// @param size 输出的图片尺寸
/// @return 转换后的高清 UIImage 对象
+ (UIImage *)zhh_createHDImageFromCIImage:(CIImage *)image size:(CGFloat)size;

/// 修改图片像素颜色
/// @param image 输入的 UIImage
/// @param color 替换的颜色
/// @return 修改颜色后的 UIImage
+ (UIImage *)zhh_changeImagePixelColor:(UIImage *)image color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
