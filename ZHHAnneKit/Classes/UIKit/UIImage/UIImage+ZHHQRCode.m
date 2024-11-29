//
//  UIImage+ZHHQRCode.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHQRCode.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (ZHHQRCode)
#pragma mark - 二维码/条形码生成器

/// 生成二维码滤镜
/// @param content 二维码内容字符串
/// @return 生成的二维码 CIImage 对象
+ (CIImage *)zhh_generateQRCodeCIImageWithContent:(NSString *)content {
    // 创建二维码生成器滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    // 设置二维码内容并转换为数据
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 输出二维码的 CIImage 对象
    return filter.outputImage;
}

/// 生成指定尺寸的二维码图片
/// @param content 二维码内容字符串
/// @param size 生成的二维码图片尺寸
/// @return 生成的二维码 UIImage 对象
+ (UIImage *)zhh_generateQRCodeImageWithContent:(NSString *)content size:(CGFloat)size {
    // 生成二维码的 CIImage
    CIImage *ciImage = [self zhh_generateQRCodeCIImageWithContent:content];
    
    // 转换为高清图片并返回
    return [self zhh_createHDImageFromCIImage:ciImage size:size];
}

/// 生成指定尺寸和颜色的二维码图片
/// @param content 二维码内容字符串
/// @param size 生成的二维码图片尺寸
/// @param color 自定义颜色
/// @return 生成的二维码 UIImage 对象
+ (UIImage *)zhh_generateQRCodeImageWithContent:(NSString *)content size:(CGFloat)size color:(UIColor *)color {
    // 生成基础的二维码图片
    UIImage *image = [self zhh_generateQRCodeImageWithContent:content size:size];
    
    // 修改二维码像素颜色并返回
    return [self zhh_changeImagePixelColor:image color:color];
}

/// 生成条形码滤镜
/// @param content 条形码内容字符串
/// @return 生成的条形码 CIImage 对象
+ (CIImage *)zhh_generateBarcodeCIImageWithContent:(NSString *)content {
    // 创建条形码生成器滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 设置条形码的空白边距为 0
    [filter setValue:@(0.00) forKey:@"inputQuietSpace"];
    
    // 输出条形码的 CIImage 对象
    return filter.outputImage;
}

/// 生成指定尺寸的条形码图片
/// @param content 条形码内容字符串
/// @param size 生成的条形码图片尺寸
/// @return 生成的条形码 UIImage 对象
+ (UIImage *)zhh_generateBarcodeImageWithContent:(NSString *)content size:(CGFloat)size {
    // 生成条形码的 CIImage
    CIImage *ciImage = [self zhh_generateBarcodeCIImageWithContent:content];
    
    // 转换为高清图片并返回
    return [self zhh_createHDImageFromCIImage:ciImage size:size];
}

/// 生成指定尺寸和颜色的条形码图片
/// @param content 条形码内容字符串
/// @param size 生成的条形码图片尺寸
/// @param color 自定义颜色
/// @return 生成的条形码 UIImage 对象
+ (UIImage *)zhh_generateBarcodeImageWithContent:(NSString *)content size:(CGFloat)size color:(UIColor *)color {
    // 生成基础的条形码图片
    UIImage *image = [self zhh_generateBarcodeImageWithContent:content size:size];
    
    // 修改条形码像素颜色并返回
    return [self zhh_changeImagePixelColor:image color:color];
}

#pragma mark - 私有方法

/// 将 CIImage 转换为指定尺寸的高清 UIImage
/// @param image 输入的 CIImage
/// @param size 输出的图片尺寸
/// @return 转换后的高清 UIImage 对象
+ (UIImage *)zhh_createHDImageFromCIImage:(CIImage *)image size:(CGFloat)size {
    // 获取 CIImage 的原始尺寸
    CGRect integralRect = CGRectIntegral(image.extent);
    
    // 计算缩放比例
    CGFloat scale = MIN(size / CGRectGetWidth(integralRect), size / CGRectGetHeight(integralRect));
    size_t width = CGRectGetWidth(integralRect) * scale;
    size_t height = CGRectGetHeight(integralRect) * scale;
    
    // 创建灰度颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    
    // 创建位图上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // 将 CIImage 绘制到位图上下文
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    
    // 生成高清 UIImage
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *resultImage = [UIImage imageWithCGImage:scaledImage];
    
    // 释放资源
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(scaledImage);
    
    return resultImage;
}

/// 修改图片像素颜色
/// @param image 输入的 UIImage
/// @param color 替换的颜色
/// @return 修改颜色后的 UIImage
+ (UIImage *)zhh_changeImagePixelColor:(UIImage *)image color:(UIColor *)color {
    // 获取颜色的 RGB 分量
    CGFloat red = 0, green = 0, blue = 0, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    // 获取图片的宽高
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    // 初始化像素缓存
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, space, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    // 绘制图片到上下文
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素修改颜色
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) { // 替换颜色
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[3] = red * 255;
            ptr[2] = green * 255;
            ptr[1] = blue * 255;
        } else { // 设置透明
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // 创建图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, zhh_releaseImageBufferData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, space, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放资源
    CGDataProviderRelease(dataProvider);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    
    return resultImage;
}

/// 释放像素缓存的回调方法
static void zhh_releaseImageBufferData(void *info, const void *data, size_t size) {
    free((void *)data);
}
@end
