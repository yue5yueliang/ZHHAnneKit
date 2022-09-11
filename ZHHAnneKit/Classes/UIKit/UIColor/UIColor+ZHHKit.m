//
//  UIColor+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIColor+ZHHKit.h"

@implementation UIColor (ZHHKit)
// UIColor转#ffffff格式的16进制字符串
- (NSString *)zhh_hexString{
    return [UIColor zhh_hexStringFromColor:self];
}

+ (NSString *)zhh_hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",lroundf(r*255),lroundf(g*255),lroundf(b*255)];
}

NSString *kDoraemonBoxHexStringFromColor(UIColor *color){
    return [UIColor zhh_hexStringFromColor:color];
}

UIColor * kDoraemonBoxColorHexString(NSString *hexString){
    return [UIColor zhh_colorWithHexString:hexString];
}

/// 16进制字符串转UIColor
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString {
    return [self zhh_colorWithHexString:hexString alpha:1.0];
}

/// 16进制字符串转UIColor
/// @param hexString 十六进制
/// @param alpha 透明度
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString alpha:(float)alpha{
    NSString *string = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if ([hexString hasPrefix:@"0x"]) {
        string = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    CGFloat red,blue,green;
    switch ([string length]) {
        case 3: // #RGB
            alpha = 1.0f;
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
            alpha = 1.0f;
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
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)zhh_colorComponent:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start,length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@",substring,substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)zhh_colorWithHex:(long)hexColor {
    return [UIColor zhh_colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)zhh_colorWithHex:(long)hexColor alpha:(float)alpha {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 随机颜色
UIColor * kDoraemonBoxRandomColor(void){
    return [UIColor colorWithRed:((float)arc4random_uniform(256)/255.0)
                           green:((float)arc4random_uniform(256)/255.0)
                            blue:((float)arc4random_uniform(256)/255.0)
                           alpha:1.0];
}

/// 图片生成颜色
+ (UIColor *)zhh_colorWithImage:(UIImage *)image{
    return [UIColor colorWithPatternImage:image];
}
@end
