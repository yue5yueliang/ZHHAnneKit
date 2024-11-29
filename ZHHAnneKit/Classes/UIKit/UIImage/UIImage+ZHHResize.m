//
//  UIImage+ZHHResize.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHResize.h"

@implementation UIImage (ZHHResize)
/// @brief 根据目标尺寸按比例裁剪图片
/// @param size 目标尺寸（宽和高）
/// @return 裁剪后的图片
- (UIImage *)zhh_cropImageToAspectRatioWithSize:(CGSize)size {
    // 计算原图的宽高比
    CGFloat originalAspectRatio = self.size.width / self.size.height;
    // 计算目标尺寸的宽高比
    CGFloat targetAspectRatio = size.width / size.height;

    // 用于定义裁剪区域的矩形
    CGRect cropRect = CGRectZero;

    if (originalAspectRatio > targetAspectRatio) {
        // 原图更宽，需按目标宽高比裁剪宽度
        // 计算新的宽度，并居中裁剪
        CGFloat newWidth = self.size.height * targetAspectRatio;
        cropRect = CGRectMake((self.size.width - newWidth) / 2.0, 0, newWidth, self.size.height);
    } else {
        // 原图更高，需按目标宽高比裁剪高度
        // 计算新的高度，并居中裁剪
        CGFloat newHeight = self.size.width / targetAspectRatio;
        cropRect = CGRectMake(0, (self.size.height - newHeight) / 2.0, self.size.width, newHeight);
    }

    // 裁剪图片
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    if (!imageRef) {
        // 裁剪失败，返回 nil
        return nil;
    }

    // 创建裁剪后的图片
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    // 释放 Core Graphics 对象
    CGImageRelease(imageRef);

    return croppedImage;
}

/// @brief 等比缩小图片尺寸
/// @param size 最大允许的尺寸（宽和高）
/// @return 缩小后的图片（如果原图已经符合要求，则直接返回原图）
- (UIImage *)zhh_zoomImageWithMaxSize:(CGSize)size {
    // 原图的宽高
    CGFloat imgWidth = self.size.width;
    CGFloat imgHeight = self.size.height;

    // 最大允许的宽高
    CGFloat maxWidth = size.width;
    CGFloat maxHeight = size.height;

    // 原图的宽高比
    CGFloat imgRatio = imgWidth / imgHeight;
    // 最大尺寸的宽高比
    CGFloat maxRatio = maxWidth / maxHeight;

    // 如果图片的尺寸已经在限制范围内，直接返回原图
    if (imgWidth <= maxWidth && imgHeight <= maxHeight) {
        return self;
    }

    // 调整宽高比例以适配最大尺寸
    if (imgRatio < maxRatio) {
        // 图片较窄，以高度为基准进行缩放
        CGFloat scale = maxHeight / imgHeight;
        imgWidth *= scale;
        imgHeight = maxHeight;
    } else if (imgRatio > maxRatio) {
        // 图片较宽，以宽度为基准进行缩放
        CGFloat scale = maxWidth / imgWidth;
        imgHeight *= scale;
        imgWidth = maxWidth;
    } else {
        // 宽高比相等，直接缩放到最大尺寸
        imgWidth = maxWidth;
        imgHeight = maxHeight;
    }

    // 创建缩放后的图片
    CGRect rect = CGRectMake(0, 0, imgWidth, imgHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); // 支持高分辨率屏幕
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
}

/// @brief 根据固定宽度等比缩放图片
/// @param width 固定的宽度
/// @return 缩放后的图片
- (UIImage *)zhh_scaleWithFixedWidth:(CGFloat)width {
    // 计算等比缩放后的高度
    CGFloat newHeight = self.size.height * (width / self.size.width);
    
    // 新的目标尺寸
    CGSize size = CGSizeMake(width, newHeight);

    // 开始图片绘制上下文，支持高分辨率
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 将坐标系原点移到图片底部，并垂直翻转坐标系
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 设置绘制模式为覆盖
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // 绘制图片到上下文
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    // 从上下文获取缩放后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/// @brief 根据固定高度等比缩放图片
/// @param height 固定的高度
/// @return 缩放后的图片
- (UIImage *)zhh_scaleWithFixedHeight:(CGFloat)height {
    // 计算等比缩放后的宽度
    CGFloat newWidth = self.size.width * (height / self.size.height);
    
    // 新的目标尺寸
    CGSize size = CGSizeMake(newWidth, height);

    // 开始图片绘制上下文，支持高分辨率
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 将坐标系原点移到图片底部，并垂直翻转坐标系
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 设置绘制模式为覆盖
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // 绘制图片到上下文
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    // 从上下文获取缩放后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/// @brief 根据比例缩放图片
/// @param scale 缩放比例（例如，0.5 为缩小一半，2 为放大两倍）
/// @return 缩放后的图片
- (UIImage *)zhh_scaleImage:(CGFloat)scale {
    // 创建一个新的图形上下文，目标尺寸为原始图片尺寸乘以缩放比例
    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContext(newSize);
    
    // 在新的上下文中绘制图片，按缩放后的尺寸
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // 从当前图形上下文获取缩放后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/// @brief 根据目标尺寸，不拉升填充图片，保持原比例
/// @param size 目标尺寸
/// @return 填充后的图片
- (UIImage *)zhh_fitImageWithSize:(CGSize)size {
    // 初始化变量
    CGFloat x, y, w, h;

    // 判断原图与目标尺寸的宽高比，进行适当的缩放和填充
    if ((self.size.width / self.size.height) < (size.width / size.height)) {
        // 如果原图的宽高比小于目标尺寸，按高度为基准进行缩放
        y = 0.0;
        h = size.height;
        w = self.size.width * h / self.size.height;
        x = (size.width - w) / 2.0;  // 水平居中
    } else {
        // 如果原图的宽高比大于目标尺寸，按宽度为基准进行缩放
        x = 0.0;
        w = size.width;
        h = self.size.height * w / self.size.width;
        y = -(size.height - h) / 2.0;  // 垂直居中
    }

    // 创建图形上下文来绘制图像
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 将图片绘制到上下文中，不拉伸，保持原比例
    CGContextTranslateCTM(context, 0.0, h);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(x, y, w, h), self.CGImage);

    // 获取上下文中的图片
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图形上下文
    UIGraphicsEndImageContext();

    return imageOut;
}

/// @brief 根据给定的方向旋转和镜像处理图片
/// @param orientation 旋转或镜像的方向
/// @return 旋转后或者镜像后的图片
- (UIImage *)zhh_rotationImageWithOrientation:(UIImageOrientation)orientation {
    // 获取原始图像的宽高
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    CGRect bounds = rect;

    // 用于交换宽高的代码块，主要用于旋转时需要交换宽高
    CGRect (^kSwapWidthAndHeight)(CGRect) = ^CGRect(CGRect rect) {
        CGFloat swap = rect.size.width;
        rect.size.width  = rect.size.height;
        rect.size.height = swap;
        return rect;
    };

    // 初始化变换矩阵
    CGAffineTransform transform = CGAffineTransformIdentity;

    // 根据旋转方向设置相应的变换矩阵
    switch (orientation) {
        case UIImageOrientationUp:
            break; // 不需要做任何处理
        case UIImageOrientationUpMirrored:
            // 水平镜像
            transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            // 旋转180度
            transform = CGAffineTransformMakeTranslation(rect.size.width, rect.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            // 旋转180度并且水平镜像
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeft:
            // 旋转90度并交换宽高
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeftMirrored:
            // 旋转90度并交换宽高，进行水平镜像
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            // 旋转270度并交换宽高
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            // 旋转270度并交换宽高，进行水平镜像
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
    }

    // 创建图形上下文
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 根据方向设置图形上下文的坐标系
    switch (orientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // 对于左旋和右旋方向，需要翻转上下文
            CGContextScaleCTM(context, -1.0, 1.0);
            CGContextTranslateCTM(context, -rect.size.height, 0.0);
            break;
        default:
            // 对于其他旋转方向，需要翻转上下文
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0.0, -rect.size.height);
            break;
    }

    // 将变换矩阵应用到上下文中
    CGContextConcatCTM(context, transform);

    // 在上下文中绘制旋转后的图像
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, self.CGImage);

    // 从上下文获取旋转后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图形上下文
    UIGraphicsEndImageContext();

    return newImage;
}

/// @brief 创建一个椭圆形的图片
/// @return 返回一个椭圆形的图片
- (UIImage *)zhh_ellipseImage {
    // 开始图形上下文，设置为当前图片的大小，不透明，缩放比例为 0.0（表示设备屏幕的缩放）
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获取当前的图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 创建一个矩形区域（即当前图片的大小），然后在该区域绘制椭圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 在矩形区域内绘制椭圆
    CGContextAddEllipseInRect(ctx, rect);
    // 将当前的绘制区域裁剪为椭圆形
    CGContextClip(ctx);
    // 绘制原图（只会在椭圆区域内显示）
    [self drawInRect:rect];
    // 从图形上下文中获取生成的图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    return image;
}

/// @brief 将图片裁剪为圆形
/// @return 返回一个圆形的图片
- (UIImage *)zhh_circleImage {
    // 获取原始图片的宽高
    CGSize size = self.size;
    // 取宽高中较小的一边，作为圆形区域的边长
    CGFloat drawWH = size.width < size.height ? size.width : size.height;
    // 1. 开启图形上下文，创建一个正方形的绘制区域
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(drawWH, drawWH), NO, 0.0);
    // 2. 绘制一个圆形区域，并进行裁剪
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect clipRect = CGRectMake(0, 0, drawWH, drawWH);
    CGContextAddEllipseInRect(context, clipRect);
    CGContextClip(context);
    // 3. 绘制原图，超出圆形部分将被裁剪掉
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:drawRect];
    // 4. 从图形上下文中获取处理后的圆形图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5. 关闭图形上下文
    UIGraphicsEndImageContext();
    return resultImage;
}

/// @brief 给图片添加边框并裁剪为圆形
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
/// @return 返回一个带有圆形边框的圆形图片
- (UIImage *)zhh_squareCircleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    // 计算带边框的图片宽高
    CGFloat width = self.size.width + 2 * borderWidth;
    CGFloat height = width; // 由于是圆形，所以宽高相等

    // 1. 开启图形上下文，大小为带边框的图片大小
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    
    // 获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置边框颜色
    [borderColor set];
    
    // 2. 绘制大圆形边框
    CGFloat bigRadius = width * 0.5; // 圆形的半径
    CGFloat centerX = bigRadius; // 圆心X坐标
    CGFloat centerY = bigRadius; // 圆心Y坐标
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0); // 绘制外圆
    CGContextFillPath(context); // 填充圆形，创建边框效果
    
    // 3. 绘制小圆形用于裁剪图片
    CGFloat smallRadius = bigRadius - borderWidth; // 小圆的半径
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0); // 绘制内圆
    CGContextClip(context); // 使用内圆裁剪图像
    
    // 4. 绘制原图，裁剪部分会被忽略
    [self drawInRect:CGRectMake(borderWidth, borderWidth, width, height)];
    
    // 5. 获取绘制后的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
