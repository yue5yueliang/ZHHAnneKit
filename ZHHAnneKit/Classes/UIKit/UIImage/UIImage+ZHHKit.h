//
//  UIImage+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHGradientType) {
    ZHHGradientFromTopToBottom = 1,            //从上到下
    ZHHGradientFromLeftToRight,                //从左到右
    ZHHGradientFromLeftTopToRightBottom,       //从上到下
    ZHHGradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (ZHHKit)
/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percentArr       渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 */
- (UIImage *)zhh_imageGradientWithSize:(CGSize)imageSize colorArr:(NSArray *)colorArr percentArr:(NSArray *)percentArr gradientType:(ZHHGradientType)gradientType;
/// 加载原始图片
+ (UIImage *)zhh_originImageWithName:(NSString *)imageName;
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

/// 更改图片透明度
/// @param alpha transparency, 0-1
- (UIImage *)zhh_changeImageAlpha:(CGFloat)alpha;

/// 更改图片亮度
/// @param luminance brightness, 0-1
- (UIImage *)zhh_changeImageLuminance:(CGFloat)luminance;

/// 修改图片的线条颜色
/// @param color modify color
- (UIImage *)zhh_imageLinellaeColor:(UIColor *)color;

/// 图层混合, https://blog.csdn.net/yignorant/article/details/77864887
/// @param blendMode blend type
/// @param tintColor color
/// @return returns the picture after mixing
- (UIImage *)zhh_imageBlendMode:(CGBlendMode)blendMode tineColor:(UIColor *)tintColor;

/// 根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
+ (UIImage *)zhh_resizableImage:(NSString *)imageName;

/// 根据图片名返回一张能够自由拉伸的图片
+ (UIImage *)zhh_resizableImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/// 获取视频第一帧图片
+ (UIImage *)zhh_getVideoFirstThumbnailImageWithVideoUrl:(NSURL *)videoUrl;

/// 图片不被渲染
+ (UIImage *)zhh_imageAlwaysOriginalImageWithImageName:(NSString *)imageName;

/// 根据图片和颜色返回一张加深颜色以后的图片
+ (UIImage *)zhh_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color;

/// 根据指定的图片颜色和图片大小获取指定的Image
+ (UIImage *)zhh_getImageWithColor:(UIColor *)color size:(CGSize)size;

/// 通过传入一个图片对象获取一张缩略图
+ (UIImage *)zhh_getThumbnailImageWithImageObj:(id)imageObj;
@end

NS_ASSUME_NONNULL_END
