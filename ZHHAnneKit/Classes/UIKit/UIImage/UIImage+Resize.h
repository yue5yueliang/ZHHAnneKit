//
//  UIImage+Resize.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Resize)
/// 按比例缩放图片
/// @param scale zoom scale
- (UIImage *)zhh_scaleImage:(CGFloat)scale;

/// 以固定宽度缩放图像
/// @param width fixed width
- (UIImage *)zhh_scaleWithFixedWidth:(CGFloat)width;

/// 以固定高度缩放图像
/// @param height fixed height
- (UIImage *)zhh_scaleWithFixedHeight:(CGFloat)height;

/// 按比例更改图片大小
/// @param size size box
- (UIImage *)zhh_cropImageWithAnySize:(CGSize)size;

/// 按比例缩小图片大小
/// @param size Reduce size
- (UIImage *)zhh_zoomImageWithMaxSize:(CGSize)size;

/// 不要拉起并填充图片
/// @param size fill size
- (UIImage *)zhh_fitImageWithSize:(CGSize)size;

/// 旋转图片和镜像处理
/// @param orientation rotation direction
- (UIImage *)zhh_rotationImageWithOrientation:(UIImageOrientation)orientation;

/// 椭圆形图片，当图片的长度和宽度不同时，图片将出现切出的椭圆形
- (UIImage *)zhh_ellipseImage;

/// 圆形图片
- (UIImage *)zhh_circleImage;

/// 边框圆圈图片
/// @param borderWidth border width
/// @param borderColor border color
/// @return returns the picture with border added
- (UIImage *)zhh_squareCircleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
