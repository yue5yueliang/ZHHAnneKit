//
//  NSNumber+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSNumber+ZHHUtilities.h"

@implementation NSNumber (ZHHUtilities)
/**
 * @brief 将数值对象转换为 CGFloat 类型
 *
 * @discussion 根据当前平台的 `CGFloat` 类型（`float` 或 `double`），
 * 自动选择对应的转换方法，确保兼容性。
 *
 * @return 转换后的 `CGFloat` 值，如果对象不是数值类型，则返回 0.0。
 */
- (CGFloat)zhh_toCGFloat {
    CGFloat result = 0.0;

    // iOS 13.0+ 直接使用数值转换
#if (CGFLOAT_IS_DOUBLE == 1)
    result = [self doubleValue];
#else
    result = [self floatValue];
#endif

    return result;
}

/**
 * @brief 使用 CGFloat 值创建一个 NSNumber 对象
 *
 * @discussion 根据当前平台的 CGFloat 类型（float 或 double），
 * 手动调用 `numberWithDouble:` 或 `numberWithFloat:` 方法生成 NSNumber 对象，
 * 确保在不同平台上正确处理 CGFloat 类型。
 *
 * @param value 要包装的 CGFloat 值
 * @return 包含 CGFloat 值的 NSNumber 对象
 */
+ (NSNumber *)zhh_numberWithCGFloat:(CGFloat)value {
#if (CGFLOAT_IS_DOUBLE == 1)
    return [NSNumber numberWithDouble:value];
#else
    return [NSNumber numberWithFloat:value];
#endif
}

/**
 * @brief 将数字转换为罗马数字字符串
 *
 * @discussion 该方法将当前 NSNumber 对象的整数值转换为罗马数字表示形式，
 * 支持从 1 到 3999 的数字。如果超出范围，将返回空字符串。
 *
 * @return 转换后的罗马数字字符串
 */
- (NSString *)zhh_romanNumeral {
    NSInteger n = [self integerValue];
    
    // 检查有效范围，罗马数字通常只支持 1 到 3999
    if (n < 1 || n > 3999) {
        return @""; // 返回空字符串表示无效输入
    }
    
    // 罗马数字符号及其对应的值
    NSArray<NSString *> *numerals = @[@"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I"];
    NSUInteger values[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    NSUInteger valueCount = sizeof(values) / sizeof(values[0]);
    
    NSMutableString *numeralString = [NSMutableString string];
    
    // 迭代数组，逐步将数字减小并构建罗马数字字符串
    for (NSUInteger i = 0; i < valueCount; i++) {
        while (n >= values[i]) {
            n -= values[i];
            [numeralString appendString:numerals[i]];
        }
    }
    return [numeralString copy];
}

/**
 * @brief 格式化数字为带指定小数位的显示字符串
 *
 * @discussion 使用 `NSNumberFormatter` 将当前数字格式化为包含指定小数位的字符串。
 * 数字格式为千分位分隔的小数表示，四舍五入方式为“向最近的偶数舍入”（`RoundHalfUp`）。
 *
 * @param digit 保留的小数位数。如果 `digit` 小于 0，则默认保留 0 位小数。
 * @return 格式化后的字符串。如果格式化失败，返回空字符串。
 */
- (NSString *)zhh_formattedStringWithFractionDigits:(NSInteger)digit {
    // 保证小数位数非负
    NSInteger validDigit = MAX(0, digit);

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle; // 千分位分隔样式
    formatter.roundingMode = NSNumberFormatterRoundHalfUp; // 四舍五入
    formatter.maximumFractionDigits = validDigit;         // 设置最大小数位数
    
    NSString *result = [formatter stringFromNumber:self];
    return result ?: @""; // 如果结果为 nil，则返回空字符串
}

/**
 * @brief 将数字格式化为百分比字符串，保留指定的小数位数
 *
 * @discussion 使用 `NSNumberFormatter` 将当前数字转换为百分比字符串（例如：0.1 -> 10%）。
 * 使用指定的小数位数进行格式化，并且采用“四舍五入”方式。
 *
 * @param digit 保留的小数位数。如果 `digit` 小于 0，则默认保留 0 位小数。
 * @return 格式化后的百分比字符串。如果格式化失败，返回空字符串。
 */
- (NSString *)zhh_toDisplayPercentageWithFractionDigits:(NSInteger)digit {
    // 保证小数位数非负
    NSInteger validDigit = MAX(0, digit);

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;        // 设置百分比样式
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;        // 四舍五入
    formatter.maximumFractionDigits = validDigit;                 // 设置最大小数位数
    
    NSString *result = [formatter stringFromNumber:self];
    return result ?: @"";  // 如果结果为 nil，则返回空字符串
}

#pragma mark - ceil , round, floor
/**
 * @brief 四舍五入到指定的小数位数
 *
 * @discussion 使用 `NSNumberFormatter` 进行四舍五入操作，确保结果保留指定的小数位数。
 *
 * @param digit 要保留的小数位数
 * @return 返回四舍五入后的结果。若格式化失败，则返回 `nil`。
 */
- (NSNumber *)zhh_doRoundWithDigit:(NSUInteger)digit {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;  // 设置四舍五入
    formatter.maximumFractionDigits = digit;                // 设置最大小数位数
    formatter.minimumFractionDigits = digit;                // 设置最小小数位数

    NSString *formattedString = [formatter stringFromNumber:self];
    return formattedString ? @(formattedString.doubleValue) : nil;
}

/**
 *  @brief  向上舍入（取上整）到指定的小数位数
 *
 *  @discussion 使用 `NSNumberFormatter` 对数字进行向上舍入（ceil），并且保留指定的小数位数。
 *
 *  @param digit 要保留的小数位数
 *  @return 返回经过向上舍入的结果。若格式化失败，则返回 `nil`。
 */
- (NSNumber *)zhh_doCeilWithDigit:(NSUInteger)digit {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundCeiling;  // 设置向上舍入
    formatter.maximumFractionDigits = digit;                 // 设置最大小数位数
    formatter.minimumFractionDigits = digit;                 // 设置最小小数位数

    NSString *formattedString = [formatter stringFromNumber:self];
    return formattedString ? @(formattedString.doubleValue) : nil;
}
/**
 *  @brief  向下舍入（取下整）到指定的小数位数
 *
 *  @discussion 使用 `NSNumberFormatter` 对数字进行向下舍入（floor），并且保留指定的小数位数。
 *
 *  @param digit 要保留的小数位数
 *  @return 返回经过向下舍入的结果。若格式化失败，则返回 `nil`。
 */
- (NSNumber *)zhh_doFloorWithDigit:(NSUInteger)digit {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;  // 设置向下舍入
    formatter.maximumFractionDigits = digit;               // 设置最大小数位数
    formatter.minimumFractionDigits = digit;               // 设置最小小数位数

    NSString *formattedString = [formatter stringFromNumber:self];
    return formattedString ? @(formattedString.doubleValue) : nil;
}
@end
