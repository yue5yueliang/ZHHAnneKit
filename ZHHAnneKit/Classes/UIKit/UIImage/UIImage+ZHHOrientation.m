//
//  UIImage+ZHHOrientation.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHOrientation.h"

@implementation UIImage (ZHHOrientation)
/**
 *  @brief 修正图片方向
 *
 *  @discussion
 *  部分图片在加载时可能会因为拍摄设备或编辑软件的原因导致方向显示异常。
 *  此方法通过检测图片的 `imageOrientation` 属性，调整图片的方向，生成一张方向正确的图片。
 *
 *  @param srcImg 原始图片
 *  @return 修正方向后的图片
 */
+ (UIImage *)zhh_fixOrientation:(UIImage *)srcImg {
    // 如果图片的方向已经是正确的（默认方向），直接返回原图
    if (srcImg.imageOrientation == UIImageOrientationUp) {
        return srcImg;
    }

    // 创建一个空的仿射变换矩阵，用于后续的图片方向修正
    CGAffineTransform transform = CGAffineTransformIdentity;

    // 根据图片的方向调整变换矩阵
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            // 旋转180度并平移宽高，修正上下颠倒
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            // 旋转90度并平移宽度，修正左转90度
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // 旋转-90度并平移高度，修正右转90度
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    // 处理镜像图片的情况
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            // 垂直镜像
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            // 水平镜像
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // 创建绘制上下文，指定图片尺寸、颜色空间和位图信息
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             srcImg.size.width,
                                             srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage),
                                             0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));

    // 应用之前的变换矩阵
    CGContextConcatCTM(ctx, transform);

    // 绘制图片到上下文，调整宽高顺序以处理旋转
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, srcImg.size.height, srcImg.size.width), srcImg.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, srcImg.size.width, srcImg.size.height), srcImg.CGImage);
            break;
    }

    // 从上下文中生成新的图片
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];

    // 释放上下文和图片引用
    CGContextRelease(ctx);
    CGImageRelease(cgimg);

    // 返回修正后的图片
    return img;
}

/**
 *  @brief 翻转图片
 *
 *  @discussion
 *  该方法通过图形上下文实现图片的水平或垂直翻转。
 *
 *  @param isHorizontal 是否水平翻转。如果为 `YES`，执行水平翻转；否则为垂直翻转。
 *  @return 翻转后的图片
 */
- (UIImage *)zhh_flip:(BOOL)isHorizontal {
    // 创建绘制区域，匹配图片大小
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (isHorizontal) {
        // 水平翻转：沿着垂直中线对称翻转
        CGContextTranslateCTM(ctx, rect.size.width, 0);
        CGContextScaleCTM(ctx, -1, 1);
    } else {
        // 垂直翻转：沿着水平中线对称翻转
        CGContextTranslateCTM(ctx, 0, rect.size.height);
        CGContextScaleCTM(ctx, 1, -1);
    }

    // 绘制图片
    CGContextDrawImage(ctx, rect, self.CGImage);

    // 从上下文中获取生成的图片
    UIImage *flippedImage = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图形上下文
    UIGraphicsEndImageContext();

    return flippedImage;
}

/**
 *  @brief 垂直翻转图片
 *
 *  @discussion
 *  通过调用通用翻转方法，将图片沿水平中线对称翻转。
 *
 *  @return 垂直翻转后的图片
 */
- (UIImage *)zhh_flipVertical {
    return [self zhh_flip:NO];
}

/**
 *  @brief 水平翻转图片
 *
 *  @discussion
 *  通过调用通用翻转方法，将图片沿垂直中线对称翻转。
 *
 *  @return 水平翻转后的图片
 */
- (UIImage *)zhh_flipHorizontal {
    return [self zhh_flip:YES];
}

/// @brief 根据弧度旋转图片
/// @param radians 图片旋转的弧度值（以圆周角表示，弧度 = 度数 * π / 180）
/// @return 旋转后的图片
- (UIImage *)zhh_imageRotatedByRadians:(CGFloat)radians {
    // 将弧度转换为角度并调用角度旋转方法
    return [self zhh_imageRotatedByDegrees:[UIImage zhh_radiansToDegrees:radians]];
}

/// @brief 根据角度旋转图片
/// @param degrees 图片旋转的角度值（例如 90°、180° 等）
/// @return 旋转后的图片
- (UIImage *)zhh_imageRotatedByDegrees:(CGFloat)degrees {
    // 计算旋转后的画布尺寸
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation([UIImage zhh_degreesToRadians:degrees]);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    // 创建位图上下文，大小为旋转后的画布尺寸
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // 平移画布的原点到图片的中心位置（以中心为旋转点）
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);

    // 按指定角度旋转画布
    CGContextRotateCTM(bitmap, [UIImage zhh_degreesToRadians:degrees]);

    // 翻转 Y 轴（因为 CGContext 的坐标系是左下角为原点，而 UIImage 的坐标系是左上角为原点）
    CGContextScaleCTM(bitmap, 1.0, -1.0);

    // 绘制旋转后的图片
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), self.CGImage);

    // 从当前上下文中提取旋转后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图形上下文
    UIGraphicsEndImageContext();

    return newImage;
}

/// @brief 将弧度转换为角度
/// @param radians 弧度值
///  @return 对应的角度值
+ (CGFloat)zhh_radiansToDegrees:(CGFloat)radians {
    return radians * (180.0 / M_PI);
}

/// @brief 将角度转换为弧度
/// @param degrees 角度值
/// @return 对应的弧度值
+ (CGFloat)zhh_degreesToRadians:(CGFloat)degrees {
    return degrees * (M_PI / 180.0);
}
@end
