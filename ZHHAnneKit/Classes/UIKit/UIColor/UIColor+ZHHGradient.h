//
//  UIColor+ZHHGradient.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,ZHHGradietColorType) {
    ZHHGradietColorTypeTopToBottom = 0,
    ZHHGradietColorTypeLeftToRight = 1,
    ZHHGradietColorTypeUpLeftToLowRight,
    ZHHGradietColorTypeUpRightToLowLeft,
};

@interface UIColor (ZHHGradient)
/// 渐变颜色
/// @param colors 渐变颜色数组
/// @param type 渐变类型
/// @param size 渐变颜色大小
+ (UIColor *)zhh_gradientColorWithColors:(NSArray *)colors gradientType:(ZHHGradietColorType)type size:(CGSize)size;

/// 获取颜色的平均值
+ (UIColor *)zhh_averageColors:(NSArray<UIColor*> *)colors;

/// 获取图片上指定点的颜色
+ (UIColor *)zhh_colorAtImage:(UIImage *)image point:(CGPoint)point;

/// 获取ImageView上指定点的图片颜色
+ (UIColor *)zhh_colorAtImageView:(UIImageView *)imageView point:(CGPoint)point;

/// 可变参数渐变颜色
/// @param size Gradient color size box
/// @param color Indefinite number of gradient colors, need to end with nil
- (UIColor *)zhh_gradientSize:(CGSize)size color:(UIColor *)color,... NS_REFINED_FOR_SWIFT;

/// 垂直渐变颜色
/// @param color end color
/// @param height gradient height
/// @return returns the vertical gradient color
- (UIColor *)zhh_gradientVerticalToColor:(UIColor *)color height:(CGFloat)height;

/// 水平渐变颜色
/// @param color end color
/// @param width gradient color width
/// @return returns the horizontal gradient color
- (UIColor *)zhh_gradientAcrossToColor:(UIColor *)color width:(CGFloat)width;

/// 生成带边框的渐变色图片
/// @param colors gradient color array
/// @param locations The proportion of each group of gradient colors
/// @param size size
/// @param borderWidth border width
/// @param borderColor border color
+ (UIImage *)zhh_colorImageWithColors:(NSArray<UIColor *> *)colors
                            locations:(NSArray<NSNumber *> *)locations
                                 size:(CGSize)size
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
