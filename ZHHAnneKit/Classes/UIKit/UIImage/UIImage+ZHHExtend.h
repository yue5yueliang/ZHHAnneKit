//
//  UIImage+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHExtend)

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
