//
//  NSString+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZHHSpaceTrimOption) {
    ZHHSpaceTrimOptionAll,              // 去除所有空格
    ZHHSpaceTrimOptionHeadTail,         // 去除前后空格
    ZHHSpaceTrimOptionHeadTailAndNewline // 去除前后空格和换行符
};

@interface NSString (ZHHCommon)
/// 处理当前字符串为空时的显示，返回空字符串
/// @return 如果字符串为空或无效值，返回空字符串；否则返回原字符串
- (NSString *)zhh_empty;
/// 判断字符串是否为空
/// @return 如果字符串为空或无效值，返回YES；否则返回NO
- (BOOL)zhh_isEmpty;
/// 转换为URL
- (NSURL *)zhh_url;
/// 获取图片
- (UIImage *)zhh_image;
/// 图片控制器
- (UIImageView *)zhh_imageView;
/// base64 解码
/// 将当前字符串视为 base64 编码的字符串进行解码
/// @return 解码后的字符串，如果解码失败返回 nil
- (NSString * _Nullable)zhh_base64DecodeString;
/// base64 编码
/// 将当前字符串进行 base64 编码
/// @return 编码后的 base64 字符串，如果编码失败返回 nil
- (NSString * _Nullable)zhh_base64EncodeString;

/// 格式化数量为简短的带单位字符串
///
/// 适用于格式化较大的数字，例如点赞数、浏览量、评论数等，
/// 将数字格式化为“万”或“亿”单位显示，保留 1 位小数。
///
/// 规则：
/// - 小于 10,000：直接显示数字，例如 "1234"
/// - 10,000 到 99,999,999：以“万”为单位，保留 1 位小数，例如 "1.2万"
/// - 大于等于 100,000,000：以“亿”为单位，保留 1 位小数，例如 "1.2亿"
///
/// @return 格式化后的数量字符串
+ (NSString *)zhh_formatCount:(NSInteger)count;

/// 格式化金额，去掉多余的小数位
///
/// 该方法会将浮点数格式化为两位小数的金额表示，并去除不必要的零。
/// 例如：
/// - `123.45` -> `123.45`
/// - `123.00` -> `123`
/// - `123.50` -> `123.5`
///
/// @return 格式化后的金额字符串，如果格式化失败则返回 `nil`。
- (NSString *)zhh_formatAmount;

/// 去除字符串中的HTML标签，返回纯文本内容
/// @return 去除HTML标签后的纯文本，如果正则表达式编译失败或输入为nil，返回nil。
- (NSString *)zhh_stripHTML;

/// 移除HTML中的<script>标签及其内容，并去除所有HTML标签，返回纯文本内容
/// @return 去除<script>标签及HTML标签后的纯文本内容。如果正则表达式编译失败或输入为nil，返回nil。
- (NSString *)zhh_removeScriptsAndHTML;

/// 生成垂直文字
- (NSString *)zhh_verticalText;
/// 将日期字符串或时间戳转换为星期几（中文）
/// @return 返回星期几，格式为“星期日”到“星期六”
- (NSString *)zhh_weekdayString;

/// 去掉字符串的最后一个字符
/// @return 去掉最后一个字符后的字符串，如果字符串为空则返回原字符串
- (NSString *)zhh_removeLastString;

/// 递归去除字符串尾部的指定子字符串
/// @param string 要去除的子字符串
/// @return 去除指定子字符串后的字符串
- (NSString *)zhh_removeLastSubString:(NSString *)string;

/// 替换文本字符串
/// @param parameter1 需要替换的字符串
/// @param parameter2 需要替换成的字符串
/// @return 返回替换后的字符串
- (NSString *)zhh_replaceText:(NSString *)parameter1 parameter2:(NSString *)parameter2;

/**
 *  创建一个富文本字符串，其中指定文本的颜色、字体和范围。
 *
 *  @param colors  颜色数组，每个元素对应一个范围，指定该范围内文本的颜色。
 *  @param fonts   字体数组，每个元素对应一个范围，指定该范围内文本的字体。
 *  @param ranges  范围数组，指定哪些部分的文本应用指定的颜色和字体。
 *
 *  @return 返回一个富文本字符串，包含指定的颜色和字体。
 *
 *  使用示例：
 *    NSString *text = @"Hello, World! Welcome to the world!";  // 示例字符串
 *    // 定义文本中需要应用不同格式的范围
 *    NSRange range1 = [text rangeOfString:@"Hello"];
 *    NSRange range2 = [text rangeOfString:@"Welcome"];
 *
 *    // 定义颜色数组和字体数组
 *    NSArray *colors = @[[UIColor redColor], [UIColor blueColor]];
 *    NSArray *fonts = @[[UIFont boldSystemFontOfSize:18], [UIFont italicSystemFontOfSize:16]];
 *
 *    // 创建范围数组
 *    NSArray *ranges = @[[NSValue valueWithRange:range1], [NSValue valueWithRange:range2]];
 *    // 调用方法生成富文本
 *    NSAttributedString *attributedString = [text zhh_attributedStringWithColors:colors fonts:fonts ranges:ranges];
 *    // 使用返回的富文本（例如赋值给UILabel显示）
 *    label.attributedText = attributedString;
 */
- (NSAttributedString *)zhh_attributedStringWithColors:(NSArray<UIColor *> *)colors fonts:(NSArray<UIFont *> *)fonts ranges:(NSArray<NSValue *> *)ranges;

/// 设置带有行间距的富文本，适用于展示“查看更多”文本
/// @param width 宽度
/// @param font 字体
/// @param lineSpacing 行间距
/// @return 返回设置了富文本的字符串
- (NSMutableAttributedString *)zhh_showMoreTextWithWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
/// 根据文字内容动态计算UILabel宽高
/// @param maxWidth label宽度
/// @param font  字体
/// @param lineSpacing  行间距
/// @return 返回计算后的CGSize
- (CGSize)zhh_boundingRectWithWidth:(CGFloat)maxWidth font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/// 将NSString转换为NSMutableAttributedString，并设置行间距和字体
/// @param font  字体
/// @param lineSpacing  行间距
/// @return 返回设置了字体和行间距的NSMutableAttributedString
- (NSMutableAttributedString *)zhh_attributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

/// 解析HTML文本并转换为富文本字符串
/// @param maxWidth 最大宽度，用于设置图片的宽度
/// @return 返回解析后的富文本字符串
- (NSAttributedString *)zhh_attributedStringHTMLWithMaxWidth:(CGFloat)maxWidth;

/// 将文字和图标添加到富文本中
/// @param images 需要插入的图标数组
/// @param font 文字的字体
/// @param span 图标之间的间距
/// @return 返回包含文字和图标的富文本
- (NSAttributedString *)zhh_attributedStringWithImages:(NSArray<UIImage *> *)images font:(UIFont *)font span:(CGFloat)span;

/// 将数字字符串按指定的分隔符和间隔位数格式化
/// @param separator 分隔符字符串（例如：","、"."、" "）
/// @param interval 每隔多少位插入一个分隔符（例如：3、4）
/// @return 格式化后的字符串
- (NSString *)zhh_formattedWithSeparator:(NSString *)separator interval:(NSUInteger)interval;

/// 将字符串从指定位置起的字符替换为星号
/// @param startIndex 替换的起始索引
/// @param length 替换的字符个数
/// @return 返回替换后的字符串，如果索引无效或范围超出，则返回原字符串
- (NSString *)zhh_replaceWithAsterisksAtIndex:(NSInteger)startIndex length:(NSInteger)length;

/// 根据选项移除字符串中的空格
/// @param option 移除空格的选项（所有空格或首尾空格）
/// @return 返回处理后的字符串
- (NSString *)zhh_removeSpacesWithOption:(ZHHSpaceTrimOption)option;

/// 过滤指定的字符集合
/// @param characters 要移除的字符集合，如果为 nil 则使用默认特殊字符集合
/// @return 返回移除指定字符后的字符串
- (NSString *)zhh_stringByRemovingCharactersInSet:(NSString *_Nullable)characters;

/// 判断当前字符串是否符合 JSON 格式的基本结构（即是否以 { 或 [ 开头并以 } 或 ] 结尾）
/// @return YES 表示可能是 JSON 格式，NO 表示不符合 JSON 格式。
- (BOOL)zhh_isValidJSONFormat;

/// 将 JSON 字符串转换为 NSDictionary 或 NSArray
/// 该方法会先判断字符串是否为空或是否是有效的 JSON 字符串，
/// 然后使用 `NSJSONSerialization` 将字符串解析为 `NSDictionary` 或 `NSArray`，
/// 根据 JSON 字符串的格式自动选择适当的类型。
/// @return 如果解析成功，返回解析后的 `NSDictionary` 或 `NSArray`，否则返回 nil。
- (id)zhh_json;

/// @brief 将字典或数组转为 JSON 字符串
/// @param object 要转换为 JSON 字符串的字典或数组
/// @return 返回转换后的 JSON 字符串，如果失败返回 nil
+ (NSString *)zhh_jsonStringFromObject:(id)object;
/// 判断字符串是否包含指定字符集中的字符
- (BOOL)zhh_containsCharacterSet:(NSCharacterSet *)set;
/// 判断当前字符串是否包含指定的子字符串
- (BOOL)zhh_containsString:(NSString *)string;
/// 判断字符串中是否包含表情符号
/// @return 如果包含表情符号返回 `YES`，否则返回 `NO`
- (BOOL)zhh_containsEmoji;
/// 判断字符串是否是表情符号
/// @return YES 表示字符串是一个表情符号，NO 表示不是
- (BOOL)zhh_isEmoji;
/**
 * 从字符串中移除所有 Emoji 表情符号
 * @return 返回一个新的字符串，其中已移除了所有 Emoji 表情
 * 示例:
 * 输入: @"Hello 😊 World 🌍"
 * 输出: @"Hello  World "
 */
- (NSString *)zhh_stringByRemovingEmoji;
/// 判断字符串是否包含中文字符
- (BOOL)zhh_isContainChinese;
/// 判断字符串是否包含空格
- (BOOL)zhh_isContainBlank;
/// 将Unicode编码的字符串转换为NSString
- (NSString *)zhh_makeUnicodeToString;
/// 获取字符数量（按实际字符类型统计）
- (int)zhh_wordsCount;
/**
 *  @brief 将当前字符串进行 URL 编码
 *
 *  @discussion
 *  对字符串中中文及特殊字符进行百分号编码，编码后的字符串可以安全地嵌入 URL 请求中。
 *
 *  NSString *originalString = @"https://example.com/query?name=张三&emoji=👨‍💻";
    NSString *encodedString = [originalString zhh_encodedURLString];
    NSLog(@"Encoded String: %@", encodedString);
    // 输出：Encoded String: https%3A%2F%2Fexample.com%2Fquery%3Fname%3D%E5%BC%A0%E4%B8%89&emoji=%F0%9F%91%A8%E2%80%8D%F0%9F%92%BB
 *  @return 编码后的字符串；如果当前字符串为空或长度为 0，返回 nil
 */
- (NSString *)zhh_encodedURLString;
/**
 *  @brief 将当前字符串进行 URL 解码
 *
 *  @discussion
 *  使用百分号编码的 URL 字符串进行解码，将特殊字符还原到原始字符串形式。
 *  如果当前字符串为空或解码失败，则返回 nil。
 *
 *  NSString *encodedString = @"%E5%BC%A0%E4%B8%89+%E5%A5%BD%E5%8F%8B";
    NSString *decodedString = [encodedString zhh_decodedURLString];
    NSLog(@"Decoded String: %@", decodedString);
    // 输出：Decoded String: 张三 好友
 *  @return 解码后的字符串
 */
- (NSString *)zhh_decodedURLString;
/**
 *  @brief 将 URL 参数字符串解析为字典
 *
 *  @discussion
 *  解析当前字符串中以 `?` 后的 URL 参数部分，按键值对形式生成字典。
 *  支持百分号编码字符自动解码。
 *
 *  @return 包含所有参数的字典；如果没有参数或解析失败，返回空字典。
 */
- (NSDictionary *)zhh_parameters;
/**
 *  @brief 根据参数名获取 URL 参数值
 *
 *  @discussion
 *  在 URL 参数字符串中查找与指定参数名对应的值。支持百分号编码字符解码。
 *
 *  @param parameterKey 参数名
 *
 *  @return 对应的参数值；如果参数名不存在或无效，返回 nil。
 */
- (NSString *)zhh_valueForParameter:(NSString *)parameterKey;
@end

NS_ASSUME_NONNULL_END
