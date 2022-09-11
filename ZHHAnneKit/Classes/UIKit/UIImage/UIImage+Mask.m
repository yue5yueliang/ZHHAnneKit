//
//  UIImage+Mask.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIImage+Mask.h"

@implementation UIImage (Mask)
/// 文字水印
- (UIImage *)zhh_waterText:(NSString *)text
                direction:(ZHHImageWaterType)direction
                textColor:(UIColor *)color
                     font:(UIFont *)font
                   margin:(CGPoint)margin{
    CGRect rect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:rect];
    NSDictionary *dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    CGRect calRect = [self zhh_rectWithRect:rect size:[text sizeWithAttributes:dict] direction:direction margin:margin];
    [text drawInRect:calRect withAttributes:dict];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/// 图片水印
- (UIImage *)zhh_waterImage:(UIImage *)image direction:(ZHHImageWaterType)direction waterSize:(CGSize)size margin:(CGPoint)margin{
    CGRect rect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [self drawInRect:rect];
    CGSize waterImageSize = CGSizeEqualToSize(size, CGSizeZero) ? image.size : size;
    CGRect waterRect = [self zhh_rectWithRect:rect size:waterImageSize direction:direction margin:margin];
    [image drawInRect:waterRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (CGRect)zhh_rectWithRect:(CGRect)rect size:(CGSize)size direction:(ZHHImageWaterType)direction margin:(CGPoint)margin{
    CGPoint point = CGPointZero;
    switch (direction) {
        case ZHHImageWaterTypeTopLeft:
            break;
        case ZHHImageWaterTypeTopRight:
            point = CGPointMake(rect.size.width - size.width, 0);
            break;
        case ZHHImageWaterTypeBottomRight:
            point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
            break;
        case ZHHImageWaterTypeCenter:
            point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
            break;
        default:
            break;
    }
    point.x += margin.x;
    point.y += margin.y;
    return (CGRect){point,size};
}

// 画水印
- (UIImage *)zhh_waterMark:(UIImage *)mark InRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGRect imgRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:imgRect];
    [mark drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
/// 蒙版图片处理
- (UIImage *)zhh_maskImage:(UIImage *)maskImage{
    UIImage *image = self;
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        //        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    if (sourceImage != imageWithAlpha) CGImageRelease(imageWithAlpha);
    UIImage * retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
@end
