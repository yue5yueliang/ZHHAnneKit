//
//  NSDecimalNumber+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDecimalNumber+ZHHUtilities.h"

@implementation NSDecimalNumber (ZHHUtilities)
/// 从 double 转换为 NSDecimalNumber
+ (NSDecimalNumber *)zhh_decimalNumberWithDouble:(double)doubles {
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", doubles]];
}

/// 从 double 转换为 float
+ (float)zhh_floatWithDouble:(double)doubles {
    return [[self zhh_decimalNumberWithDouble:doubles] floatValue];
}

/// 从 double 转换为 double
+ (double)zhh_doubleWithDouble:(double)doubles {
    return [[self zhh_decimalNumberWithDouble:doubles] doubleValue];
}

/// 从 double 转换为字符串
+ (NSString *)zhh_stringWithDouble:(double)doubles {
    return [[self zhh_decimalNumberWithDouble:doubles] stringValue];
}

/// 从 double 转换为带单位的字符串
+ (NSString *)zhh_stringWithDouble:(double)doubles unit:(NSString *)unit {
    NSDecimalNumber *decimalNumber = [self zhh_decimalNumberWithDouble:doubles];
    return [NSString stringWithFormat:@"%@%@", decimalNumber, unit];
}

/// 通用乘法方法，两个字符串形式的数字
+ (NSString *)zhh_multiplyStr1:(NSString *)str1 str2:(NSString *)str2 {
    return [self zhh_calculateWithStr1:str1 str2:str2 operation:^NSDecimalNumber *(NSDecimalNumber *decimal1, NSDecimalNumber *decimal2) {
        return [decimal1 decimalNumberByMultiplyingBy:decimal2];
    }];
}

/// 通用减法方法，两个字符串形式的数字
+ (NSString *)zhh_subtractingModelStr1:(NSString *)str1 str2:(NSString *)str2 {
    return [self zhh_calculateWithStr1:str1 str2:str2 operation:^NSDecimalNumber *(NSDecimalNumber *decimal1, NSDecimalNumber *decimal2) {
        return [decimal1 decimalNumberBySubtracting:decimal2];
    }];
}

/// 通用计算方法，处理乘法、减法等运算
+ (NSString *)zhh_calculateWithStr1:(NSString *)str1 str2:(NSString *)str2 operation:(NSDecimalNumber * (^)(NSDecimalNumber *, NSDecimalNumber *))operation {
    // 检查字符串是否为空，如果为空则视为 0
    str1 = str1.length == 0 ? @"0" : str1;
    str2 = str2.length == 0 ? @"0" : str2;
    
    // 创建 NSDecimalNumber 实例
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:str1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:str2];
    
    // 执行传入的操作
    NSDecimalNumber *result = operation(decimalNumber1, decimalNumber2);
    
    // 返回计算结果的字符串
    return [result stringValue];
}
@end
