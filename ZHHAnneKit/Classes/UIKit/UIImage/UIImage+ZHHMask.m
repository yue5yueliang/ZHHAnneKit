//
//  UIImage+ZHHMask.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHMask.h"

@implementation UIImage (ZHHMask)

/// 添加文字水印
- (UIImage *)zhh_addTextWatermark:(NSString *)text direction:(ZHHImageWaterType)direction color:(UIColor *)color font:(UIFont *)font margin:(CGPoint)margin {
    // 获取原图的绘制区域
    CGRect rect = (CGRect){CGPointZero, self.size};
    // 开启图形上下文，生成新的图像
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:rect]; // 绘制原图

    // 设置水印文字的样式
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
    // 根据水印文字计算其绘制的区域
    CGRect textRect = [self zhh_calculateRectWithSize:[text sizeWithAttributes:attributes] direction:direction margin:margin];
    // 绘制水印文字
    [text drawInRect:textRect withAttributes:attributes];

    // 获取合成后的图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 关闭图形上下文
    return resultImage;
}

/// 添加图片水印
- (UIImage *)zhh_addImageWatermark:(UIImage *)watermark direction:(ZHHImageWaterType)direction  size:(CGSize)size margin:(CGPoint)margin {
    // 获取原图的绘制区域
    CGRect rect = (CGRect){CGPointZero, self.size};
    // 开启图形上下文，生成新的图像
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:rect]; // 绘制原图

    // 如果水印大小为 CGSizeZero，默认使用水印图片的原始尺寸
    CGSize waterSize = CGSizeEqualToSize(size, CGSizeZero) ? watermark.size : size;
    // 计算水印图片的绘制区域
    CGRect waterRect = [self zhh_calculateRectWithSize:waterSize direction:direction margin:margin];
    // 绘制水印图片
    [watermark drawInRect:waterRect];

    // 获取合成后的图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 关闭图形上下文
    return resultImage;
}

/// 计算水印绘制区域
- (CGRect)zhh_calculateRectWithSize:(CGSize)size direction:(ZHHImageWaterType)direction margin:(CGPoint)margin {
    CGPoint point = CGPointZero; // 初始化为左上角

    // 根据方向计算绘制起点
    switch (direction) {
        case ZHHImageWaterTypeLeftTop:
            point = CGPointMake(0 + margin.x, 0 + margin.y);
            break;
        case ZHHImageWaterTypeLeftBottom:
            point = CGPointMake(0 + margin.x, self.size.height - size.height - margin.y);
            break;
        case ZHHImageWaterTypeRightTop:
            point = CGPointMake(self.size.width - size.width - margin.x, 0 + margin.y);
            break;
        case ZHHImageWaterTypeRightBottom:
            point = CGPointMake(self.size.width - size.width - margin.x, self.size.height - size.height - margin.y);
            break;
        case ZHHImageWaterTypeCenter:
        default:
            point = CGPointMake((self.size.width - size.width) * 0.5 + margin.x, (self.size.height - size.height) * 0.5 + margin.y);
            break;
    }
    return (CGRect){point, size};
}

/// 图片水印合成（直接指定区域）
- (UIImage *)zhh_addImageMark:(UIImage *)mark rect:(CGRect)rect {
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGRect imgRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:imgRect]; // 绘制原图
    [mark drawInRect:rect];    // 绘制水印图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 关闭上下文
    return resultImage;
}

/// 应用蒙版效果
- (UIImage *)zhh_applyMask:(UIImage *)image {
    CGImageRef maskRef = image.CGImage;
    // 创建蒙版
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);

    // 将蒙版与原图合成
    CGImageRef maskedImageRef = CGImageCreateWithMask(self.CGImage, mask);
    UIImage *resultImage = [UIImage imageWithCGImage:maskedImageRef];

    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    return resultImage;
}

@end
