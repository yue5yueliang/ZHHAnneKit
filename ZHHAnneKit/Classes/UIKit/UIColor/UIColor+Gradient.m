//
//  UIColor+Gradient.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIColor+Gradient.h"

@implementation UIColor (Gradient)
/// 渐变颜色
+ (UIColor *)zhh_gradientColorWithColors:(NSArray *)colors gradientType:(ZHHGradietColorType)type size:(CGSize)size{
    NSMutableArray *temps = [NSMutableArray array];
    for(UIColor *c in colors){
        [temps addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)temps, NULL);
    temps = nil;
    CGPoint start,end;
    switch (type) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

/// 获取颜色的均值
+ (UIColor *)zhh_averageColors:(NSArray<UIColor*>*)colors{
    if (!colors || colors.count == 0)  return nil;
    CGFloat reds = 0.0f;
    CGFloat greens = 0.0f;
    CGFloat blues = 0.0f;
    CGFloat alphas = 0.0f;
    NSInteger count = 0;
    for (UIColor *c in colors) {
        CGFloat red = 0.0f;
        CGFloat green = 0.0f;
        CGFloat blue = 0.0f;
        CGFloat alpha = 0.0f;
        BOOL success = [c getRed:&red green:&green blue:&blue alpha:&alpha];
        if (success) {
            reds += red;
            greens += green;
            blues += blue;
            alphas += alpha;
            count++;
        }
    }
    return [UIColor colorWithRed:reds/count green:greens/count blue:blues/count alpha:alphas/count];
}

/// 获取图片上指定点的颜色
+ (UIColor *)zhh_colorAtImage:(UIImage *)image point:(CGPoint)point{
    return [self zhh_colorAtPixel:point size:image.size image:image];
}

/// 获取ImageView上指定点的图片颜色
+ (UIColor *)zhh_colorAtImageView:(UIImageView*)imageView point:(CGPoint)point{
    return [self zhh_colorAtPixel:point size:imageView.frame.size image:imageView.image];
}

+ (UIColor *)zhh_colorAtPixel:(CGPoint)point size:(CGSize)size image:(UIImage *)image{
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    if (!CGRectContainsPoint(rect, point)) return nil;
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -pointX, pointY - size.height);
    CGContextDrawImage(context, rect, cgImage);
    CGContextRelease(context);
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 兼容Swift版本，可变参数渐变色
- (UIColor *)zhh_gradientSize:(CGSize)size color:(UIColor *)color,...{
    NSMutableArray * colors = [NSMutableArray arrayWithObjects:(id)self.CGColor,(id)color.CGColor,nil];
    va_list args;UIColor * arg;
    va_start(args, color);
    while ((arg = va_arg(args, UIColor *))) {
        [colors addObject:(id)arg.CGColor];
    }
    va_end(args);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(size.width, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

/// 渐变色
- (UIColor *)zhh_gradientVerticalToColor:(UIColor *)color height:(CGFloat)height{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSArray * colors = [NSArray arrayWithObjects:(id)self.CGColor, (id)color.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

- (UIColor *)zhh_gradientAcrossToColor:(UIColor *)color width:(CGFloat)width{
    CGSize size = CGSizeMake(width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSArray * colors = [NSArray arrayWithObjects:(id)self.CGColor, (id)color.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

/// 生成渐变色图片
+ (UIImage *)zhh_colorImageWithColors:(NSArray<UIColor*>*)colors
                            locations:(NSArray<NSNumber*>*)locations
                                 size:(CGSize)size
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor{
    NSAssert(colors || locations, @"colors and locations must has value");
    NSAssert(colors.count == locations.count, @"Please make sure colors and locations count is equal");
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (borderWidth > 0 && borderColor) {
        CGRect rect = CGRectMake(size.width * 0.01, 0, size.width * 0.98, size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.height*0.5];
        [borderColor setFill];
        [path fill];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(size.width * 0.01 + borderWidth,
                                                                            borderWidth,
                                                                            size.width * 0.98 - borderWidth * 2,
                                                                            size.height - borderWidth * 2)
                                                    cornerRadius:size.height * 0.5];
    [self zhh_drawLinearGradient:context path:path.CGPath colors:colors locations:locations];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)zhh_drawLinearGradient:(CGContextRef)context
                          path:(CGPathRef)path
                        colors:(NSArray<UIColor*>*)colors
                     locations:(NSArray<NSNumber*>*)locations{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colorefs = [@[] mutableCopy];
    [colors enumerateObjectsUsingBlock:^(UIColor *obj, NSUInteger idx, BOOL *stop) {
        [colorefs addObject:(__bridge id)obj.CGColor];
    }];
    CGFloat locs[locations.count];
    for (int i = 0; i < locations.count; i++) {
        locs[i] = locations[i].floatValue;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorefs, locs);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
