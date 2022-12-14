//
//  NSString+ZHHMath.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHMath.h"

@implementation NSString (ZHHMath)
/// 是否为空
- (BOOL)isEmpty{
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
- (NSString *)safeString{
    return self.isEmpty ? @"" : self;
}

#pragma mark - 数学运算
/// 是否为空
NS_INLINE BOOL kStringBlank(NSString *string){
    string = [NSString stringWithFormat:@"%@", string];
    NSString *trimed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimed.length <= 0;
}
/* 比较大小 */
- (NSComparisonResult)zhh_compare:(NSString *)string{
    if (self.length <= 0) return NSOrderedAscending;
    if (kStringBlank(string)) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    return [decimalA compare:decimalB];
}
/* 相加 */
- (NSString *)zhh_adding:(NSString *)string{
    if (kStringBlank(string) || [string zhh_compare:@"0"] == NSOrderedSame) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberByAdding:decimalB];
    return [result stringValue];
}
/* 相减 */
- (NSString *)zhh_subtract:(NSString *)string{
    if (kStringBlank(string)) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberBySubtracting:decimalB];
    return [result stringValue];
}
/* 相乘 */
- (NSString *)zhh_multiply:(NSString *)string{
    if (kStringBlank(string)) string = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberByMultiplyingBy:decimalB];
    return [result stringValue];
}
/* 相除 */
- (NSString *)zhh_divide:(NSString *)string{
    if (kStringBlank(string) || ![string floatValue]) return @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalB = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *result = [decimalA decimalNumberByDividingBy:decimalB];
    return [result stringValue];
}
/// 指数运算
- (NSString *)zhh_multiplyingByPowerOf10:(NSInteger)oxff{
    NSString *temp = self;
    if (kStringBlank(temp)) temp = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumber *result = [decimalA decimalNumberByMultiplyingByPowerOf10:oxff];
    return [result stringValue];
}
/// 次方运算
- (NSString *)zhh_raisingToPower:(NSInteger)oxff{
    NSString *temp = self;
    if (kStringBlank(temp)) temp = @"0";
    NSDecimalNumber *decimalA = [NSDecimalNumber decimalNumberWithString:temp];
    NSDecimalNumber *result = [decimalA decimalNumberByRaisingToPower:oxff];
    return [result stringValue];
}
/// 转成小数
- (double)zhh_calculateDoubleValue{
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:self];
    return [num doubleValue];
}
/// 保留整数
- (NSString *)zhh_retainInteger{
    if (![self containsString:@"."]) {
        return self;
    } else {
        NSArray *array = [self componentsSeparatedByString:@"."];
        return array.firstObject;
    }
}
/// 去掉尾巴
- (NSString *)zhh_removeTailZero{
    NSString * string = self;
    if (![string containsString:@"."]) {
        return string;
    } else if ([string hasSuffix:@"0"]) {
        return [[string substringToIndex:string.length - 1] zhh_removeTailZero];
    } else if ([string hasSuffix:@"."]) {
        return [string substringToIndex:string.length - 1];
    } else {
        return string;
    }
}
/// 保留几位小数，四舍五入保留
NSString * kStringFractionDigits(NSDecimalNumber * number, NSUInteger digits){
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:digits];
    [formatter setMinimumFractionDigits:0];
    [formatter setMinimumIntegerDigits:1];
    return [formatter stringFromNumber:number];
}
+ (NSString *)zhh_fractionDigits:(double)value digits:(NSUInteger)digits{
    NSNumber * number = [NSNumber numberWithDouble:value];
    NSDecimalNumber * decNum = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    return kStringFractionDigits(decNum, digits);
}
/// 保留小数，直接去掉小数多余部分
+ (NSString *)zhh_retainDigits:(double)value digits:(int)digits{
    NSString * string = [self zhh_doublePrecisionReviseWithDouble:value];
    if (![string containsString:@"."]) {
        return string;
    } else {
        NSArray<NSString*> * array = [string componentsSeparatedByString:@"."];
        if (array.count < 2) {
            return string;
        }
        if (digits == 0) {
            return array.firstObject;
        } else {
            NSString * decimals = array.lastObject;
            if (decimals.length > digits) {
                decimals = [decimals substringToIndex:digits];
            }
            return [NSString stringWithFormat:@"%@.%@",array.firstObject, decimals];
        }
    }
    return string;
}
/// 保留几位有效小数位数
NSString * kStringReservedValidDigit(NSDecimalNumber * value, NSInteger digit){
    NSString *string = [value stringValue];
    if (![string containsString:@"."]) {
        return string;
    } else {
        NSArray<NSString*>*array = [string componentsSeparatedByString:@"."];
        NSString *decimals = array[1];
        if (![decimals floatValue]) {
            string = array[0];
        } else {
            if (digit == 0) {
                return [NSString stringWithFormat:@"%@",array[0]];
            }
            if (decimals.length <= digit) {
                string = [NSString stringWithFormat:@"%@.%@",array[0],decimals];
            } else {
                int a = 0;
                while (true) {
                    if ([decimals hasPrefix:@"0"]) {
                        a++;
                        decimals = [decimals substringFromIndex:1];
                    } else {
                        if (decimals.length > digit) {
                            decimals = [decimals substringToIndex:digit];
                        }
                        break;
                    }
                }
                for (int i = 0; i < a; i++) {
                    decimals = [NSString stringWithFormat:@"0%@",decimals];
                }
                string = [NSString stringWithFormat:@"%@.%@",array[0],decimals];
            }
        }
    }
    return string;
}
+ (NSString *)zhh_reservedValidDigit:(double)value digit:(int)digit{
    NSNumber * number = [NSNumber numberWithDouble:value];
    NSDecimalNumber * decNum = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    return kStringReservedValidDigit(decNum, digit);
}
/// Double精度丢失修复
- (NSString *)zhh_doublePrecisionRevise{
    double conversionValue = [self doubleValue];
    return [NSString zhh_doublePrecisionReviseWithDouble:conversionValue];
}
+ (NSString *)zhh_doublePrecisionReviseWithDouble:(double)conversionValue{
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

/// 是否为数字
- (BOOL)isNumber{
    if ([self length] == 0) {
        return NO;
    }
    NSScanner *sc = [NSScanner scannerWithString:self];
    if ([sc scanFloat:NULL]) {
        return [sc isAtEnd];
    }
    return NO;
}
/// 是否是整形
- (BOOL)isInt{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
/// 是否是浮点型
- (BOOL)isFloat{
    NSArray<NSString *> *groups = [self componentsSeparatedByString:@"."];
    if (groups.count == 1) {
        return groups[0].isInt;
    } else if (groups.count == 2) {
        return groups[0].isInt && groups[1].isInt;
    }
    return NO;
}

- (NSString *)zhh_parseToIntStringWithDecimals:(int)decimals {
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (!string.isNumber) {
        return @"0";
    }
    if (decimals <= 0) {
        NSArray<NSString *> *groups = [string componentsSeparatedByString:@"."];
        if (groups.count > 0) {
            NSString *value = groups.firstObject;
            if (value.isNumber) {
                return value;
            } else {
                return @"0";
            }
        } else {
            return @"0";
        }
    }
    NSString *zeroString = @"1";
    for (int i = 0; i < decimals; i ++) {
        zeroString = [zeroString stringByAppendingString:@"0"];
    }
    NSDecimalNumber *value1 = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *value2 = [NSDecimalNumber decimalNumberWithString:zeroString];
    NSDecimalNumber *result = [value1 decimalNumberByMultiplyingBy:value2];
    NSArray<NSString *> *groups = [result.stringValue componentsSeparatedByString:@"."];
    if (groups.count > 0) {
        NSString *value = groups.firstObject;
        if (value.isNumber) {
            return value;
        } else {
            return @"0";
        }
    } else {
        return @"0";
    }
}

- (NSString *)zhh_decimalAddZeroToLength:(int)length {
    NSString *string = self;
    NSArray<NSString *> *groups = [string componentsSeparatedByString:@"."];
    if (groups.count == 1) {
        NSString *subString = groups[0];
        if (!subString.isInt) {
            return @"";
        }
        NSString *zeroString = @"";
        for (int i = 0; i < length; i ++) {
            zeroString = [zeroString stringByAppendingString:@"0"];
        }
        return [NSString stringWithFormat:@"%@.%@", subString, zeroString];
    } else if (groups.count == 2) {
        NSString *mainPart = groups[0];
        NSString *decimalPart = groups[1];
        if (!mainPart.isInt) {
            return @"";
        }
        if (!decimalPart.isInt) {
            return @"";
        }
        if (length <= 0) {
            return mainPart;
        }
        if (decimalPart.length > length) {
            decimalPart = [decimalPart substringToIndex:length];
            return [NSString stringWithFormat:@"%@.%@", mainPart, decimalPart];
        } else {
            NSString *zeroString = @"";
            for (int i = 0; i < length - decimalPart.length; i ++) {
                zeroString = [zeroString stringByAppendingString:@"0"];
            }
            return [NSString stringWithFormat:@"%@.%@%@", mainPart, decimalPart, zeroString];
        }
    }
    return @"";
}

- (NSString *)zhh_formatToDecimalWithDecimals:(int)decimals {
    NSString *string = self;
    if (!string.isNumber) {
        return @"";
    }
    NSArray<NSString *> *groups = [string componentsSeparatedByString:@"."];
    
    NSString *subString = groups[0];
    NSString *remainString = @"";
    if (groups.count == 2) {
        remainString = groups[1];
        if (!remainString.isInt) {
            return @"";
        }
    }
    if (!subString.isInt) {
        return @"";
    }
    if (decimals <= 0) {
        return string;
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray array];
    for (int i = 0; i < subString.length; i ++) {
        NSString *str = [subString substringWithRange:NSMakeRange(i, 1)];
        [strings addObject:str];
    }
    for (int i = 0; i < decimals * 2; i ++) {
        [strings insertObject:@"0" atIndex:0];
    }
    
    NSMutableArray<NSString *> *decimalParts = [NSMutableArray array];
    int step = 0;
    for (NSUInteger i = strings.count - 1; i >= 0; i --) {
        if (step + 1 > decimals) {
            break;
        }
        step ++;
        if (step <= decimals) {
            NSString *str = strings[i];
            [decimalParts insertObject:str atIndex:0];
        }
    }
    NSString *decimalPartString = [decimalParts componentsJoinedByString:@""];
    
    // 000000123
    // 000000000
    // 000010000
    NSArray<NSString *> *mainParts = [strings subarrayWithRange:NSMakeRange(0, strings.count - step)];
    NSString *mainPartString = [mainParts componentsJoinedByString:@""];
    while (1) {
        if ([mainPartString hasPrefix:@"0"]) {
            mainPartString = [mainPartString substringFromIndex:1];
        } else {
            break;
        }
    }
    if (mainPartString.length <= 0) {
        mainPartString = @"0";
    }
    return [NSString stringWithFormat:@"%@.%@%@", mainPartString, decimalPartString, remainString];
}
@end
