//
//  UIColor+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIColor+ZHHUtilities.h"

@implementation UIColor (ZHHUtilities)
/// 将 UIColor 转换为十六进制颜色字符串（默认不带透明度）
/// @return 十六进制颜色字符串，格式为 #RRGGBB
- (NSString *)zhh_hexString {
    CGColorRef colorRef = self.CGColor;
    size_t componentCount = CGColorGetNumberOfComponents(colorRef);

    // 检查颜色空间，处理灰度或 RGB 情况
    if (componentCount == 4) { // RGB 颜色空间
        const CGFloat *components = CGColorGetComponents(colorRef);
        CGFloat r = components[0];
        CGFloat g = components[1];
        CGFloat b = components[2];
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
                lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    } else if (componentCount == 2) { // 灰度颜色空间
        const CGFloat *components = CGColorGetComponents(colorRef);
        CGFloat gray = components[0];
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
                lroundf(gray * 255), lroundf(gray * 255), lroundf(gray * 255)];
    }

    // 默认返回透明值（黑色）
    return @"#000000";
}

- (void)zhh_rgbValues {
    // 获取 RGB 值描述
    NSString *rgbValue = [NSString stringWithFormat:@"%@", self];
    // 将 RGB 值描述分隔成字符串
    NSArray *rgbArr = [rgbValue componentsSeparatedByString:@" "];
    
    if (rgbArr.count > 3) {
        // 获取红色值
        CGFloat r = [[rgbArr objectAtIndex:1] floatValue] * 255;
        // 获取绿色值
        CGFloat g = [[rgbArr objectAtIndex:2] floatValue] * 255;
        // 获取蓝色值
        CGFloat b = [[rgbArr objectAtIndex:3] floatValue] * 255;
        NSLog(@"---红色值: %.f, 绿色值: %.f, 蓝色值: %.f---", r, g, b);
    } else {
        NSLog(@"无法获取有效的 RGB 值，请确保颜色是由 RGB 模型定义的");
    }
}

/// 从 16 进制整数生成 UIColor（默认透明度为 1.0）
/// @param hexColor 16 进制颜色值（如 0xFF5733）
/// @param alpha 透明度（可选），范围 [0, 1]
/// @return 转换后的 UIColor
+ (UIColor *)zhh_colorWithHex:(long)hexColor alpha:(float)alpha {
    float red = ((float)((hexColor & 0xFF0000) >> 16)) / 255.0;
    float green = ((float)((hexColor & 0x00FF00) >> 8)) / 255.0;
    float blue = ((float)(hexColor & 0x0000FF)) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 从 16 进制整数生成 UIColor（默认透明度为 1.0）
/// @param hexColor 16 进制颜色值（如 0xFF5733）
/// @return 转换后的 UIColor
+ (UIColor *)zhh_colorWithHex:(long)hexColor {
    return [self zhh_colorWithHex:hexColor alpha:1.0];
}

/// 16 进制字符串转 UIColor（默认透明度为 1.0）
/// @param hexString 十六进制颜色字符串，支持格式：#RGB、#ARGB、#RRGGBB、#AARRGGBB（大小写均可）
/// @return 转换后的 UIColor 对象
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString {
    return [self zhh_colorWithHexString:hexString alpha:1.0];
}

/// 16进制字符串转 UIColor
/// @param hexString 十六进制颜色字符串，支持格式：#RGB、#ARGB、#RRGGBB、#AARRGGBB（大小写均可）
/// @param alpha 透明度（优先使用 hexString 的 alpha 值，如果格式不带 alpha，则使用该参数）
/// @return 转换后的 UIColor 对象
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString alpha:(float)alpha {
    // 去掉前缀符号并转为大写
    NSString *string = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if ([string hasPrefix:@"0X"]) {
        string = [string stringByReplacingOccurrencesOfString:@"0X" withString:@""];
    }
    
    // 检查长度是否合法
    if (string.length != 3 && string.length != 4 && string.length != 6 && string.length != 8) {
        NSLog(@"Invalid hex string format: %@", hexString);
        return nil;
    }
    
    // 提取颜色分量
    CGFloat red = 0, green = 0, blue = 0;
    switch (string.length) {
        case 3: // #RGB
            red   = [self zhh_colorComponent:string start:0 length:1];
            green = [self zhh_colorComponent:string start:1 length:1];
            blue  = [self zhh_colorComponent:string start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self zhh_colorComponent:string start:0 length:1];
            red   = [self zhh_colorComponent:string start:1 length:1];
            green = [self zhh_colorComponent:string start:2 length:1];
            blue  = [self zhh_colorComponent:string start:3 length:1];
            break;
        case 6: // #RRGGBB
            red   = [self zhh_colorComponent:string start:0 length:2];
            green = [self zhh_colorComponent:string start:2 length:2];
            blue  = [self zhh_colorComponent:string start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self zhh_colorComponent:string start:0 length:2];
            red   = [self zhh_colorComponent:string start:2 length:2];
            green = [self zhh_colorComponent:string start:4 length:2];
            blue  = [self zhh_colorComponent:string start:6 length:2];
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 从十六进制字符串中提取颜色分量
/// @param string 十六进制字符串（已去掉 # 或 0x 前缀）
/// @param start 起始位置
/// @param length 颜色分量的长度（1 表示单字符，如 R；2 表示双字符，如 RR）
/// @return 转换后的颜色分量值，范围 [0, 1]
+ (CGFloat)zhh_colorComponent:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    // 如果长度是 1，扩展为 2 位（例如 R -> RR）
    NSString *fullHex = (length == 2) ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent = 0;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

/// 从 RGBA 整数值生成 UIColor
/// @param rgba RGBA 值，每个分量占 8 位（如 0xFF5733FF）
/// @return 转换后的 UIColor
+ (instancetype)zhh_colorWithRGBA:(NSUInteger)rgba {
    uint8_t red = (rgba >> 24) & 0xFF;
    uint8_t green = (rgba >> 16) & 0xFF;
    uint8_t blue = (rgba >> 8) & 0xFF;
    uint8_t alpha = rgba & 0xFF;
    return [self zhh_colorWithRed:red green:green blue:blue alpha:alpha / 255.0];
}

/// 使用 RGB 分量生成 UIColor，透明度默认为 1
/// @param red 红色分量，范围 [0, 255]
/// @param green 绿色分量，范围 [0, 255]
/// @param blue 蓝色分量，范围 [0, 255]
/// @return 转换后的 UIColor
+ (instancetype)zhh_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue {
    return [self zhh_colorWithRed:red green:green blue:blue alpha:1.0];
}

/// 使用 RGB 分量和透明度生成 UIColor
/// @param red 红色分量，范围 [0, 255]
/// @param green 绿色分量，范围 [0, 255]
/// @param blue 蓝色分量，范围 [0, 255]
/// @param alpha 透明度，范围 [0, 1]
/// @return 转换后的 UIColor
+ (instancetype)zhh_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

/// 生成随机颜色
/// @param alpha 透明度，范围 [0, 1]，默认值为 1
/// @return 随机生成的 UIColor
+ (instancetype)zhh_randomColorWithAlpha:(CGFloat)alpha {
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 无透明度参数版本，默认透明度为 1
+ (instancetype)zhh_randomColor {
    return [self zhh_randomColorWithAlpha:1.0];
}

/// 图片生成颜色
+ (UIColor *)zhh_colorWithImage:(UIImage *)image{
    return [UIColor colorWithPatternImage:image];
}

/// 获取颜色的均值
+ (UIColor *)zhh_colorsAverage:(NSArray<UIColor*>*)colors{
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

/// 生成渐变色图片
/// @param colors 渐变的颜色数组
/// @param locations 渐变的颜色位置数组，值范围为 [0, 1]
/// @param size 图片尺寸
/// @param borderWidth 边框宽度（为 0 时无边框）
/// @param borderColor 边框颜色（为 nil 时无边框）
/// @return 生成的渐变色图片
+ (UIImage *)zhh_colorImageWithColors:(NSArray<UIColor *> *)colors
                            locations:(NSArray<NSNumber *> *)locations
                                 size:(CGSize)size
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor {
    // 检查输入有效性
    NSAssert(colors.count > 0, @"'colors' must have at least one color.");
    NSAssert(colors.count == locations.count, @"'colors' and 'locations' count must be equal.");
    NSAssert(size.width > 0 && size.height > 0, @"'size' must have positive width and height.");
    
    // 创建图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        UIGraphicsEndImageContext();
        return nil;
    }
    
    // 绘制边框（如果边框宽度大于 0 且颜色有效）
    if (borderWidth > 0 && borderColor) {
        CGRect borderRect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect
                                                              cornerRadius:size.height * 0.5];
        [borderColor setFill];
        [borderPath fill];
    }
    
    // 计算渐变区域
    CGRect gradientRect = CGRectMake(borderWidth,
                                     borderWidth,
                                     size.width - borderWidth * 2,
                                     size.height - borderWidth * 2);
    UIBezierPath *gradientPath = [UIBezierPath bezierPathWithRoundedRect:gradientRect
                                                            cornerRadius:size.height * 0.5];
    
    // 调用线性渐变方法绘制渐变
    [self zhh_drawLinearGradient:context path:gradientPath.CGPath colors:colors locations:locations];
    
    // 获取生成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/// 绘制线性渐变
/// @param context 当前图形上下文
/// @param path 用于绘制的路径
/// @param colors 渐变的颜色数组
/// @param locations 渐变的颜色位置数组，值范围为 [0, 1]
+ (void)zhh_drawLinearGradient:(CGContextRef)context
                          path:(CGPathRef)path
                        colors:(NSArray<UIColor *> *)colors
                     locations:(NSArray<NSNumber *> *)locations {
    // 检查参数有效性
    if (!context || !path || colors.count == 0 || (locations && locations.count != colors.count)) {
        return;
    }

    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) return;

    // 构造颜色数组
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }

    // 生成位置数组
    CGFloat *locs = NULL;
    if (locations) {
        locs = (CGFloat *)malloc(sizeof(CGFloat) * locations.count);
        for (NSUInteger i = 0; i < locations.count; i++) {
            locs[i] = locations[i].floatValue;
        }
    }

    // 创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, locs);
    free(locs);
    CGColorSpaceRelease(colorSpace);

    if (!gradient) return;

    // 计算起点和终点
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));

    // 保存上下文状态，添加路径并裁剪
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);

    // 绘制渐变
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    // 恢复上下文状态
    CGContextRestoreGState(context);

    // 释放渐变对象
    CGGradientRelease(gradient);
}

+ (UIColor *)zhh_colorWithGradientColor1:(UIColor *)color1 color2:(UIColor *)color2 height:(CGFloat)height{
    return [UIColor zhh_colorWithGradientColors:@[color1,color2] locations:nil point:CGPointZero size:height direction:(ZHHGradietDirectionTypeTopToBottom)];
}

+ (UIColor *)zhh_colorWithGradientColor1:(UIColor *)color1 color2:(UIColor *)color2 width:(CGFloat)width{
    return [UIColor zhh_colorWithGradientColors:@[color1,color2] locations:nil point:CGPointZero size:width direction:(ZHHGradietDirectionTypeLeftToRight)];
}

+ (UIColor *)zhh_colorWithGradientColors:(NSArray<UIColor *> *)colors
                               locations:(NSArray<NSNumber *> * _Nullable)locations
                                   point:(CGPoint)point
                                    size:(CGFloat)size
                               direction:(ZHHGradietDirectionType)direction {
    // 计算起点和终点的坐标
    CGPoint startPoint = point;
    CGPoint endPoint = point;
    
    // 根据方向设置终点位置
    switch (direction) {
        case ZHHGradietDirectionTypeTopToBottom:
            endPoint.y += size;
            break;
        case ZHHGradietDirectionTypeBottomToTop:
            endPoint.y -= size;
            break;
        case ZHHGradietDirectionTypeLeftToRight:
            endPoint.x += size;
            break;
        case ZHHGradietDirectionTypeRightToLeft:
            endPoint.x -= size;
            break;
        case ZHHGradietDirectionTypeLeftTopToRightBottom:
            endPoint.x += size;
            endPoint.y += size;
            break;
        case ZHHGradietDirectionTypeLeftBottomToRightTop:
            endPoint.x += size;
            endPoint.y -= size;
            break;
        case ZHHGradietDirectionTypeRightBottomLeftTop:
            endPoint.x -= size;
            endPoint.y -= size;
            break;
        case ZHHGradietDirectionTypeRightTopToLeftBottom:
            endPoint.x -= size;
            endPoint.y += size;
            break;
        default:
            break;
    }
    
    // 创建渐变绘制的画布大小
    CGSize canvasSize = CGSizeMake(size * 2, size * 2);
    
    // 创建上下文
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil; // 确保上下文创建成功
    }
    
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 将 UIColor 转换为 CGColor 并存储在数组中
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    
    // 处理位置参数
    CGFloat *positions = NULL;
    if (locations.count > 0) {
        positions = (CGFloat *)calloc(locations.count, sizeof(CGFloat));
        for (NSInteger i = 0; i < locations.count; i++) {
            positions[i] = locations[i].floatValue;
        }
    }
    
    // 创建渐变
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)cgColors, positions);
    
    // 绘制渐变 (线性渐变)
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // 获取绘制的图像
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 清理内存
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    if (positions) {
        free(positions);
    }
    UIGraphicsEndImageContext();
    
    // 将图像转换为 UIColor
    return [UIColor colorWithPatternImage:gradientImage];
}
@end