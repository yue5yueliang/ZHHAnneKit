//
//  NSDecimalNumber+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDecimalNumber+ZHHExtend.h"

@implementation NSDecimalNumber (ZHHExtend)
+ (float)zhh_floatWithDouble:(double)doubles {
    return [[self zhh_decimalNumberWithDouble:doubles] floatValue];
}

+ (double)zhh_doubleWithDouble:(double)doubles {
    return [[self zhh_decimalNumberWithDouble:doubles] doubleValue];
}

+ (NSString *)zhh_stringWithDouble:(double)doubles {
    return [[self zhh_decimalNumberWithDouble:doubles] stringValue];
}

+ (NSString *)zhh_stringWithDouble:(double)doubles unit:(NSString *)unit{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber zhh_decimalNumberWithDouble:doubles];
    return [NSString stringWithFormat:@"%@%@",unit,decimalNumber];
}

+ (NSDecimalNumber *)zhh_decimalNumberWithDouble:(double)doubles {
    NSString *numString = [NSString stringWithFormat:@"%lf", doubles];
    return [NSDecimalNumber decimalNumberWithString:numString];
}

+ (NSString *)zhh_multiplyStr1:(NSString *)str1 str2:(NSString *)str2 {
    if (str1.length == 0) {
        str1 = @"0";
    }
    if (str2.length == 0) {
        str2 = @"0";
    }
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:str1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:str2];
    NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
    return [result stringValue];
}

+ (NSString *)zhh_subtractingModelStr1:(NSString *)str1 str2:(NSString *)str2 {
    if (str1.length == 0) {
        str1 = @"0";
    }
    if (str2.length == 0) {
        str2 = @"0";
    }
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:str1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:str2];
    NSDecimalNumber *result = [decimalNumber1 decimalNumberBySubtracting:decimalNumber2];
    return [NSString stringWithFormat:@"%@",result];
}
@end
