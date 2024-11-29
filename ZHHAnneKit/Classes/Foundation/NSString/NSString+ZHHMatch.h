//
//  NSString+ZHHMatch.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}     重复n次或更多次
 {n,m}     重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]     匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?     重复n到m次，但尽可能少重复
 {n,}?     重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn     ASCII代码中八进制代码为nn的字符
 \xnn     ASCII代码中十六进制代码为nn的字符
 \unnnn     Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}     Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */

// Password strength level
typedef NS_ENUM(NSUInteger, ZHHPasswordLevel) {
    ZHHPasswordLevelEasy = 0,
    ZHHPasswordLevelMidium,
    ZHHPasswordLevelStrong,
    ZHHPasswordLevelVeryStrong,
    ZHHPasswordLevelExtremelyStrong,
};

typedef NS_ENUM(NSInteger, ZHHCharacterType) {
    ZHHCharacterTypeNumber = 1,        // 数字
    ZHHCharacterTypeSmallLetter = 2,  // 小写字母
    ZHHCharacterTypeCapitalLetter = 3,// 大写字母
    ZHHCharacterTypeOtherChar = 4     // 其他字符
};

@interface NSString (ZHHMatch)

/// 使用正则表达式匹配字符串
/// @param regex 正则表达式
/// @return 是否匹配
- (BOOL)zhh_matchesRegex:(NSString *)regex;

/// 验证字符串是否是指定长度的数字
/// @param length 需要验证的数字长度
/// @return 是否符合验证条件
- (BOOL)zhh_isValidNumberWithLength:(NSUInteger)length;

/// 验证邮箱格式
/// @return 是否是合法的邮箱格式
- (BOOL)zhh_isValidEmail;

/// 验证是否是合法手机号
/// @return 是否是合法的手机号格式
///
/// 目前国内手机号的号段分布如下：（截止：2024-11）
/// - 移动（China Mobile）：
///   134-139, 147, 148, 150-152, 157-159, 165, 172, 178, 182-184, 187-188, 195, 198
/// - 联通（China Unicom）：
///   130-132, 145, 146, 155-156, 166, 171, 175, 176, 185-186, 196
/// - 电信（China Telecom）：
///   133, 149, 153, 173, 174, 177, 180-181, 189, 190, 191, 193, 199
/// - 其他：
///   如虚拟运营商号段（162, 167, 170-171 等）
- (BOOL)zhh_isValidMobileNumber;

/// 验证手机号并判断运营商
- (NSString *)zhh_mobileNumberOperator;

/// 验证密码格式（数字和字母组合）
/// @param minLength 最小长度
/// @param maxLength 最大长度
/// @return 是否是合法的密码格式
- (BOOL)zhh_isValidPasswordWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength;

/// 验证用户名格式（中文或英文）
/// @param minLength 最小长度
/// @param maxLength 最大长度
/// @return 是否是合法的用户名格式
- (BOOL)zhh_isValidUserNameWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength;

/// 验证身份证号格式（14 或 17 位，允许最后一位为 X/x）
/// @return 是否是合法的身份证号格式
- (BOOL)zhh_isValidUserIdCard;

/// 判断字符串是否包含字母
/// @return 如果字符串中包含至少一个字母，返回 YES；否则返回 NO
- (BOOL)zhh_containsLetter;

/// 判断字符串是否仅包含字母和数字
/// @return 如果字符串中仅包含字母和数字，返回 YES；否则返回 NO
- (BOOL)zhh_isAlphanumeric;

/// @brief 判断字符串是否为纯数字
/// @return 如果字符串只包含数字返回 YES，否则返回 NO
- (BOOL)zhh_isNumeric;

/// 判断字符串是否以字母开头
/// @return 如果字符串以字母开头，返回 YES；否则返回 NO
- (BOOL)zhh_startsWithLetter;

/// 判断字符串是否以汉字开头
/// @return 如果字符串以汉字开头，返回 YES；否则返回 NO
- (BOOL)zhh_startsWithChineseCharacter;

/// 判断字符串是否为纯字母（大小写均可）
/// @return 如果字符串仅由纯字母组成，返回 YES；否则返回 NO
- (BOOL)zhh_isPureLetter;

/// 判断字符串是否为纯大写字母
/// @return 如果字符串仅由大写字母组成，返回 YES；否则返回 NO
- (BOOL)zhh_isCapitalLetter;

/// 判断字符串是否为纯小写字母
/// @return 如果字符串仅由小写字母组成，返回 YES；否则返回 NO
- (BOOL)zhh_isLowercaseLetter;

/// 判断字符串是否为纯汉字
/// @return 如果字符串仅由汉字组成，返回 YES；否则返回 NO
- (BOOL)zhh_isChineseCharacter;

/// 验证字符串中是否包含特殊字符
/// @return 如果包含特殊字符，返回YES；否则返回NO
- (BOOL)zhh_containsSpecialCharacter;

/// 验证银行卡号
/// @return 如果银行卡号合法（格式正确并通过 Luhn 校验），返回 YES；否则返回 NO
- (BOOL)zhh_isValidBankCard;

/// @brief 判断字符串是否所有字符相同
/// @return 如果字符串中所有字符都相同返回 YES，否则返回 NO
- (BOOL)zhh_isCharEqual;

/// 判断字符串是否匹配指定的正则表达式
/// @param regex 正则表达式，用于匹配的规则
/// @return 如果字符串匹配正则表达式，返回YES；否则返回NO
- (BOOL)zhh_matchWithRegex:(NSString *)regex;

/// 使用正则表达式提取匹配的第一个子字符串
/// @param regex 正则表达式，用于匹配的规则
/// @return 匹配的子字符串，如果没有匹配则返回nil
- (nullable NSString *)zhh_partStringWithRegex:(NSString *)regex;

/// 正则匹配字符串中的所有匹配项
/// @param regex 正则表达式，用于匹配的规则
/// @return 返回一个数组，包含所有匹配的子字符串，如果没有匹配则返回空数组
- (NSArray<NSString *> *)zhh_checkStringArrayWithRegex:(NSString *)regex;

/// 校验身份证号码是否有效
/// @return YES 表示身份证号码有效；NO 表示无效
- (BOOL)zhh_isValidIDCard;

/// 验证IPv4地址
/// @return 如果是合法的IPv4地址，返回YES；否则返回NO
- (BOOL)zhh_isValidateIPAddress;
@end

NS_ASSUME_NONNULL_END
