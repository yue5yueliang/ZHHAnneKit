//
//  UIImage+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHGradientType) {
    ZHHGradientFromTopToBottom = 1,            //从上到下
    ZHHGradientFromLeftToRight,                //从左到右
    ZHHGradientFromLeftTopToRightBottom,       //从上到下
    ZHHGradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (ZHHExtend)
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

/// 更改图片透明度
/// @param alpha transparency, 0-1
- (UIImage *)zhh_changeImageAlpha:(CGFloat)alpha;

/// 更改图片亮度
/// @param luminance brightness, 0-1
- (UIImage *)zhh_changeImageLuminance:(CGFloat)luminance;

/// 根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
+ (UIImage *)zhh_resizableImage:(NSString *)imageName;

/// 根据图片名返回一张能够自由拉伸的图片
+ (UIImage *)zhh_resizableImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/// 获取视频第一帧图片
+ (UIImage *)zhh_getVideoFirstThumbnailImageWithVideoUrl:(NSURL *)videoUrl;

/// 图片不被渲染
+ (UIImage *)zhh_imageAlwaysOriginalImageWithImageName:(NSString *)imageName;

/// 通过传入一个图片对象获取一张缩略图
+ (UIImage *)zhh_getThumbnailImageWithImageObj:(id)imageObj;
@end

NS_ASSUME_NONNULL_END
