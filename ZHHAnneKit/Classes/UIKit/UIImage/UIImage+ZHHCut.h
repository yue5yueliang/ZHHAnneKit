//
//  UIImage+ZHHCut.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片裁剪器
@interface UIImage (ZHHCut)
/// 根据指定的 UIBezierPath 切割不规则图形
/// @param view 需要裁剪的视图
/// @param path 不规则图形的贝塞尔路径
/// @return 裁剪后的图片
+ (UIImage *)zhh_cutAnomalyImage:(UIView *)view bezierPath:(UIBezierPath *)path;

/// 根据多边形路径裁剪图片
/// @param view 包含图片的 UIImageView
/// @param points 多边形顶点数组，元素为 NSValue 类型的 CGPoint 值
/// @return 裁剪后的 UIImage
+ (UIImage *)zhh_cutPolygonImage:(UIImageView *)view pointArray:(NSArray<NSValue *> *)points;

/// 根据特定的区域对图片进行裁剪
/// @param rect 裁剪的区域（以图片的像素坐标为基准）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_cutImageWithCropRect:(CGRect)rect;

/// 使用 Quartz 2D 实现图片裁剪
/// @param rect 裁剪区域（基于图片像素坐标）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_quartzCutImageWithCropRect:(CGRect)rect;

/// 图片路径裁剪，裁剪路径 "以外" 的部分
/// @param path 要裁剪的 UIBezierPath
/// @param rect 图片绘制区域（通常为图片的边界）
- (UIImage *)zhh_cutOuterImageBezierPath:(UIBezierPath *)path rect:(CGRect)rect;

/// 图片路径裁剪，裁剪路径 "以内" 的部分
/// @param path 需要裁剪的 UIBezierPath
/// @param rect 图片绘制区域（通常为图片的边界）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_cutInnerImageBezierPath:(UIBezierPath *)path rect:(CGRect)rect;

/// 裁剪图片，以图片中心为基准裁剪指定尺寸
/// @param size 目标裁剪尺寸（基于原图像素尺寸）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_cutCenterClipImageWithSize:(CGSize)size;

/// 裁剪图片周围的透明部分
- (UIImage *)zhh_trimTransparentBorders;
@end

NS_ASSUME_NONNULL_END
