//
//  NSString+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHCommon.h"

@implementation NSString (ZHHCommon)
/// 处理当前字符串为空时的显示，返回空字符串
/// @return 如果字符串为空或无效值，返回空字符串；否则返回原字符串
- (NSString *)zhh_empty {
    return self.zhh_isEmpty ? @"" : self;
}

/// 判断字符串是否为空
/// @return 如果字符串为空或无效值，返回YES；否则返回NO
- (BOOL)zhh_isEmpty {
    if (self == nil || self == NULL || [self length] == 0 ||
        [self isKindOfClass:[NSNull class]] ||
        [self isEqualToString:@"(null)"] ||
        [self isEqualToString:@"null"] ||
        [self isEqualToString:@"<null>"] ||
        [self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

/// 转换为URL
- (NSURL *)zhh_url { return [NSURL URLWithString:self];}
/// 获取图片
- (UIImage *)zhh_image { return [UIImage imageNamed:self];}
/// 图片控制器
- (UIImageView *)zhh_imageView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:self]];
}

/// base64 解码
/// 将当前字符串视为 base64 编码的字符串进行解码
/// @return 解码后的字符串，如果解码失败返回 nil
- (NSString * _Nullable)zhh_base64DecodeString {
    if (self.zhh_isEmpty) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

/// base64 编码
/// 将当前字符串进行 base64 编码
/// @return 编码后的 base64 字符串，如果编码失败返回 nil
- (NSString * _Nullable)zhh_base64EncodeString {
    if (self.zhh_isEmpty) {
        return nil;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [data base64EncodedStringWithOptions:0];
    }
    return nil;
}

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
+ (NSString *)zhh_formatCount:(NSInteger)count {
    if (count >= 100000000) { // 大于或等于 1 亿
        double value = (double)count / 100000000.0;
        return [NSString stringWithFormat:@"%.1f亿", value];
    } else if (count >= 10000) { // 大于或等于 1 万
        double value = (double)count / 10000.0;
        return [NSString stringWithFormat:@"%.1f万", value];
    } else { // 小于 1 万
        return [NSString stringWithFormat:@"%ld", (long)count];
    }
}

/// 格式化金额，去掉多余的小数位
///
/// 该方法会将浮点数格式化为两位小数的金额表示，并去除不必要的零。
/// 例如：
/// - `123.45` -> `123.45`
/// - `123.00` -> `123`
/// - `123.50` -> `123.5`
///
/// @return 格式化后的金额字符串，如果格式化失败则返回 `nil`。
- (NSString *)zhh_formatAmount {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式为保留两位小数
    [numberFormatter setPositiveFormat:@"0.00"];
    NSString *numberStr = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.floatValue]];
    
    if (numberStr.length > 1) {
        // 判断是否有小数点部分
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            
            // 如果小数部分是 "00"，则去掉小数部分
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            } else {
                // 如果小数部分末尾是零，则去掉末尾的零
                if ([[last substringFromIndex:last.length - 1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    } else {
        return nil;  // 如果格式化失败，返回 nil
    }
}

/// 去除字符串中的HTML标签，返回纯文本内容
/// @return 去除HTML标签后的纯文本，如果正则表达式编译失败或输入为nil，返回nil。
- (NSString *)zhh_stripHTML {
    if (self == nil) return nil;
    
    NSError *error = nil;
    // 使用正则表达式去除HTML标签
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:0 error:&error];
    
    // 如果正则表达式有误，返回nil
    if (error) {
        return nil;
    }
    
    // 替换所有HTML标签
    NSString *cleanText = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return cleanText;
}

/// 移除HTML中的<script>标签及其内容，并去除所有HTML标签，返回纯文本内容
/// @return 去除<script>标签及HTML标签后的纯文本内容。如果正则表达式编译失败或输入为nil，返回nil。
- (NSString *)zhh_removeScriptsAndHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    
    // 正则表达式匹配<script>标签及其中的内容
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    
    // 获取所有匹配的<script>标签
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    
    // 从匹配结果中逐个删除<script>标签及其内容
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    
    // 调用zhh_stripHTML方法去除剩余的HTML标签，并返回纯文本
    return [mString zhh_stripHTML];
}

/// 生成垂直文字
- (NSString *)zhh_verticalText {
    // 如果字符串为空，直接返回原字符串
    if (self.length == 0) {
        return self;
    }
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:self];
    NSInteger count = text.length;
    
    // 计算插入换行符的次数
    NSInteger insertCount = count - 1;
    
    // 从后往前插入换行符，避免插入后影响后续位置
    for (NSInteger i = 0; i < insertCount; i++) {
        [text insertString:@"\n" atIndex:(count - i - 1 + i)];
    }
    
    return text.copy;
}

/// 将日期字符串或时间戳转换为星期几（中文）
/// @return 返回星期几，格式为“星期日”到“星期六”
- (NSString *)zhh_weekdayString {
    // 定义星期几的中文数组
    NSArray *weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    
    // 判断当前字符串是日期字符串还是时间戳
    NSDate *inputDate = nil;
    if ([self containsString:@"-"]) {  // 日期字符串（yyyy-MM-dd）
        // 实例化NSDateFormatter对象，用来处理日期格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        inputDate = [dateFormatter dateFromString:self];
    } else {  // 时间戳（秒级时间戳）
        NSTimeInterval time = [self doubleValue];
        inputDate = [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    // 如果无法转换为日期，返回空字符串
    if (!inputDate) {
        return @"";
    }
    
    // 使用当前日历和时区获取该日期对应的星期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    
    // 获取星期几（1-7表示周日到周六）
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    return weekdays[components.weekday - 1];  // 返回对应的星期几
}

/// 去掉字符串的最后一个字符
/// @return 去掉最后一个字符后的字符串，如果字符串为空则返回原字符串
- (NSString *)zhh_removeLastString {
    if (self.length > 0) {
        return [self substringToIndex:self.length - 1]; // 去掉最后一个字符
    } else {
        return self; // 如果字符串为空，返回原字符串
    }
}

/// 递归去除字符串尾部的指定子字符串
/// @param string 要去除的子字符串
/// @return 去除指定子字符串后的字符串
- (NSString *)zhh_removeLastSubString:(NSString *)string {
    NSString *result = self;
    while ([result hasSuffix:string]) {
        // 去掉尾部的子字符串
        result = [result substringToIndex:result.length - string.length];
    }
    return result;
}

/// 替换文本字符串
/// @param parameter1 需要替换的字符串
/// @param parameter2 需要替换成的字符串
/// @return 返回替换后的字符串
- (NSString *)zhh_replaceText:(NSString *)parameter1 parameter2:(NSString *)parameter2 {
    // 使用stringByReplacingOccurrencesOfString进行替换操作
    return [self stringByReplacingOccurrencesOfString:parameter1 withString:parameter2];
}

/**
 *  创建一个富文本字符串，其中指定文本的颜色、字体和范围。
 *
 *  @param colors  颜色数组，每个元素对应一个范围，指定该范围内文本的颜色。
 *  @param fonts   字体数组，每个元素对应一个范围，指定该范围内文本的字体。
 *  @param ranges  范围数组，指定哪些部分的文本应用指定的颜色和字体。
 *
 *  @return 返回一个富文本字符串，包含指定的颜色和字体。
 */
- (NSAttributedString *)zhh_attributedStringWithColors:(NSArray<UIColor *> *)colors fonts:(NSArray<UIFont *> *)fonts ranges:(NSArray<NSValue *> *)ranges {
    // 创建一个可变富文本，用于设置样式
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];

    // 遍历所有需要设置样式的范围
    for (NSInteger i = 0; i < ranges.count; i++) {
        NSRange range = [ranges[i] rangeValue];
        
        // 越界保护，防止 range 超出字符串长度
        if (NSMaxRange(range) > self.length) continue;

        // 获取对应的颜色：支持传一个复用
        UIColor *color = nil;
        if (colors.count == 1) {
            color = colors.firstObject;
        } else if (i < colors.count) {
            color = colors[i];
        }
        if (color) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }

        // 获取对应的字体：支持传一个复用
        UIFont *font = nil;
        if (fonts.count == 1) {
            font = fonts.firstObject;
        } else if (i < fonts.count) {
            font = fonts[i];
        }
        if (font) {
            [attributedString addAttribute:NSFontAttributeName value:font range:range];
        }
    }

    // 返回处理后的富文本
    return attributedString;
}

/// 设置带有行间距的富文本，适用于展示“查看更多”文本
/// @param width 宽度
/// @param font 字体
/// @param lineSpacing 行间距
/// @return 返回设置了富文本的字符串
- (NSMutableAttributedString *)zhh_showMoreTextWithWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    // 获取文字内容的高度
    CGFloat textHeight = [self zhh_boundingRectWithWidth:width font:font lineSpacing:lineSpacing].height;
    // 如果文字高度超过三行，限制为三行的高度
    if (textHeight > font.lineHeight * 3 + 2 * lineSpacing) {
        textHeight = font.lineHeight * 3 + 2 * lineSpacing;
    }
    // 返回已经设置好的富文本
    return [self zhh_attributedStringWithFont:font lineSpacing:lineSpacing];
}

// 计算UILabel的宽高
- (CGSize)zhh_boundingRectWithWidth:(CGFloat)maxWidth font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    // 创建段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    
    // 计算文字尺寸
    CGSize size = [self boundingRectWithSize:maxSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}
                                      context:nil].size;
    return size;
}

// 将NSString转换为NSMutableAttributedString，并设置行间距和字体
- (NSMutableAttributedString *)zhh_attributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    // 创建段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    // 设置截断方式
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    // 将段落样式应用到富文本
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    return attributedStr;
}

/// 解析HTML文本并转换为富文本字符串
- (NSAttributedString *)zhh_attributedStringHTMLWithMaxWidth:(CGFloat)maxWidth {
    // 构建一个HTML格式的字符串，设置字体、图片宽度以及页面样式
    NSString *htmlString = [NSString stringWithFormat:
                            @"<html>"
                            @"<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0;\" name=\"viewport\" />"
                            @"<head><style>img{width:%f !important;height:auto}</style></head>"
                            @"<body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:15px;color:#515151;\">%@</body>"
                            @"</html>", maxWidth, self];  // 使用 self 获取当前字符串
    
    // 将HTML文本转换为富文本(NSAttributedString)
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    };
    
    NSError *error = nil;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlData options:options documentAttributes:nil error:&error];
    
    // 如果解析失败，返回空字符串
    if (error) {
        NSLog(@"ZHHAnneKit 警告: HTML解析失败: %@", error.localizedDescription);
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    return attrStr;
}

/// 将文字和图标添加到富文本中
/// @param images 需要插入的图标数组
/// @param font 文字的字体
/// @param span 图标之间的间距
/// @return 返回包含文字和图标的富文本
- (NSAttributedString *)zhh_attributedStringWithImages:(NSArray<UIImage *> *)images font:(UIFont *)font span:(CGFloat)span {
    // 创建一个可变富文本对象
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    // 遍历图标数组，添加图标到富文本
    for (UIImage *img in images) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = img;
        
        // 计算图片的大小，使其与文字高度一致，宽度按比例缩放
        CGFloat imgHeight = font.pointSize;
        CGFloat imgWidth = img.size.width * (imgHeight / img.size.height);
        
        // 计算文字行高的padding，使图片垂直居中
        CGFloat textPaddingTop = (font.lineHeight - font.pointSize) / 2;
        
        // 设置图片的显示范围
        attach.bounds = CGRectMake(0, -textPaddingTop, imgWidth, imgHeight);
        
        // 将图片添加到富文本中
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
        [mutableAttr appendAttributedString:imageAttr];
        
        // 图片后添加空格
        [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    // 添加文本内容
    [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:self]];
    
    // 如果需要设置间距，则添加字符间距（图标和文字之间）
    if (span > 0) {
        NSInteger spaceCount = images.count * 2;  // 包括图片后面的空格
        [mutableAttr addAttribute:NSKernAttributeName value:@(span) range:NSMakeRange(0, spaceCount)];
    }
    
    return [mutableAttr copy];
}

/// 将数字字符串按指定的分隔符和间隔位数格式化
/// @param separator 分隔符字符串（例如：","、"."、" "）
/// @param interval 每隔多少位插入一个分隔符（例如：3、4）
/// @return 格式化后的字符串
- (NSString *)zhh_formattedWithSeparator:(NSString *)separator interval:(NSUInteger)interval {
    // 校验输入参数
    if (!separator || interval == 0 || self.length == 0) {
        return self; // 无需处理的情况下直接返回原始字符串
    }
    
    // 判断是否为负数，去掉符号方便处理
    BOOL isNegative = [self hasPrefix:@"-"];
    NSString *numberStr = isNegative ? [self substringFromIndex:1] : self;

    // 构建结果字符串
    NSMutableString *result = [NSMutableString string];
    NSInteger length = numberStr.length;

    for (NSInteger i = 0; i < length; i++) {
        // 每隔指定的位数插入分隔符
        if (i > 0 && (length - i) % interval == 0) {
            [result appendString:separator];
        }
        [result appendString:[numberStr substringWithRange:NSMakeRange(i, 1)]];
    }

    // 如果是负数，添加符号
    if (isNegative) {
        [result insertString:@"-" atIndex:0];
    }

    return result;
}

/// 将字符串从指定位置起的字符替换为星号
/// @param startIndex 替换的起始索引
/// @param length 替换的字符个数
/// @return 返回替换后的字符串，如果索引无效或范围超出，则返回原字符串
- (NSString *)zhh_replaceWithAsterisksAtIndex:(NSInteger)startIndex length:(NSInteger)length {
    // 参数校验，确保起始索引和长度合法
    if (startIndex < 0 || length <= 0 || startIndex >= self.length) {
        NSLog(@"输入参数无效，返回原字符串");
        return self;
    }

    // 确定最大替换长度，防止越界
    NSInteger maxLength = MIN(length, self.length - startIndex);

    // 创建可变字符串以进行替换操作
    NSMutableString *result = [self mutableCopy];
    for (NSInteger i = 0; i < maxLength; i++) {
        // 替换指定位置的字符为星号
        [result replaceCharactersInRange:NSMakeRange(startIndex + i, 1) withString:@"*"];
    }

    // 返回替换后的字符串
    return [result copy];
}

/// 根据选项移除字符串中的空格
/// @param option 移除空格的选项（所有空格或首尾空格）
/// @return 返回处理后的字符串
- (NSString *)zhh_removeSpacesWithOption:(ZHHSpaceTrimOption)option {
    switch (option) {
        case ZHHSpaceTrimOptionAll:
            return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        case ZHHSpaceTrimOptionHeadTail:
            return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        case ZHHSpaceTrimOptionHeadTailAndNewline:
            return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        default:
            return self; // 如果选项不匹配，返回原字符串
    }
}

/// 过滤指定的字符集合
/// @param characters 要移除的字符集合，如果为 nil 则使用默认特殊字符集合
/// @return 返回移除指定字符后的字符串
- (NSString *)zhh_stringByRemovingCharactersInSet:(NSString *_Nullable)characters {
    if (characters == nil) {
        characters = @"‘；：”“'。，、,.？、 ~￥#……&<>《》()[]{}【】^!@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€";
    }
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];
    NSArray<NSString *> *filteredComponents = [self componentsSeparatedByCharactersInSet:characterSet];
    return [filteredComponents componentsJoinedByString:@""];
}

#pragma mark - Json相关
/// 判断当前字符串是否符合 JSON 格式的基本结构（即是否以 { 或 [ 开头并以 } 或 ] 结尾）
/// @return YES 表示可能是 JSON 格式，NO 表示不符合 JSON 格式。
- (BOOL)zhh_isValidJSONFormat {
    if (self.length < 2) return NO;

    unichar firstChar = [self characterAtIndex:0];
    if (!(firstChar == '{' || firstChar == '[')) return NO;

    unichar lastChar = [self characterAtIndex:self.length - 1];
    if (!((firstChar == '{' && lastChar == '}') || (firstChar == '[' && lastChar == ']'))) return NO;

    return YES;
}

/**
 * @brief 将 JSON 字符串转换为 NSDictionary 或 NSArray
 *
 * @discussion
 * 该方法会先判断字符串是否为空或是否是有效的 JSON 字符串，
 * 然后使用 `NSJSONSerialization` 将字符串解析为 `NSDictionary` 或 `NSArray`，
 * 根据 JSON 字符串的格式自动选择适当的类型。
 *
 * @return 如果解析成功，返回解析后的 `NSDictionary` 或 `NSArray`，否则返回 nil。
 */
- (id)zhh_json {
    // 检查当前字符串是否为空或者是否是有效的JSON字符串
    if (self == nil || ![self zhh_isValidJSONFormat]) {
        return nil;
    }
    
    // 将字符串转换为 NSData
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil; // 如果转换失败，返回 nil
    }
    
    // 使用 NSJSONSerialization 将 NSData 解析为 NSDictionary 或 NSArray
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    // 如果解析过程中出现错误，返回 nil
    if (error) {
        return nil;
    }
    
    // 根据解析结果的类型返回 NSDictionary 或 NSArray
    if ([jsonObject isKindOfClass:[NSDictionary class]] || [jsonObject isKindOfClass:[NSArray class]]) {
        return jsonObject;
    }
    
    // 如果解析结果既不是字典也不是数组，返回 nil
    return nil;
}

/**
 * @brief 将字典或数组转为 JSON 字符串
 *
 * @param object 要转换为 JSON 字符串的字典或数组
 * @return 返回转换后的 JSON 字符串，如果失败返回 nil
 */
+ (NSString *)zhh_jsonStringFromObject:(id)object {
    if (![object isKindOfClass:[NSDictionary class]] && ![object isKindOfClass:[NSArray class]]) {
        return nil;  // 如果传入的不是字典或数组，直接返回 nil
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
#ifdef DEBUG
        NSLog(@"ZHHAnneKit 警告: 对象转JSON失败: %@", error.localizedDescription);
#endif
        return nil;
    }
    
    // 将 NSData 转换为 NSString
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

/// 判断字符串是否包含指定字符集中的字符
- (BOOL)zhh_containsCharacterSet:(NSCharacterSet *)set {
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

/// 判断当前字符串是否包含指定的子字符串
- (BOOL)zhh_containsString:(NSString *)string {
    return [self rangeOfString:string].location != NSNotFound;
}

/**
 判断字符串中是否包含表情符号
 @return 如果包含表情符号返回 `YES`，否则返回 `NO`
 */
- (BOOL)zhh_containsEmoji {
    __block BOOL containsEmoji = NO;

    // 遍历字符串的每个组合字符
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        
        // 判断是否为高位代理项
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) { // 表情符号范围
                    containsEmoji = YES;
                    *stop = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) { // 组合键表情（如数字键和组合键）
                containsEmoji = YES;
                *stop = YES;
            }
        } else {
            // 普通字符判断
            if ((0x2100 <= hs && hs <= 0x27ff) || // 常规符号
                (0x2B05 <= hs && hs <= 0x2b07) || // 箭头符号
                (0x2934 <= hs && hs <= 0x2935) || // 箭头符号
                (0x3297 <= hs && hs <= 0x3299) || // 特殊符号
                (hs == 0xa9 || hs == 0xae || // 版权与注册符号
                 hs == 0x303d || hs == 0x3030 || // 特殊标点符号
                 hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)) { // 特殊符号
                containsEmoji = YES;
                *stop = YES;
            }
        }
    }];
    return containsEmoji;
}

/// 判断字符串是否是表情符号
/// @return YES 表示字符串是一个表情符号，NO 表示不是
- (BOOL)zhh_isEmoji {
    if (self.length <= 0) return NO; // 如果字符串为空，则不是表情符号

    // 获取字符串的第一个字符
    const unichar high = [self characterAtIndex:0];
    
    // 判断是否为代理对 (Surrogate Pair) 表情符号，范围为 U+1D000 - U+1F77F
    if (0xd800 <= high && high <= 0xdbff) {
        if (self.length < 2) return NO; // 防止数组越界
        const unichar low = [self characterAtIndex:1]; // 获取低位代理字符
        const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000; // 计算 Unicode 码点
        return (0x1d000 <= codepoint && codepoint <= 0x1f77f); // 检查是否在表情范围内
    } else {
        // 非代理对字符，范围为 U+2100 - U+27BF
        return (0x2100 <= high && high <= 0x27bf);
    }
}

/**
 * 从字符串中移除所有 Emoji 表情符号
 *
 * @return 返回一个新的字符串，其中已移除了所有 Emoji 表情
 *
 * 示例:
 * 输入: @"Hello 😊 World 🌍"
 * 输出: @"Hello  World "
 */
- (NSString *)zhh_stringByRemovingEmoji {
    NSMutableString *buffer = [NSMutableString stringWithCapacity:[self length]];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // 如果不是 Emoji，则添加到结果字符串中
        if (![substring zhh_isEmoji]) {
            [buffer appendString:substring];
        }
    }];
    return buffer;
}

/// 判断字符串是否包含中文字符
- (BOOL)zhh_isContainChinese {
    // 遍历字符串中的每个字符
    for (int i = 0; i < self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        // 判断是否在中文字符范围内
        if (ch >= 0x4e00 && ch <= 0x9fff) {
            return YES; // 如果找到中文字符，直接返回YES
        }
    }
    return NO; // 如果没有找到中文字符，返回NO
}

/// 判断字符串是否包含空格
- (BOOL)zhh_isContainBlank {
    // 查找字符串中是否包含空格字符，直接返回结果
    return [self rangeOfString:@" "].location != NSNotFound;
}

/// 将Unicode编码的字符串转换为NSString
- (NSString *)zhh_makeUnicodeToString {
    // 使用正则表达式替换所有的Unicode编码，转化为对应的字符
    NSString *unicodeStr = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    unicodeStr = [unicodeStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    unicodeStr = [NSString stringWithFormat:@"\"%@\"", unicodeStr];
    
    // 转换为UTF-8 NSData
    NSData *data = [unicodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // 解析NSData为NSString
    NSString *decodedString = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
    
    // 返回处理后的字符串
    return decodedString;
}

/**
 *  @brief 获取字符数量（按实际字符类型统计）
 *
 *  @discussion
 *  该方法计算字符串中的字符数量，其中：ASCII字符按1个字符计，
 *  非ASCII字符（如中文）按1个字符计，空格字符按半个字符计。
 *
 *  @return 字符总数
 */
- (int)zhh_wordsCount {
    NSInteger n = self.length;
    int asciiCount = 0, spaceCount = 0, nonAsciiCount = 0;
    
    for (NSInteger i = 0; i < n; i++) {
        unichar c = [self characterAtIndex:i];
        
        if (isblank(c)) {
            spaceCount++;
        } else if (isascii(c)) {
            asciiCount++;
        } else {
            nonAsciiCount++;
        }
    }
    
    // 如果没有ASCII字符和非ASCII字符，返回0
    if (asciiCount == 0 && nonAsciiCount == 0) {
        return 0;
    }
    
    // 总字符数 = 非ASCII字符数 + 空格字符数/2 + ASCII字符数/2
    return nonAsciiCount + (asciiCount + spaceCount + 1) / 2;
}

/**
 *  @brief 将当前字符串进行 URL 编码
 *
 *  @discussion
 *  对字符串中的中文及特殊字符进行百分号编码，编码后的字符串可以安全地嵌入 URL 请求中。
 *  遵循 RFC 3986 编码规则，保留部分不需要编码的字符如 "?" 和 "/"，并避免破坏多字节字符。
 *
 *  @return 编码后的字符串；如果当前字符串为空或长度为 0，返回 nil
 */
- (NSString *)zhh_encodedURLString {
    // 检查当前字符串是否为空
    if (self == nil || self.length == 0) {
        return nil;
    }
    
    // 定义需要移除的保留字符（符合 RFC 3986）
    static NSString * const kGeneralDelimitersToEncode = @":#[]@"; // 不包括 "?" 和 "/"
    static NSString * const kSubDelimitersToEncode = @"!$&'()*+,;=";
    
    // 构造自定义的字符集，移除需要编码的字符
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kGeneralDelimitersToEncode stringByAppendingString:kSubDelimitersToEncode]];
    
    // 分块处理，防止破坏多字节字符
    static NSUInteger const batchSize = 50;
    NSMutableString *escaped = [NSMutableString string];
    NSUInteger index = 0;
    
    while (index < self.length) {
        // 计算当前分块的范围
        NSRange range = NSMakeRange(index, MIN(self.length - index, batchSize));
        // 确保不会截断多字节字符（如 Emoji）
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        // 提取子字符串并进行编码
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        index += range.length;
    }
    
    return escaped;
}

/**
 *  @brief 将当前字符串进行 URL 解码
 *
 *  @discussion
 *  使用百分号编码的 URL 字符串进行解码，将特殊字符还原到原始字符串形式。
 *  如果当前字符串为空或解码失败，则返回 nil。
 *
 *  @return 解码后的字符串
 */
- (NSString *)zhh_decodedURLString {
    // 检查当前字符串是否为空
    if (self == nil || self.length == 0) {
        return nil;
    }
    
    // 使用现代 API 解码
    return [self stringByRemovingPercentEncoding];
}

/**
 *  @brief 将 URL 参数字符串解析为字典
 *
 *  @discussion
 *  解析当前字符串中以 `?` 后的 URL 参数部分，按键值对形式生成字典。
 *  支持百分号编码字符自动解码。
 *
 *  @return 包含所有参数的字典；如果没有参数或解析失败，返回空字典。
 */
- (NSDictionary *)zhh_parameters {
    // 检查字符串是否为空或不包含参数部分
    if (self.length == 0 || ![self containsString:@"?"]) {
        return @{};
    }
    
    // 获取 '?' 后的查询部分
    NSString *queryString = [self componentsSeparatedByString:@"?"].lastObject;
    if (queryString.length == 0) {
        return @{};
    }
    
    NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    // 遍历参数键值对
    for (NSString *queryComponent in queryComponents) {
        NSArray *keyValue = [queryComponent componentsSeparatedByString:@"="];
        if (keyValue.count == 2) { // 确保是有效的键值对
            NSString *key = [keyValue.firstObject stringByRemovingPercentEncoding];
            NSString *value = [keyValue.lastObject stringByRemovingPercentEncoding];
            
            if (key && value) {
                [parametersDictionary setObject:value forKey:key];
            }
        }
    }
    return [parametersDictionary copy]; // 返回不可变字典
}

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
- (NSString *)zhh_valueForParameter:(NSString *)parameterKey {
    // 检查参数名是否有效
    if (!parameterKey || parameterKey.length == 0) {
        return nil;
    }
    
    // 从解析的参数字典中直接获取值
    return [self zhh_parameters][parameterKey];
}
@end
