//
//  NSString+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHUtilities)
/// @brief  将中文字符串转换为拼音（去除空格和音标）
/// @return 转换后的拼音字符串（如“你好”返回“nihao”）
- (NSString *)zhh_pinyin;
/// 简化加载多语言文本
- (NSString *)zhh_localized;

/// @brief  获取字符串的拼音首字母
/// @return 拼音首字母字符串（如“张三”返回“ZS”）
- (NSString *)zhh_pinyinInitial;

/// @brief  将中文字符串转换为拼音（保留空格，去除音标）
/// @return 转换后的拼音字符串（如“你好”返回“ni hao”）
- (NSString *)zhh_chineseToPinYin;

/// @brief  获取中文字符串拼音首字母的大写形式
/// @return 拼音首字母的大写字符串（如“你好”返回“N”）
- (NSString *)zhh_firstUppercasePinYin;

/// @brief 计算文本尺寸 (默认断行模式为 NSLineBreakByWordWrapping)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/// @brief 计算文本尺寸 (指定断行模式)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param lineBreakMode 断行模式
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineBreakMode:(NSLineBreakMode)lineBreakMode;

/// @brief 计算文本尺寸 (指定行间距，断行模式默认为 NSLineBreakByWordWrapping)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param lineSpacing 行间距
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineSpacing:(CGFloat)lineSpacing;

/// @brief 计算文本尺寸 (指定断行模式和行间距)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param lineBreakMode 断行模式
/// @param lineSpacing 行间距
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing;

/// @brief 计算文本尺寸 (指定对齐方式、断行模式和行间距)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param alignment 对齐方式
/// @param lineBreakMode 断行模式
/// @param lineSpacing 行间距
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth alignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing;

/// @brief  返回字符串的反转版本
/// @return 反转后的字符串
- (NSString *)zhh_reversedString;

/// @brief  计算单行文本的尺寸（支持包含 emoji 表情的计算，支持首尾空格；不计算图片的尺寸）
/// @param font 字体对象，用于计算文本尺寸
/// @return 文本单行显示所需的 CGSize
- (CGSize)zhh_singleLineSizeWithFont:(UIFont *)font;

/// @brief  计算 NSString 在指定宽度和字体下的分行内容
/// @param font  字体对象，用于计算文本行数
/// @param maxWidth 约束宽度
/// @return 包含每行内容的数组
- (NSArray<NSString *> *)zhh_linesWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/// @brief  将文字转换为图片
/// @param size            图片的尺寸
/// @param backgroundColor 图片背景颜色
/// @param attributes      文字属性（如字体、颜色等，使用 `NSAttributedString` 的属性键）
/// @return 生成的 UIImage 对象
- (UIImage *)zhh_imageFromTextWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor textAttributes:(NSDictionary *)attributes;

/// 安全截取字符串（前提：确保截取范围合法）
/// @param range 范围（起始位置和长度）
/// @return 截取后的字符串，若范围不合法返回空字符串
- (NSString *)zhh_safeSubstringWithRange:(NSRange)range;

/// 安全地截取从起始位置到指定位置的字符串
/// @param index 截取的结束位置
/// @return 截取后的字符串，若位置不合法返回空字符串
- (NSString *)zhh_safeSubstringToIndex:(NSUInteger)index;

/// 安全地截取从指定位置到字符串结尾的部分
/// @param from 截取的起始位置
/// @return 截取后的字符串，若位置不合法返回空字符串
- (NSString *)zhh_safeSubstringFromIndex:(NSInteger)from;

/// 删除第一个字符
/// @return 删除第一个字符后的字符串
- (NSString *)zhh_removeFirstCharacter;

/// 删除最后一个字符
/// @return 删除最后一个字符后的字符串
- (NSString *)zhh_removeLastCharacter;

/// @brief  根据文件 URL 的后缀返回对应的 mimeType
/// @return mimeType，若找不到对应类型，则默认为 application/octet-stream
- (NSString *)zhh_mimeType;
/// @brief  根据文件后缀名返回对应的 mimeType
/// @param  extension 文件后缀名
/// @return mimeType 字符串，默认为 application/octet-stream
- (NSString *)zhh_mimeTypeForExtension:(NSString *)extension;

/// @brief  常见 MIME 类型集合
/// @return 包含常见 MIME 类型的字典，键为文件后缀名，值为对应 MIME 类型
- (NSDictionary *)zhh_mimeDict;
@end

NS_ASSUME_NONNULL_END
