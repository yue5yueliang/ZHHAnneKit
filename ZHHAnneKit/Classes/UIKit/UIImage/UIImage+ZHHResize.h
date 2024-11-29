//
//  UIImage+ZHHResize.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHResize)
/// @brief 根据目标尺寸按比例裁剪图片
/// @param size 目标尺寸（宽和高）
/// @return 裁剪后的图片
- (UIImage *)zhh_cropImageToAspectRatioWithSize:(CGSize)size;

/// @brief 等比缩小图片尺寸
/// @param size 最大允许的尺寸（宽和高）
/// @return 缩小后的图片（如果原图已经符合要求，则直接返回原图）
- (UIImage *)zhh_zoomImageWithMaxSize:(CGSize)size;

/// @brief 根据固定宽度等比缩放图片
/// @param width 固定的宽度
/// @return 缩放后的图片
- (UIImage *)zhh_scaleWithFixedWidth:(CGFloat)width;

/// @brief 根据固定高度等比缩放图片
/// @param height 固定的高度
/// @return 缩放后的图片
- (UIImage *)zhh_scaleWithFixedHeight:(CGFloat)height;

/// @brief 根据比例缩放图片
/// @param scale 缩放比例（例如，0.5 为缩小一半，2 为放大两倍）
/// @return 缩放后的图片
- (UIImage *)zhh_scaleImage:(CGFloat)scale;

/// @brief 根据目标尺寸，不拉升填充图片，保持原比例
/// @param size 目标尺寸
/// @return 填充后的图片
- (UIImage *)zhh_fitImageWithSize:(CGSize)size;

/// @brief 根据给定的方向旋转和镜像处理图片
/// @param orientation 旋转或镜像的方向
/// @return 旋转后或者镜像后的图片
- (UIImage *)zhh_rotationImageWithOrientation:(UIImageOrientation)orientation;

/// @brief 创建一个椭圆形的图片
/// @return 返回一个椭圆形的图片
- (UIImage *)zhh_ellipseImage;

/// @brief 将图片裁剪为圆形
/// @return 返回一个圆形的图片
- (UIImage *)zhh_circleImage;

/// @brief 给图片添加边框并裁剪为圆形
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
/// @return 返回一个带有圆形边框的圆形图片
- (UIImage *)zhh_squareCircleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
