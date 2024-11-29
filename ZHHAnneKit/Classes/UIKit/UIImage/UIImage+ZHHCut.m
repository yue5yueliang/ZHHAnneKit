//
//  UIImage+ZHHCut.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHCut.h"

@implementation UIImage (ZHHCut)
/// 根据指定的 UIBezierPath 切割不规则图形
/// @param view 需要裁剪的视图
/// @param path 不规则图形的贝塞尔路径
/// @return 裁剪后的图片
+ (UIImage *)zhh_cutAnomalyImage:(UIView *)view bezierPath:(UIBezierPath *)path {
    // 创建形状遮罩图层
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath; // 设置路径
    maskLayer.frame = view.bounds; // 对齐视图的边界
    maskLayer.contentsScale = UIScreen.mainScreen.scale; // 确保适配 Retina 屏幕
    
    // 设置视图的遮罩
    view.layer.mask = maskLayer;
    view.layer.masksToBounds = YES;
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, UIScreen.mainScreen.scale);
    
    // 渲染视图图层到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 获取裁剪后的图片
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

/// 根据多边形路径裁剪图片
/// @param view 包含图片的 UIImageView
/// @param points 多边形顶点数组，元素为 NSValue 类型的 CGPoint 值
/// @return 裁剪后的 UIImage
+ (UIImage *)zhh_cutPolygonImage:(UIImageView *)view pointArray:(NSArray<NSValue *> *)points {
    if (!view.image || points.count < 3) {
        NSLog(@"无效的图片或顶点数组");
        return nil;
    }
    
    // 获取图片的尺寸
    CGSize imageSize = view.image.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    // 创建遮罩图片
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect); // 填充背景为黑色
    
    // 绘制白色的多边形遮罩
    [[UIColor whiteColor] setFill];
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    CGPoint firstPoint = [self convertCGPoint:[points[0] CGPointValue]
                                    fromRect1:view.frame.size
                                      toRect2:imageSize];
    [polygonPath moveToPoint:firstPoint];
    for (int i = 1; i < points.count; i++) {
        CGPoint nextPoint = [self convertCGPoint:[points[i] CGPointValue]
                                       fromRect1:view.frame.size
                                         toRect2:imageSize];
        [polygonPath addLineToPoint:nextPoint];
    }
    [polygonPath closePath];
    [polygonPath fill]; // 填充多边形区域
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 应用遮罩
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, maskImage.CGImage);
    [view.image drawAtPoint:CGPointZero];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

/// 将 CGPoint 从一个尺寸转换到另一个尺寸的比例坐标
/// @param point 原始 CGPoint
/// @param fromSize 原始视图的尺寸
/// @param toSize 图片的尺寸
/// @return 转换后的 CGPoint
+ (CGPoint)convertCGPoint:(CGPoint)point fromRect1:(CGSize)fromSize toRect2:(CGSize)toSize {
    CGFloat scaleX = toSize.width / fromSize.width;
    CGFloat scaleY = toSize.height / fromSize.height;
    return CGPointMake(point.x * scaleX, point.y * scaleY);
}

/// 根据特定的区域对图片进行裁剪
/// @param rect 裁剪的区域（以图片的像素坐标为基准）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_cutImageWithCropRect:(CGRect)rect {
    if (CGRectIsEmpty(rect) || CGRectGetWidth(rect) <= 0 || CGRectGetHeight(rect) <= 0) {
        NSLog(@"裁剪区域无效：%@", NSStringFromCGRect(rect));
        return nil;
    }
    
    // 校正裁剪区域，确保不超过图片范围
    rect = CGRectMake(
        MAX(0, rect.origin.x),
        MAX(0, rect.origin.y),
        MIN(self.size.width * self.scale - rect.origin.x, rect.size.width),
        MIN(self.size.height * self.scale - rect.origin.y, rect.size.height)
    );
    
    // 创建裁剪的 CGImage
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    if (!croppedImageRef) {
        NSLog(@"裁剪失败，可能是 rect 无效");
        return nil;
    }
    
    // 转换为 UIImage，并释放 CGImage
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef
                                                scale:self.scale
                                          orientation:self.imageOrientation];
    CGImageRelease(croppedImageRef);
    
    return croppedImage;
}

/// 使用 Quartz 2D 实现图片裁剪
/// @param rect 裁剪区域（基于图片像素坐标）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_quartzCutImageWithCropRect:(CGRect)rect {
    CGFloat scale = self.scale;

    // 将裁剪区域适配到图片的像素坐标系
    if (scale != 1) {
        rect.origin.x *= scale;
        rect.origin.y *= scale;
        rect.size.width *= scale;
        rect.size.height *= scale;
    }

    // 检查裁剪区域是否有效
    if (CGRectIsEmpty(rect) || rect.size.width <= 0 || rect.size.height <= 0) {
        NSLog(@"裁剪区域无效：%@", NSStringFromCGRect(rect));
        return nil;
    }

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        NSLog(@"创建 CGContext 失败");
        return nil;
    }

    // 获取裁剪后的 CGImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    if (!imageRef) {
        NSLog(@"裁剪 CGImage 失败");
        UIGraphicsEndImageContext();
        return nil;
    }

    // 在 CGContext 中绘制图片
    CGRect drawRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextDrawImage(ctx, drawRect, imageRef);

    // 从上下文中获取裁剪后的 UIImage
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRelease(imageRef);

    return resultImage;
}

/// 图片路径裁剪，裁剪路径 "以外" 的部分
/// @param path 要裁剪的 UIBezierPath
/// @param rect 图片绘制区域（通常为图片的边界）
- (UIImage *)zhh_cutOuterImageBezierPath:(UIBezierPath *)path rect:(CGRect)rect {
    // 开启图形上下文，支持高分辨率
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        NSLog(@"创建 CGContext 失败");
        return nil;
    }

    // 创建一个包含图片区域的路径（外部路径）
    CGMutablePathRef outerPath = CGPathCreateMutable();
    CGPathAddRect(outerPath, NULL, rect);      // 添加整个图片区域
    CGPathAddPath(outerPath, NULL, path.CGPath); // 添加需要裁剪的路径

    // 将路径添加到上下文中
    CGContextAddPath(context, outerPath);
    CGPathRelease(outerPath);

    // 设置混合模式为 Clear，清除路径范围的内容
    CGContextSetBlendMode(context, kCGBlendModeClear);

    // 绘制图片到上下文
    [self drawInRect:rect];

    // 应用裁剪操作（清除路径以外的部分）
    CGContextDrawPath(context, kCGPathEOFill);

    // 从上下文中获取最终裁剪后的图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

/// 图片路径裁剪，裁剪路径 "以内" 的部分
/// @param path 需要裁剪的 UIBezierPath
/// @param rect 图片绘制区域（通常为图片的边界）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_cutInnerImageBezierPath:(UIBezierPath *)path rect:(CGRect)rect {
    // 开启图形上下文，支持高分辨率
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        NSLog(@"创建 CGContext 失败");
        return nil;
    }

    // 绘制图片到上下文
    [self drawInRect:rect];

    // 添加裁剪路径
    CGContextAddPath(context, path.CGPath);

    // 设置混合模式为 Clear，裁剪路径内部分透明
    CGContextSetBlendMode(context, kCGBlendModeClear);

    // 应用裁剪操作
    CGContextDrawPath(context, kCGPathEOFill);

    // 从上下文中获取裁剪后的图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

/// 裁剪图片，以图片中心为基准裁剪指定尺寸
/// @param size 目标裁剪尺寸（基于原图像素尺寸）
/// @return 裁剪后的 UIImage
- (UIImage *)zhh_cutCenterClipImageWithSize:(CGSize)size {
    // 确保裁剪尺寸有效
    if (size.width <= 0 || size.height <= 0) {
        NSLog(@"裁剪尺寸无效，返回原图");
        return self;
    }

    // 获取原图尺寸
    CGSize imageSize = self.size;

    // 确定裁剪区域的中心位置
    CGFloat x = (imageSize.width - size.width) / 2.0;
    CGFloat y = (imageSize.height - size.height) / 2.0;

    // 如果裁剪区域超出图片边界，修正为图片的有效范围
    x = MAX(0, x);
    y = MAX(0, y);
    CGFloat w = MIN(size.width, imageSize.width);
    CGFloat h = MIN(size.height, imageSize.height);

    // 调整裁剪区域，处理图片方向（支持 UIImageOrientationRight 的处理）
    CGRect cropRect = CGRectMake(x, y, w, h);
    if (self.imageOrientation == UIImageOrientationRight) {
        cropRect = CGRectMake(y, x, h, w);
    }

    // 执行裁剪
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    if (!croppedImageRef) {
        NSLog(@"裁剪失败，返回原图");
        return self;
    }

    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(croppedImageRef);

    return croppedImage;
}

/// 裁剪图片周围的透明部分
- (UIImage *)zhh_trimTransparentBorders {
    // 获取原始图像的 CGImage 和尺寸信息
    CGImageRef cgImage = self.CGImage;
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);

    // 分配内存存储像素数据
    unsigned char *pixelData = calloc(width * height * 4, sizeof(unsigned char));
    if (!pixelData) {
        NSLog(@"内存分配失败，返回原图");
        return self;
    }

    // 创建颜色空间和上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 width,
                                                 height,
                                                 8, // 每个组件的位深度
                                                 width * 4, // 每行字节数
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    if (!context) {
        NSLog(@"图形上下文创建失败，返回原图");
        free(pixelData);
        CGColorSpaceRelease(colorSpace);
        return self;
    }

    // 绘制图片到上下文
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

    // 初始化裁剪边界
    size_t top = 0, left = 0, right = 0, bottom = 0;

    // 找到顶部非透明像素的行索引
    for (size_t row = 0; row < height; row++) {
        BOOL foundOpaquePixel = NO;
        for (size_t col = 0; col < width; col++) {
            size_t pixelIndex = (row * width + col) * 4;
            if (pixelData[pixelIndex + 3] != 0) { // 检测 alpha 通道
                foundOpaquePixel = YES;
                break;
            }
        }
        if (foundOpaquePixel) break;
        top++;
    }

    // 找到左侧非透明像素的列索引
    for (size_t col = 0; col < width; col++) {
        BOOL foundOpaquePixel = NO;
        for (size_t row = 0; row < height; row++) {
            size_t pixelIndex = (row * width + col) * 4;
            if (pixelData[pixelIndex + 3] != 0) { // 检测 alpha 通道
                foundOpaquePixel = YES;
                break;
            }
        }
        if (foundOpaquePixel) break;
        left++;
    }

    // 找到右侧非透明像素的列索引
    for (size_t col = width - 1; col > 0; col--) {
        BOOL foundOpaquePixel = NO;
        for (size_t row = 0; row < height; row++) {
            size_t pixelIndex = (row * width + col) * 4;
            if (pixelData[pixelIndex + 3] != 0) { // 检测 alpha 通道
                foundOpaquePixel = YES;
                break;
            }
        }
        if (foundOpaquePixel) break;
        right++;
    }

    // 找到底部非透明像素的行索引
    for (size_t row = height - 1; row > 0; row--) {
        BOOL foundOpaquePixel = NO;
        for (size_t col = 0; col < width; col++) {
            size_t pixelIndex = (row * width + col) * 4;
            if (pixelData[pixelIndex + 3] != 0) { // 检测 alpha 通道
                foundOpaquePixel = YES;
                break;
            }
        }
        if (foundOpaquePixel) break;
        bottom++;
    }

    // 计算裁剪区域
    CGFloat scale = self.scale;
    CGRect cropRect = CGRectMake(left, top, width - left - right, height - top - bottom);

    if (cropRect.size.width <= 0 || cropRect.size.height <= 0) {
        NSLog(@"裁剪区域无效，返回原图");
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        free(pixelData);
        return self;
    }

    // 裁剪图片
    CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(cgImage, CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(scale, scale)));
    UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef scale:scale orientation:self.imageOrientation];
    CGImageRelease(trimmedImageRef);

    // 释放资源
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixelData);

    return trimmedImage;
}
@end
