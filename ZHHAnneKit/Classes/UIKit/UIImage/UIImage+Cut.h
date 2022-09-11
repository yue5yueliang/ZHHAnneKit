//
//  UIImage+Cut.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片裁剪器
@interface UIImage (Cut)
/// 不规则图形切割
/// @param view crop view
/// @param path clipping path
/// @return returns the cropped image
+ (UIImage *)zhh_cutAnomalyImage:(UIView *)view bezierPath:(UIBezierPath *)path;

/// 多边形切割
/// @param view crop view
/// @param points Polygon point coordinates
/// @return returns the cropped image
+ (UIImage *)zhh_cutPolygonImage:(UIImageView *)view pointArray:(NSArray *)points;

/// 指定面积裁剪
/// @param cropRect crop area
/// @return returns the cropped image
- (UIImage *)zhh_cutImageWithCropRect:(CGRect)cropRect;

/// 石英2d实现裁剪
/// @return returns the cropped image
- (UIImage *)zhh_quartzCutImageWithCropRect:(CGRect)cropRect;

/// 图像路径剪辑，剪辑路径的“外部”部分
/// @param path clipping path
/// @param rect canvas size
/// @return returns the cropped image
- (UIImage *)zhh_cutOuterImageBezierPath:(UIBezierPath *)path rect:(CGRect)rect;

/// 图像路径剪辑，剪辑路径的“内部”部分
/// @param path clipping path
/// @param rect canvas size
/// @return returns the cropped image
- (UIImage *)zhh_cutInnerImageBezierPath:(UIBezierPath *)path rect:(CGRect)rect;

/// 裁剪图片处理，从图片中心开始裁剪
/// @param size crop size
/// @return returns the cropped image
- (UIImage *)zhh_cutCenterClipImageWithSize:(CGSize)size;

/// 剪掉图片周围的透明部分
- (UIImage *)zhh_cutRoundAlphaZero;
@end

NS_ASSUME_NONNULL_END
