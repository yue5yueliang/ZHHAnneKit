//
//  NSString+ZHHSize.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHSize)
/// 文字高宽度计算
- (CGSize)zhh_sizeOfTextWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;
+ (CGSize)zhh_sizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font;
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)zhh_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)zhh_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)zhh_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)zhh_sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)zhh_reverseString:(NSString *)strSrc;
/**
 计算单行文本行高、支持包含emoji表情符的计算、开头空格.(图片不纳入计算范围)

 @param font 字体
 @return size大小
 */
- (CGSize)zhh_calculateSingleLineSizeWithAttributeText:(UIFont *)font;
/**
 计算NSString有多少行

 @param font 字体
 @param width 宽度 
 @return 返回数组
 */
- (NSArray *)zhh_linesWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算.
 包含emoji表情符的文本行高返回值有较大偏差

 @param font 字体对象
 @return size
 */
- (CGSize)zhh_calculateSingleLineSizeFromFont:(UIFont *)font;
/// 获取文本宽度
/// @param font font
/// @param height fixed height
/// @param alignment alignment
/// @param linebreakMode line type
/// @param lineSpace line spacing
- (CGFloat)zhh_maxWidthWithFont:(UIFont *)font
                         height:(CGFloat)height
                      alignment:(NSTextAlignment)alignment
                  linebreakMode:(NSLineBreakMode)linebreakMode
                      lineSpace:(CGFloat)lineSpace;

/// 获取文本高度
/// @param font font
/// @param width fixed width
/// @param alignment alignment
/// @param linebreakMode line type
/// @param lineSpace line spacing
- (CGFloat)zhh_maxHeightWithFont:(UIFont *)font
                           width:(CGFloat)width
                       alignment:(NSTextAlignment)alignment
                   linebreakMode:(NSLineBreakMode)linebreakMode
                       lineSpace:(CGFloat)lineSpace;

/// 计算字符串高度尺寸，spacing为行间距
/// @param font font
/// @param size size
/// @param spacing Line spacing
- (CGSize)zhh_textSizeWithFont:(UIFont *)font size:(CGSize)size spacing:(CGFloat)spacing;
/// 文字转图片
/// @param size size
/// @param color color
/// @param attributes parameters
- (UIImage *)zhh_textBecomeImageWithSize:(CGSize)size backgroundColor:(UIColor *)color textAttributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END
