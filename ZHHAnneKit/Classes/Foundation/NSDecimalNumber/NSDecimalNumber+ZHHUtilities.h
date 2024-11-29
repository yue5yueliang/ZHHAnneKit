//
//  NSDecimalNumber+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (ZHHUtilities)
/// 从 double 转换为 NSDecimalNumber
+ (NSDecimalNumber *)zhh_decimalNumberWithDouble:(double)doubles;

/// 从 double 转换为 float
+ (float)zhh_floatWithDouble:(double)doubles;

/// 从 double 转换为 double
+ (double)zhh_doubleWithDouble:(double)doubles;

/// 从 double 转换为字符串
+ (NSString *)zhh_stringWithDouble:(double)doubles;

/// 从 double 转换为带单位的字符串
+ (NSString *)zhh_stringWithDouble:(double)doubles unit:(NSString *)unit;

/// 通用乘法方法，两个字符串形式的数字
+ (NSString *)zhh_multiplyStr1:(NSString *)str1 str2:(NSString *)str2;

/// 通用减法方法，两个字符串形式的数字
+ (NSString *)zhh_subtractingModelStr1:(NSString *)str1 str2:(NSString *)str2;

/// 通用计算方法，处理乘法、减法等运算
+ (NSString *)zhh_calculateWithStr1:(NSString *)str1 str2:(NSString *)str2 operation:(NSDecimalNumber * (^)(NSDecimalNumber *, NSDecimalNumber *))operation;
@end

NS_ASSUME_NONNULL_END
