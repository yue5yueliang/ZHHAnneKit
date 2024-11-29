//
//  UIImage+ZHHCompress.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHCompress.h"

@implementation UIImage (ZHHCompress)

/// 压缩图片到指定大小和最大宽度
/// @param image 原始图片
/// @param maxLength 目标文件大小（字节）
/// @param maxWidth 最大宽度（px）
/// @return 压缩后的图片数据
+ (NSData *)zhh_compressImage:(UIImage *)image toMaxLength:(NSInteger)maxLength maxWidth:(NSInteger)maxWidth {
    // 参数检查
    NSAssert(maxLength > 0, @"图片的大小必须大于 0");
    NSAssert(maxWidth > 0, @"图片的最大宽度必须大于 0");
    
    // 按最大宽度等比缩放
    CGSize scaledSize = [self zhh_scaledSizeForImage:image withMaxLength:maxWidth];
    UIImage *scaledImage = [self zhh_resizedImage:image toSize:scaledSize];
    
    // 初始压缩比例
    CGFloat compression = 0.9f;
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, compression);
    
    // 循环调整压缩比例，直到达到目标文件大小或最小压缩比例
    while (imageData.length > maxLength && compression > 0.01f) {
        compression -= 0.02f;
        imageData = UIImageJPEGRepresentation(scaledImage, compression);
    }
    
    return imageData;
}

/// 调整图片大小
/// @param image 原始图片
/// @param newSize 新的目标尺寸
/// @return 调整大小后的图片
+ (UIImage *)zhh_resizedImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

/// 计算按比例缩放的目标尺寸
/// @param image 原始图片
/// @param maxLength 最大边长
/// @return 按比例缩放后的尺寸
+ (CGSize)zhh_scaledSizeForImage:(UIImage *)image withMaxLength:(CGFloat)maxLength {
    CGFloat originalWidth = image.size.width;
    CGFloat originalHeight = image.size.height;
    CGFloat targetWidth = 0.0f;
    CGFloat targetHeight = 0.0f;

    if (originalWidth > maxLength || originalHeight > maxLength) {
        if (originalWidth > originalHeight) {
            targetWidth = maxLength;
            targetHeight = targetWidth * originalHeight / originalWidth;
        } else {
            targetHeight = maxLength;
            targetWidth = targetHeight * originalWidth / originalHeight;
        }
    } else {
        // 如果图片小于目标尺寸，则不缩放
        targetWidth = originalWidth;
        targetHeight = originalHeight;
    }
    
    return CGSizeMake(targetWidth, targetHeight);
}
@end
