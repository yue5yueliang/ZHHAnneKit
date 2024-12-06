//
//  UILabel+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZHHUtilities)
/**
 UILabel 的文本内边距。
 可通过设置该属性为 UILabel 的文本增加 padding 效果。

 @note 默认值为 UIEdgeInsetsZero。
 */
@property (nonatomic, assign) UIEdgeInsets zhh_edgeInsets;

/**
 * 快速创建一个 UILabel，默认左对齐。
 *
 * @param color 文字颜色
 * @param font 字体
 * @return 返回一个设置好颜色和字体的 UILabel 实例
 */
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font;

/**
 * 快速创建一个 UILabel，并自定义颜色、字体和对齐方式。
 *
 * @param color 文字颜色
 * @param font 字体
 * @param alignment 文本对齐方式（NSTextAlignmentLeft、NSTextAlignmentCenter、NSTextAlignmentRight 等）
 * @return 返回一个自定义设置的 UILabel 实例
 */
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;

/// 获取当前 UILabel 文本的宽高
- (CGSize)zhh_labelSize;

#pragma mark - 文本样式调整

/// 设置 UILabel 的行间距。
/// @param lineSpacing 行间距大小
- (void)zhh_adjustLineSpacing:(CGFloat)lineSpacing;

/// 设置 UILabel 的行间距和段间距。
/// @param lineSpacing 行间距大小
/// @param paragraphSpacing 段间距大小
- (void)zhh_adjustLineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing;

/// 设置 UILabel 的字间距（字符间距）。
/// @param wordSpacing 字间距大小（以点为单位，正值增大间距，负值减小间距）。
- (void)zhh_adjustSpacingWithLine:(CGFloat)wordSpacing;

/// 设置 UILabel 的行间距和字间距。
/// @param lineSpacing 行间距大小（段落中每行之间的距离）。
/// @param wordSpacing 字间距大小（字符之间的距离）。
- (void)zhh_adjustSpacingWithLine:(CGFloat)lineSpacing wordSpacing:(CGFloat)wordSpacing;

/// 配置 UILabel 文本的行间距、首行缩进、字体和颜色。
/// @param lineSpacing 行间距大小
/// @param firstLineIndent 首行缩进字符数
/// @param font 字体对象
/// @param color 字体颜色
- (void)zhh_configureTextWithLineSpacing:(CGFloat)lineSpacing
                         firstLineIndent:(CGFloat)firstLineIndent
                                    font:(UIFont *)font
                                   color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
