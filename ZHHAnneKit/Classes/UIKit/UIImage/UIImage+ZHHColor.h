//
//  UIImage+ZHHColor.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHColor)
/**
*  创建指定color的image
*  @param color 根据颜色生成size为(1, 1)的纯色图片
*  @return 返回创建的image
*/
+ (UIImage *)zhh_imageWithColor:(UIColor *)color;
/// 生成彩色图片
/// @param color Generate image color, support gradient color
/// @param size image size
+ (UIImage *)zhh_imageWithColor:(UIColor *)color size:(CGSize)size;

/// 更改图片的背景色
/// @param color target color
- (UIImage *)zhh_changeImageColor:(UIColor *)color;

/// 更改图片内的像素颜色
/// @param color pixel color
- (UIImage *)zhh_changeImagePixelColor:(UIColor *)color;

/// 修改图片的线条颜色
/// @param color modify color
- (UIImage *)zhh_imageLinellaeColor:(UIColor *)color;

/// 图层混合, https://blog.csdn.net/yignorant/article/details/77864887
/// @param blendMode blend type
/// @param tintColor color
/// @return returns the picture after mixing
- (UIImage *)zhh_imageBlendMode:(CGBlendMode)blendMode tineColor:(UIColor *)tintColor;

/// 根据图片和颜色返回一张加深颜色以后的图片
+ (UIImage *)zhh_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color;

/// 根据指定的图片颜色和图片大小获取指定的Image
+ (UIImage *)zhh_getImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  @brief  取图片某一点的颜色
 *  @param point 某一点
 *  @return 颜色
 */
- (UIColor *)zhh_colorAtPoint:(CGPoint )point;

//more accurate method ,colorAtPixel 1x1 pixel
/**
 *  @brief  取某一像素的颜色
 *  @param point 一像素
 *  @return 颜色
 */
- (UIColor *)zhh_colorAtPixel:(CGPoint)point;

/**
 *  @brief  返回该图片是否有透明度通道
 *  @return 是否有透明度通道
 */
- (BOOL)zhh_hasAlphaChannel;

/**
 *  @brief  获得灰度图
 *  @param sourceImage 图片
 *  @return 获得灰度图片
 */
+ (UIImage*)zhh_covertToGrayImageFromImage:(UIImage*)sourceImage;
@end

NS_ASSUME_NONNULL_END
