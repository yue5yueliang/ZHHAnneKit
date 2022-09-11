//
//  UILabel+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZHHKit)
/**
 * 创建 UILabel
 *
 *  @param color    标题颜色
 *  @param font     字体
 *
 *  @return UILabel(文本水平居中)
 */
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font;

/**
 *  创建 UILabel
 *
 *  @param color     标题颜色
 *  @param font      字体
 *  @param alignment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;
/// 获取宽度
- (CGFloat)zhh_calculateWidth;
/// 获取高度
- (CGFloat)zhh_calculateHeightWithWidth:(CGFloat)width;

/// 获取高度，指定行高度
/// @param width fixed width
/// @param height The height of a line of text
/// @return returns the total height
- (CGFloat)zhh_calculateHeightWithWidth:(CGFloat)width oneLineHeight:(CGFloat)height;

/// 获取文本大小
/// @param title text
/// @param font font
/// @param size width and height size
/// @param lineBreakMode line type
/// @return returns the text size
+ (CGSize)zhh_calculateLabelSizeWithTitle:(NSString *)title
                                    font:(UIFont *)font
                       constrainedToSize:(CGSize)size
                           lineBreakMode:(NSLineBreakMode)lineBreakMode;
/// 更改行距
- (void)zhh_changeLineSpace:(float)space;
/// 更改单词间距
- (void)zhh_changeWordSpace:(float)space;
/// 更改行距和段落间距
- (void)zhh_changeLineSpace:(float)space paragraphSpace:(float)paragraphSpace;
/// 更改行距和字间距
- (void)zhh_changeLineSpace:(float)lineSpace wordSpace:(float)wordSpace;
/**
 *  在指定的索引范围内设置一个自定义的字体font
 *
 *  @param font      被设置的新字体格式
 *  @param fromIndex 开始索引
 *  @param toIndex   结束索引
 */
- (void)zhh_setTextFont:(UIFont *)font fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
/**
 *  UILabel修改行距,首行缩进(优化版)
 *
 *  @param lineSpace 行间距
 *  @param firstLineHeadIndent 首行缩进字符个数
 *  @param fontSize 大小
 *  @param color 字体颜色
 */
- (void)zhh_labelTextAttributesWithLineSpace:(CGFloat)lineSpace firstLineHeadIndent:(CGFloat)firstLineHeadIndent fontSize:(CGFloat)fontSize color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
