//
//  UIColor+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZHHKit)
/// UIColor to hexadecimal string
- (NSString *)zhh_hexString;
/// UIColor to hexadecimal string
+ (NSString *)zhh_hexStringFromColor:(UIColor *)color;
FOUNDATION_EXPORT NSString * kDoraemonBoxHexStringFromColor(UIColor *color);

/// Convert hexadecimal string to UIColor
/// @param hexString hexadecimal, the beginning of `0x` or `#` are also supported
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString;
FOUNDATION_EXPORT UIColor * kDoraemonBoxColorHexString(NSString *hexString);

/// Convert hexadecimal string to UIColor
/// @param hexString hexadecimal, the beginning of `0x` or `#` are also supported
/// @param alpha transparency
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString alpha:(float)alpha;

/**
 *  使用十六进制数字生成颜色
 *  @param hexColor (格式:0x2d3f4a)
 *
 *  @return UIColor
 */
+ (UIColor *)zhh_colorWithHex:(long)hexColor;
/**
 *  使用十六进制数字生成颜色
 *  @param alpha 透明度(0.0~1.0)
 *
 *  @return UIColor
 */
+ (UIColor *)zhh_colorWithHex:(long)hexColor alpha:(float)alpha;

/// random color
FOUNDATION_EXPORT UIColor * kDoraemonBoxRandomColor(void);

/// 图片生成颜色
+ (UIColor *)zhh_colorWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
