//
//  UIColor+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,ZHHGradietDirectionType) {
    ZHHGradietDirectionTypeTopToBottom = 0,
    ZHHGradietDirectionTypeBottomToTop,
    ZHHGradietDirectionTypeLeftToRight,
    ZHHGradietDirectionTypeRightToLeft,
    ZHHGradietDirectionTypeLeftTopToRightBottom,
    ZHHGradietDirectionTypeLeftBottomToRightTop,
    ZHHGradietDirectionTypeRightTopToLeftBottom,
    ZHHGradietDirectionTypeRightBottomLeftTop
};

@interface UIColor (ZHHUtilities)
/**
 创建一个支持浅色和深色模式的动态颜色

 此方法根据系统的界面样式（浅色模式或深色模式）返回不同的颜色：
 - 在 iOS 13 及以上系统中，使用 `UIColor` 的动态特性，自动适配系统模式。
 - 在 iOS 13 以下版本中，不支持动态颜色，直接返回浅色模式的颜色。

 @param lightColor 浅色模式下使用的颜色
 @param darkColor 深色模式下使用的颜色
 @return 一个动态颜色对象，在浅色和深色模式下显示不同的颜色
 */
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
/// 将 UIColor 转换为十六进制颜色字符串（默认不带透明度）
/// @return 十六进制颜色字符串，格式为 #RRGGBB
- (NSString *)zhh_hexString;

/// 从 16 进制整数生成 UIColor（默认透明度为 1.0）
/// @param hexColor 16 进制颜色值（如 0xFF5733）
/// @param alpha 透明度（可选），范围 [0, 1]
/// @return 转换后的 UIColor
+ (UIColor *)zhh_colorWithHex:(long)hexColor alpha:(float)alpha;

/// 从 16 进制整数生成 UIColor（默认透明度为 1.0）
/// @param hexColor 16 进制颜色值（如 0xFF5733）
/// @return 转换后的 UIColor
+ (UIColor *)zhh_colorWithHex:(long)hexColor;

/// 使用 16 进制字符串生成 UIColor（透明度默认为 1.0）
/// @param hexString 十六进制颜色字符串，支持格式：#RGB、#RRGGBB、0xRGB、0xRRGGBB（大小写均可）
/// @return 转换后的 UIColor 对象
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString;

/// 使用 16 进制字符串生成 UIColor，并指定透明度
/// @param hexString 十六进制颜色字符串，支持格式：#RGB、#ARGB、#RRGGBB、#AARRGGBB（大小写均可）
/// @param alpha 透明度（优先使用 hexString 的 alpha 值，如果格式不带 alpha，则使用该参数）
/// @return 转换后的 UIColor 对象
+ (UIColor *)zhh_colorWithHexString:(NSString *)hexString alpha:(float)alpha;

/// 从 RGBA 整数值生成 UIColor
/// @param rgba RGBA 值，每个分量占 8 位（如 0xFF5733FF，其中 0xFF 为 alpha）
/// @return 转换后的 UIColor
+ (instancetype)zhh_colorWithRGBA:(NSUInteger)rgba;

/// 使用 RGB 分量生成 UIColor，透明度默认为 1.0（不透明）
/// @param red 红色分量，范围 [0, 255]
/// @param green 绿色分量，范围 [0, 255]
/// @param blue 蓝色分量，范围 [0, 255]
/// @return 转换后的 UIColor
+ (instancetype)zhh_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

/// 使用 RGB 分量和透明度生成 UIColor
/// @param red 红色分量，范围 [0, 255]
/// @param green 绿色分量，范围 [0, 255]
/// @param blue 蓝色分量，范围 [0, 255]
/// @param alpha 透明度，范围 [0, 1]
/// @return 转换后的 UIColor
+ (instancetype)zhh_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(CGFloat)alpha;

/// 获取 UIColor 对象的 RGB 整数值（0xRRGGBB）
- (uint32_t)zhh_rgbValue;

/// 从 UIColor 获取 RGB 值并打印
/// @param color 输入的 UIColor 对象
+ (void)zhh_rgbValueFromUIColor:(UIColor *)color;

/// 生成随机颜色
/// @param alpha 透明度，范围 [0, 1]，默认值为 1
/// @return 随机生成的 UIColor
+ (instancetype)zhh_randomColorWithAlpha:(CGFloat)alpha;

/// 无透明度随机颜色，默认透明度为 1
+ (instancetype)zhh_randomColor;

/// 图片生成颜色
+ (UIColor *)zhh_colorWithImage:(UIImage *)image;

/// 获取颜色的平均值
+ (UIColor *)zhh_colorsAverage:(NSArray<UIColor*> *)colors;

/// 获取图片上指定点的颜色
+ (UIColor *)zhh_colorAtImage:(UIImage *)image point:(CGPoint)point;

/// 获取ImageView上指定点的图片颜色
+ (UIColor *)zhh_colorAtImageView:(UIImageView *)imageView point:(CGPoint)point;

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
                          borderColor:(UIColor *)borderColor;

/// 绘制线性渐变
/// @param context 当前图形上下文
/// @param path 用于绘制的路径
/// @param colors 渐变的颜色数组
/// @param locations 渐变的颜色位置数组，值范围为 [0, 1]
+ (void)zhh_drawLinearGradient:(CGContextRef)context
                          path:(CGPathRef)path
                        colors:(NSArray<UIColor *> *)colors
                     locations:(NSArray<NSNumber *> *)locations;

/**
 * 创建一个从上到下的线性渐变颜色。
 *
 * @param color1 渐变的起始颜色。
 * @param color2 渐变的结束颜色。
 * @param height 渐变区域的高度，表示从顶部到底部的范围。
 *
 * @return 一个带有从上到下渐变效果的 UIColor 对象。
 */
+ (UIColor *)zhh_colorWithGradientColor1:(UIColor *)color1 color2:(UIColor *)color2 height:(CGFloat)height;
/**
 * 创建一个从左到右的线性渐变颜色。
 *
 * @param color1 渐变的起始颜色。
 * @param color2 渐变的结束颜色。
 * @param width 渐变区域的宽度，表示从左侧到右侧的范围。
 *
 * @return 一个带有从左到右渐变效果的 UIColor 对象。
 */
+ (UIColor *)zhh_colorWithGradientColor1:(UIColor *)color1 color2:(UIColor *)color2 width:(CGFloat)width;
/**
 * 创建一个自定义方向和颜色的渐变颜色。
 *
 * @param colors 一个包含渐变颜色的数组，颜色将按顺序渐变。
 * @param locations 一个可选的数组，定义每种颜色的位置，取值范围为 [0, 1]。若为 nil，则均匀分布。
 * @param point 渐变的起点，表示渐变的起始参考点。
 * @param size 渐变的范围大小，用于确定渐变的跨度。
 * @param direction 渐变的方向，使用 ZHHGradietDirectionType 定义（例如：从上到下、从左到右等）。
 *
 * @return 一个带有自定义渐变效果的 UIColor 对象。
 */
+ (UIColor *)zhh_colorWithGradientColors:(NSArray<UIColor *> *)colors
                               locations:(NSArray<NSNumber *> * _Nullable)locations
                                   point:(CGPoint)point
                                    size:(CGFloat)size
                               direction:(ZHHGradietDirectionType)direction;
@end

NS_ASSUME_NONNULL_END
