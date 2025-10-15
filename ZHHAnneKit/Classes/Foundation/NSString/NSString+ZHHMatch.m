//
//  NSString+ZHHMatch.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHMatch.h"
#import "NSString+ZHHCommon.h"

@implementation NSString (ZHHMatch)

/// 使用正则表达式匹配字符串
/// @param regex 正则表达式
/// @return 是否匹配
- (BOOL)zhh_matchesRegex:(NSString *)regex {
    if (self.length == 0 || regex.length == 0) return NO; // 检查字符串和正则表达式是否为空
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/// 验证字符串是否是指定长度的数字
/// @param length 需要验证的数字长度
/// @return 是否符合验证条件
- (BOOL)zhh_isValidNumberWithLength:(NSUInteger)length {
    if (self.length != length) return NO; // 确保字符串长度符合要求
    NSString *regex = [NSString stringWithFormat:@"^\\d{%lu}$", (unsigned long)length];
    return [self zhh_matchesRegex:regex];
}

/// 验证邮箱格式
/// @return 是否是合法的邮箱格式
- (BOOL)zhh_isValidEmail {
    return [self zhh_matchesRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

/// 验证手机号格式
///  是否是合法的手机号格式
- (BOOL)zhh_isValidMobileNumber {
    
    return [self zhh_matchesRegex:@"^1(3[0-9]|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8[0-9]|9[0-35-9])\\d{8}$"];
}

/// 验证手机号并判断运营商
- (NSString *)zhh_mobileNumberOperator {
    // 运营商正则
    NSDictionary<NSString *, NSString *> *operatorRegexes = @{
        @"中国移动": @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478]|98)\\d{8}$",
        @"中国联通": @"^1(3[0-2]|4[5]|5[56]|6[56]|7[0156]|8[56]|96)\\d{8}$",
        @"中国电信": @"^1(3[3]|4[9]|53|7[037]|8[019]|99)\\d{8}$",
        @"其他": @"^1(6[257]|9[0-35-9])\\d{8}$" // 其他号段或虚拟运营商
    };

    for (NSString *operator in operatorRegexes) {
        NSString *regex = operatorRegexes[operator];
        if ([self zhh_matchesRegex:regex]) {
            return operator;
        }
    }

    return @"未知"; // 无匹配结果
}

/// 验证密码格式（数字和字母组合）
/// @param minLength 最小长度
/// @param maxLength 最大长度
/// @return 是否是合法的密码格式
- (BOOL)zhh_isValidPasswordWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength {
    NSString *min = [NSString stringWithFormat:@"%lu",(unsigned long)minLength];
    NSString *max = [NSString stringWithFormat:@"%lu",(unsigned long)minLength];
    NSString *regex = [NSString stringWithFormat:@"^[a-zA-Z0-9]{%@,%@}$", min, max];
    return [self zhh_matchesRegex:regex];
}

/// 验证用户名格式（中文或英文）
/// @param minLength 最小长度
/// @param maxLength 最大长度
/// @return 是否是合法的用户名格式
- (BOOL)zhh_isValidUserNameWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength {
    NSString *min = [NSString stringWithFormat:@"%lu",(unsigned long)minLength];
    NSString *max = [NSString stringWithFormat:@"%lu",(unsigned long)minLength];
    NSString *regex = [NSString stringWithFormat:@"^[\u4e00-\u9fa5a-zA-Z]{%@,%@}$", min, max];
    return [self zhh_matchesRegex:regex];
}

/// 验证身份证号格式（14 或 17 位，允许最后一位为 X/x）
/// @return 是否是合法的身份证号格式
- (BOOL)zhh_isValidUserIdCard {
    return [self zhh_matchesRegex:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}

/// 判断字符串是否包含字母
/// @return 如果字符串中包含至少一个字母，返回 YES；否则返回 NO
- (BOOL)zhh_containsLetter {
    return [self zhh_matchesRegex:@"[A-Za-z]"];
}

/// 判断字符串是否仅包含字母和数字
/// @return 如果字符串中仅包含字母和数字，返回 YES；否则返回 NO
- (BOOL)zhh_isAlphanumeric {
    return [self zhh_matchesRegex:@"^[a-zA-Z0-9]*$"];
}

/// @brief 判断字符串是否为纯数字
/// @return 如果字符串只包含数字返回 YES，否则返回 NO
- (BOOL)zhh_isNumeric {
    return [self zhh_matchesRegex:@"^[0-9]+$"];
}

/// 判断字符串是否以字母开头
/// @return 如果字符串以字母开头，返回 YES；否则返回 NO
- (BOOL)zhh_startsWithLetter {
    if (self.length == 0) return NO; // 空字符串直接返回 NO
    NSString *firstCharacter = [self substringToIndex:1]; // 提取第一个字符
    return [firstCharacter zhh_matchesRegex:@"^[a-zA-Z]$"];
}

/// 判断字符串是否以汉字开头
/// @return 如果字符串以汉字开头，返回 YES；否则返回 NO
- (BOOL)zhh_startsWithChineseCharacter {
    if (self.length == 0) return NO; // 空字符串直接返回 NO
    NSString *firstCharacter = [self substringToIndex:1]; // 提取第一个字符
    return [firstCharacter zhh_matchesRegex:@"^[\u4e00-\u9fa5]$"];
}

/// 判断字符串是否为纯字母（大小写均可）
/// @return 如果字符串仅由纯字母组成，返回 YES；否则返回 NO
- (BOOL)zhh_isPureLetter {
    return [self zhh_matchesRegex:@"^[a-zA-Z]+$"];
}

/// 判断字符串是否为纯大写字母
/// @return 如果字符串仅由大写字母组成，返回 YES；否则返回 NO
- (BOOL)zhh_isCapitalLetter {
    return [self zhh_matchesRegex:@"^[A-Z]+$"];
}

/// 判断字符串是否为纯小写字母
/// @return 如果字符串仅由小写字母组成，返回 YES；否则返回 NO
- (BOOL)zhh_isLowercaseLetter {
    return [self zhh_matchesRegex:@"^[a-z]+$"];
}

/// 判断字符串是否为纯汉字
/// @return 如果字符串仅由汉字组成，返回 YES；否则返回 NO
- (BOOL)zhh_isChineseCharacter {
    // 中文编码范围是 0x4E00 ~ 0x9FA5
    return [self zhh_matchesRegex:@"^[\u4e00-\u9fa5]+$"];
}

/// 验证字符串中是否包含特殊字符
/// @return 如果包含特殊字符，返回YES；否则返回NO
- (BOOL)zhh_containsSpecialCharacter {
    NSString *regex = @".*[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？].*";
    return [self zhh_matchesRegex:regex];
}

/// 验证银行卡号
- (BOOL)zhh_isValidBankCard {
    // 正则验证银行卡号是否为16或19位数字
    if (![self zhh_matchesRegex:@"^(\\d{16}|\\d{19})$"]) {
        return NO;
    }

    // 使用 Luhn 算法校验银行卡号
    return [self zhh_luhnCheck];
}

/// Luhn 算法校验银行卡号
- (BOOL)zhh_luhnCheck {
    NSInteger sum = 0;
    BOOL shouldDouble = NO;

    for (NSInteger i = self.length - 1; i >= 0; i--) {
        unichar c = [self characterAtIndex:i];
        if (!isdigit(c)) {
            return NO; // 非数字直接返回不合法
        }

        NSInteger digit = c - '0';
        if (shouldDouble) {
            digit *= 2;
            if (digit > 9) {
                digit -= 9; // 若乘积大于9，则减去9
            }
        }
        sum += digit;
        shouldDouble = !shouldDouble; // 每隔一位翻转标记
    }

    return sum % 10 == 0; // 如果总和能被10整除，则号码有效
}

/// @brief 判断字符串是否所有字符相同
/// @return 如果字符串中所有字符都相同返回 YES，否则返回 NO
- (BOOL)zhh_isCharEqual {
    // 空字符串或只有一个字符的字符串，直接返回 YES
    if (self.length <= 1) return YES;
    // 获取第一个字符
    unichar firstChar = [self characterAtIndex:0];
    // 遍历字符串中的字符，检查是否有不同的
    for (NSUInteger i = 1; i < self.length; i++) {
        if ([self characterAtIndex:i] != firstChar) {
            return NO;
        }
    }
    return YES;
}

// 私有方法：执行正则表达式匹配并返回匹配结果
- (NSArray<NSTextCheckingResult *> *)zhh_matchesWithRegex:(NSString *)regex error:(NSError **)error {
    if (self == nil || regex == nil) return @[];

    // 使用正则表达式执行匹配
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                  error:error];

    if (*error) {
        NSLog(@"ZHHAnneKit 警告: 正则表达式错误: %@", (*error).localizedDescription);  // 打印错误信息
        return @[];
    }

    return [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

// 判断字符串是否匹配指定的正则表达式
- (BOOL)zhh_matchWithRegex:(NSString *)regex {
    NSError *error = nil;
    NSArray *matches = [self zhh_matchesWithRegex:regex error:&error];
    return (matches.count > 0);  // 如果有匹配项，返回YES，否则返回NO
}

// 使用正则表达式提取匹配的第一个子字符串
- (NSString *)zhh_partStringWithRegex:(NSString *)regex {
    NSError *error = nil;
    NSArray *matches = [self zhh_matchesWithRegex:regex error:&error];
    if (matches.count > 0) {
        NSTextCheckingResult *firstMatch = matches.firstObject;
        return [self substringWithRange:firstMatch.range];
    }
    return nil;  // 如果没有匹配，返回nil
}

// 正则匹配字符串中的所有匹配项
- (NSArray<NSString *> *)zhh_checkStringArrayWithRegex:(NSString *)regex {
    NSError *error = nil;
    NSArray *matches = [self zhh_matchesWithRegex:regex error:&error];

    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:matches.count];
    for (NSTextCheckingResult *match in matches) {
        [resultArray addObject:[self substringWithRange:match.range]];
    }
    
    return [resultArray copy];  // 返回不可变数组
}

/// 主方法：验证身份证号码有效性
- (BOOL)zhh_isValidIDCard {
    NSString *idCard = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (idCard.length != 15 && idCard.length != 18) {
        return NO; // 必须是 15 位或 18 位
    }

    // 验证地址码
    NSString *addressCode = [idCard substringToIndex:2];
    if (![self.class zhh_isValidAddressCode:addressCode]) {
        return NO;
    }

    // 验证出生日期
    NSString *birthDate = (idCard.length == 15)
        ? [NSString stringWithFormat:@"19%@", [idCard substringWithRange:NSMakeRange(6, 6)]]
        : [idCard substringWithRange:NSMakeRange(6, 8)];
    if (![self.class zhh_isValidBirthDate:birthDate]) {
        return NO;
    }

    // 验证校验码（仅限 18 位）
    if (idCard.length == 18 && ![self.class zhh_isValidChecksum:idCard]) {
        return NO;
    }

    return YES;
}

/// 验证地址码是否合法
/// @param addressCode 地址码前两位
+ (BOOL)zhh_isValidAddressCode:(NSString *)addressCode {
    NSArray *validAreas = @[@"11",@"12",@"13",@"14",@"15",@"21",@"22",@"23",@"31",@"32",
                            @"33",@"34",@"35",@"36",@"37",@"41",@"42",@"43",@"44",@"45",
                            @"46",@"50",@"51",@"52",@"53",@"54",@"61",@"62",@"63",@"64",
                            @"65",@"71",@"81",@"82",@"91"];
    return [validAreas containsObject:addressCode];
}

/// 验证出生日期是否合法
/// @param birthDate 出生日期（格式：yyyyMMdd）
+ (BOOL)zhh_isValidBirthDate:(NSString *)birthDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    formatter.lenient = NO; // 严格模式验证日期
    return [formatter dateFromString:birthDate] != nil;
}

/// 验证身份证校验码
/// @param idCard 完整的 18 位身份证号码
+ (BOOL)zhh_isValidChecksum:(NSString *)idCard {
    static const int factors[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    static const char checksums[] = "10X98765432";

    int sum = 0;
    for (int i = 0; i < 17; i++) {
        unichar c = [idCard characterAtIndex:i];
        if (!isdigit(c)) return NO; // 非数字则无效
        sum += (c - '0') * factors[i];
    }

    char calculatedChecksum = checksums[sum % 11];
    char providedChecksum = toupper([idCard characterAtIndex:17]);
    return calculatedChecksum == providedChecksum;
}

/// 验证IPv4地址
/// @return 如果是合法的IPv4地址，返回YES；否则返回NO
- (BOOL)zhh_isValidateIPAddress {

    // 使用 zh_matchesRegex 方法校验格式
    if (![self zhh_matchesRegex:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"]) {
        return NO;
    }

    // 验证每个段是否在0~255之间
    NSArray<NSString *> *components = [self componentsSeparatedByString:@"."];
    for (NSString *component in components) {
        NSInteger value = component.integerValue;
        if (value < 0 || value > 255) {
            return NO;
        }
    }

    return YES;
}

#pragma mark - 密码强度判断
/// 获取字符类型
- (ZHHCharacterType)zhh_characterType:(NSString *)character {
    unichar asciiCode = [character characterAtIndex:0];
    if (asciiCode >= 48 && asciiCode <= 57) {
        return ZHHCharacterTypeNumber; // 数字
    }
    if (asciiCode >= 65 && asciiCode <= 90) {
        return ZHHCharacterTypeCapitalLetter; // 大写字母
    }
    if (asciiCode >= 97 && asciiCode <= 122) {
        return ZHHCharacterTypeSmallLetter; // 小写字母
    }
    return ZHHCharacterTypeOtherChar; // 其他字符
}

/// 统计某类型字符的数量
- (NSInteger)zhh_countCharacterOfType:(ZHHCharacterType)type {
    __block NSInteger count = 0;
    // 遍历字符串，统计符合特定类型的字符数量
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if ([self zhh_characterType:substring] == type) {
            count++;
        }
    }];
    return count;
}

/// 密码强度等级
- (ZHHPasswordLevel)zhh_passwordLevel {
    NSInteger strengthLevel = [self zhh_checkPasswordStrength];
    // 根据强度得分返回对应的密码等级
    if (strengthLevel <= 3) {
        return ZHHPasswordLevelEasy; // 简单
    } else if (strengthLevel <= 6) {
        return ZHHPasswordLevelMidium; // 中等
    } else if (strengthLevel <= 9) {
        return ZHHPasswordLevelStrong; // 强
    } else if (strengthLevel <= 12) {
        return ZHHPasswordLevelVeryStrong; // 很强
    } else {
        return ZHHPasswordLevelExtremelyStrong; // 极强
    }
}

/// 检查密码强度
- (NSInteger)zhh_checkPasswordStrength {
    // 特殊情况检查：为空或字符全部相同，强度为0
    if (self.zhh_empty || self.zhh_isCharEqual) {
        return 0;
    }
    
    NSInteger len = self.length; // 密码长度
    __block NSInteger level = 0;

    // 检查包含的字符类型，符合条件加分
    if ([self zhh_countCharacterOfType:ZHHCharacterTypeNumber] > 0) {
        level++; // 包含数字
    }
    if ([self zhh_countCharacterOfType:ZHHCharacterTypeSmallLetter] > 0) {
        level++; // 包含小写字母
    }
    if (len > 4 && [self zhh_countCharacterOfType:ZHHCharacterTypeCapitalLetter] > 0) {
        level++; // 长度大于4且包含大写字母
    }
    if (len > 6 && [self zhh_countCharacterOfType:ZHHCharacterTypeOtherChar] > 0) {
        level++; // 长度大于6且包含特殊字符
    }

    // 检查字符组合，满足多种类型组合条件加分
    NSArray *combinations = @[
        @[@(ZHHCharacterTypeNumber), @(ZHHCharacterTypeSmallLetter)],
        @[@(ZHHCharacterTypeNumber), @(ZHHCharacterTypeCapitalLetter)],
        @[@(ZHHCharacterTypeNumber), @(ZHHCharacterTypeOtherChar)],
        @[@(ZHHCharacterTypeSmallLetter), @(ZHHCharacterTypeCapitalLetter)],
        @[@(ZHHCharacterTypeSmallLetter), @(ZHHCharacterTypeOtherChar)],
        @[@(ZHHCharacterTypeCapitalLetter), @(ZHHCharacterTypeOtherChar)]
    ];
    [combinations enumerateObjectsUsingBlock:^(NSArray *types, NSUInteger idx, BOOL *stop) {
        if ([self zhh_countCharacterOfType:[types[0] integerValue]] > 0 &&
            [self zhh_countCharacterOfType:[types[1] integerValue]] > 0) {
            level++;
        }
    }];
    
    // 长度较长且包含更多类型组合加分
    if (len > 8 &&
        [self zhh_countCharacterOfType:ZHHCharacterTypeNumber] > 0 &&
        [self zhh_countCharacterOfType:ZHHCharacterTypeSmallLetter] > 0 &&
        [self zhh_countCharacterOfType:ZHHCharacterTypeCapitalLetter] > 0 &&
        [self zhh_countCharacterOfType:ZHHCharacterTypeOtherChar] > 0) {
        level++;
    }
    if (len > 12) {
        level++; // 长度大于12加分
        if (len >= 16) {
            level++; // 长度大于等于16额外加分
        }
    }
    
    // 减分条件：检查是否包含简单模式或弱密码模式
    if ([@"abcdefghijklmnopqrstuvwxyz" containsString:self] ||
        [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" containsString:self] ||
        [@"qwertyuiopasdfghjklzxcvbnm" containsString:self]) {
        level--; // 键盘连续输入模式减分
    }
    if ([self zhh_isNumeric] && len >= 6) {
        NSString *prefix = [self substringToIndex:len - 4];
        NSInteger year = prefix.integerValue;
        NSInteger month = [[self substringWithRange:NSMakeRange(len - 4, 2)] integerValue];
        NSInteger day = [[self substringWithRange:NSMakeRange(len - 2, 2)] integerValue];
        if ((year >= 1950 && year < 2050) && (month >= 1 && month <= 12) && (day >= 1 && day <= 31)) {
            level--; // 减分：密码可能是生日日期
        }
    }
    
    // 检查是否使用了常见密码或其变体
    NSArray *commonPasswords = @[@"password", @"abc123", @"iloveyou", @"adobe123", @"123123",
                                 @"sunshine", @"1314520", @"a1b2c3", @"123qwe", @"aaa111",
                                 @"qweasd", @"admin", @"passwd"];
    [commonPasswords enumerateObjectsUsingBlock:^(NSString *pwd, NSUInteger idx, BOOL *stop) {
        if ([self isEqualToString:pwd] || [pwd containsString:self]) {
            level--;
            *stop = YES; // 如果匹配常见密码立即减分并退出检查
        }
    }];
    
    // 返回最终计算的强度得分（确保非负）
    return MAX(level, 0);
}
@end
