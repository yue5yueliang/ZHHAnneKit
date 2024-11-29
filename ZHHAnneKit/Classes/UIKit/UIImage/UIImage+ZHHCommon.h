//
//  UIImage+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHCommon)

/// 加载一张始终使用原始模式的图片
/// @param imageName 图片的名称
/// @return 一张不受渲染影响的原始图片
+ (UIImage *)zhh_imageWithOriginalModeNamed:(NSString *)imageName;

/// 改变图片的透明度
/// @param alpha 透明度值，范围 [0.0, 1.0]
/// @return 修改透明度后的新图片
- (UIImage *)zhh_imageWithAlpha:(CGFloat)alpha;

/// 更改图片亮度
/// @param luminance brightness, 0-1
- (UIImage *)zhh_changeImageLuminance:(CGFloat)luminance;

/// 根据图片名返回一张能够自由拉伸的图片（从中间拉伸）
/// @param imageName 图片名
+ (UIImage *)zhh_resizableImage:(NSString *)imageName;

/// 根据图片名返回一张能够自由拉伸的图片
/// @param imageName 图片名
/// @param xPos 水平方向拉伸点比例（0.0~1.0）
/// @param yPos 垂直方向拉伸点比例（0.0~1.0）
+ (UIImage *)zhh_resizableImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/// 获取视频第一帧图片
/// @param videoUrl 视频文件的 URL
/// @return 视频第一帧的图片
+ (UIImage *)zhh_videoFirstFrameImageWithURL:(NSURL *)videoUrl;

/// 根据传入的图片对象生成一张缩略图
/// @param imageObj 传入的对象可以是 UIImage 或 PHAsset
/// @return 缩略图 UIImage
+ (UIImage *)zhh_thumbnailFromImageObject:(id)imageObj;

@end

NS_ASSUME_NONNULL_END
