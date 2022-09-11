//
//  NSDecimalNumber+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSDecimalNumber+ZHHKit.h"

@implementation NSDecimalNumber (ZHHKit)
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
    return [NSString stringWithFormat:@"%@%@",unit,decimalNumber];;
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
