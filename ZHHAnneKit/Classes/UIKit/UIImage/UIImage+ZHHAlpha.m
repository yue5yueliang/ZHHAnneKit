//
//  UIImage+ZHHAlpha.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHAlpha.h"
// Private helper methods

@interface UIImage (ZHHAlphaPrivateMethods)
- (CGImageRef)zhh_newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
@end

@implementation UIImage (ZHHAlpha)
/// @brief 检查图片是否包含 Alpha 通道
/// 此方法用于判断图片是否支持透明背景，主要通过图片的 Alpha 通道信息进行检测。
/// @return YES 表示图片包含 Alpha 通道，NO 表示图片不包含 Alpha 通道。
- (BOOL)zhh_hasAlpha {
    // 获取图片的 Alpha 通道信息
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    // 检查 Alpha 通道类型是否为支持透明的类型
    return (alphaInfo == kCGImageAlphaFirst || alphaInfo == kCGImageAlphaLast || alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaPremultipliedLast);
}

/// @brief 为图片添加 Alpha 通道
/// 如果图片本身不包含 Alpha 通道，则创建一个新的 UIImage 实例并添加 Alpha 通道。
/// 如果图片已包含 Alpha 通道，则直接返回自身。
/// @return 包含 Alpha 通道的 UIImage 实例。
- (UIImage *)zhh_imageWithAlpha {
    // 如果图片已包含 Alpha 通道，直接返回原图
    if ([self zhh_hasAlpha]) {
        return self;
    }
    
    // 获取图片的原始 CGImage 引用
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // 创建支持 Alpha 通道的新位图上下文
    // 配置 8 bits/通道，预乘 Alpha 格式
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8, // bits per component
                                                          0, // 自动计算每行字节数
                                                          CGImageGetColorSpace(imageRef), // 保留原始色彩空间
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    if (!offscreenContext) {
        NSLog(@"创建位图上下文失败！");
        return nil;
    }
    
    // 将原始图片绘制到新上下文中
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    
    // 从上下文中提取新的 CGImage，其中已包含 Alpha 通道
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    if (!imageRefWithAlpha) {
        CGContextRelease(offscreenContext);
        NSLog(@"ZHHAnneKit 警告: 创建包含 Alpha 通道的图片失败");
        return nil;
    }
    
    // 将 CGImage 转换为 UIImage
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // 释放上下文和临时图片
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

/// 此方法会在图片的四周添加指定尺寸的透明边框。如果图片本身不包含 Alpha 通道，则会自动添加 Alpha 通道。
/// @param borderSize 边框的宽度（单位：像素）。
/// @return 添加透明边框后的 UIImage 实例。
- (UIImage *)zhh_transparentBorderImage:(NSUInteger)borderSize {
    // 确保边框尺寸有效
    if (borderSize == 0) {
        return self;
    }
    
    // 如果图片没有 Alpha 通道，先添加 Alpha 通道
    UIImage *image = [self zhh_imageWithAlpha];
    
    // 计算新图片的尺寸，包含透明边框
    CGRect newRect = CGRectMake(0, 0,
                                image.size.width + borderSize * 2,
                                image.size.height + borderSize * 2);
    
    // 创建与新尺寸匹配的位图上下文
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(image.CGImage),
                                                0,
                                                CGImageGetColorSpace(image.CGImage),
                                                CGImageGetBitmapInfo(image.CGImage));
    
    if (!bitmap) {
        NSLog(@"创建位图上下文失败！");
        return nil;
    }
    
    // 将原图片绘制到上下文中心位置
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, image.CGImage);
    
    // 从上下文中提取新图片，带有透明边框
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // 创建一个用于透明边框的遮罩
    CGImageRef maskImageRef = [self zhh_newBorderMask:borderSize size:newRect.size];
    
    // 使用遮罩将边框设为透明
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // 清理资源
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

/**
 * @brief 裁剪图片的透明边缘，只保留非透明内容的最小矩形。
 *
 * @return 裁剪后的 UIImage 实例。如果图片无法裁剪或数据无效，则返回 nil。
 */
- (UIImage *)zhh_trimmedToMinimalSize {
    CGImageRef inImage = self.CGImage;
    if (!inImage) {
        NSLog(@"图片资源无效");
        return nil;
    }
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    if (!imageData) {
        NSLog(@"无法获取图片数据");
        return nil;
    }
    
    const UInt8 *pixelData = CFDataGetBytePtr(imageData);
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    
    // 用于记录非透明区域的边界点
    NSInteger top = -1, left = -1, right = -1, bottom = -1;
    BOOL found = NO;
    
    // 找到顶部边界
    for (size_t y = 0; y < height && !found; y++) {
        for (size_t x = 0; x < width; x++) {
            size_t loc = (x + y * width) * 4;
            if (pixelData[loc + 3] != 0) { // 检查Alpha通道
                top = y;
                found = YES;
                break;
            }
        }
    }
    
    // 找到底部边界
    found = NO;
    for (size_t y = height; y > 0 && !found; y--) {
        for (size_t x = 0; x < width; x++) {
            size_t loc = (x + (y - 1) * width) * 4;
            if (pixelData[loc + 3] != 0) {
                bottom = y - 1;
                found = YES;
                break;
            }
        }
    }
    
    // 找到左边界
    found = NO;
    for (size_t x = 0; x < width && !found; x++) {
        for (size_t y = 0; y < height; y++) {
            size_t loc = (x + y * width) * 4;
            if (pixelData[loc + 3] != 0) {
                left = x;
                found = YES;
                break;
            }
        }
    }
    
    // 找到右边界
    found = NO;
    for (size_t x = width; x > 0 && !found; x--) {
        for (size_t y = 0; y < height; y++) {
            size_t loc = ((x - 1) + y * width) * 4;
            if (pixelData[loc + 3] != 0) {
                right = x - 1;
                found = YES;
                break;
            }
        }
    }
    
    // 释放图像数据
    CFRelease(imageData);
    
    // 检查裁剪范围是否合法
    if (top == -1 || left == -1 || right == -1 || bottom == -1) {
        NSLog(@"未找到非透明区域");
        return nil;
    }
    
    // 计算裁剪区域
    CGFloat scale = self.scale;
    CGRect cropRect = CGRectMake(left / scale, top / scale,
                                 (right - left + 1) / scale,
                                 (bottom - top + 1) / scale);
    
    // 裁剪图片
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(inImage, cropRect);
    if (!croppedImageRef) {
        NSLog(@"裁剪图片失败");
        return nil;
    }
    
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef scale:scale orientation:self.imageOrientation];
    CGImageRelease(croppedImageRef);
    
    return croppedImage;
}

#pragma mark - Private Helper Methods

/**
 * @brief 创建一个边框遮罩，使外边框部分透明，内部完全不透明。
 *
 * @param borderSize 边框的尺寸。
 * @param size 遮罩整体的尺寸（包括边框和内容区域）。
 *
 * @return 创建好的遮罩 CGImageRef，需要由调用者负责调用 CGImageRelease 释放。
 */
- (CGImageRef)zhh_newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    // 创建灰度色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // 创建上下文，与指定的尺寸和色彩空间匹配
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,       // 宽度
                                                     size.height,      // 高度
                                                     8,                // 每个组件8位（灰度）
                                                     0,                // 自动计算每行字节数
                                                     colorSpace,       // 灰度色彩空间
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    if (!maskContext) {
        CGColorSpaceRelease(colorSpace);
        return NULL; // 如果上下文创建失败，直接返回 NULL
    }
    
    // 填充整个上下文为黑色（完全透明）
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // 在中心部分填充白色（完全不透明）
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize,
                                              borderSize,
                                              size.width - borderSize * 2,
                                              size.height - borderSize * 2));
    
    // 从上下文生成遮罩图片
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // 清理内存
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef; // 返回生成的遮罩
}
@end
