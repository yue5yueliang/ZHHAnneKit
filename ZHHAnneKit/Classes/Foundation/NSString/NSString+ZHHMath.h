//
//  NSString+ZHHMath.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数学运算符；算术操作符
@interface NSString (ZHHMath)

/// 它是空的吗
@property (nonatomic, assign, readonly) BOOL isEmpty;
/// 非空安全处理
@property (nonatomic, assign, readonly) NSString *safeString;

/// 尺寸比较
- (NSComparisonResult)zhh_compare:(NSString *)string;
/// 加法运算
- (NSString *)zhh_adding:(NSString *)string;
/// 减法运算
- (NSString *)zhh_subtract:(NSString *)string;
/// 乘法运算
- (NSString *)zhh_multiply:(NSString *)string;
/// 除法运算
- (NSString *)zhh_divide:(NSString *)string;
/// 指数计算
- (NSString *)zhh_multiplyingByPowerOf10:(NSInteger)oxff;
/// Power operation
- (NSString *)zhh_raisingToPower:(NSInteger)oxff;

/// 转换成十进制
- (double)zhh_calculateDoubleValue;

/// 保留整数部分，100.0130=>100
- (NSString *)zhh_retainInteger;

/// 删除尾部为“0”或“的数字` （如:10.000 => 10 or 10.100 => 10.1）
- (NSString *)zhh_removeTailZero;

/// 保留小数点后几位，四舍五入到两位数如下 (如:10.00001245 => 10.00 or 120.026 => 120.03)
extern NSString * kStringFractionDigits(NSDecimalNumber * number, NSUInteger digits);
+ (NSString *)zhh_fractionDigits:(double)value digits:(NSUInteger)digits;

/// 保留小数点，直接删除小数点的多余部分
+ (NSString *)zhh_retainDigits:(double)value digits:(int)digits;

/// 保留几个有效的小数位，保留两位数字，(如:10.00001245 => 10.000012 or 120.02 => 120.02 or 10.000 => 10)
extern NSString * kStringReservedValidDigit(NSDecimalNumber * value, NSInteger digit);
+ (NSString *)zhh_reservedValidDigit:(double)value digit:(int)digit;

/// 双精度损耗修复
- (NSString *)zhh_doublePrecisionRevise;
+ (NSString *)zhh_doublePrecisionReviseWithDouble:(double)conversionValue;

@property (nonatomic, assign, readonly) BOOL isNumber;
@property (nonatomic, assign, readonly) BOOL isInt;
@property (nonatomic, assign, readonly) BOOL isFloat;

/// 将大单位转换为小单位
/// [@"1.1" zhh_parseToUInt64WithDecimals: 5] => @"110000"
- (NSString *)zhh_parseToIntStringWithDecimals:(int)decimals;

/// 在小数点后添加“0”
/// [@"1.2" zhh_decimalAddZeroToLength:5] => @"1.20000"
- (NSString *)zhh_decimalAddZeroToLength:(int)length;

/// 将小单位转换为大单位
/// [@"200" zhh_formatToDecimalWithDecimals:5] => @"0.002"
/// [@"1.2" zhh_decimalAddZeroToLength:5] => @"0.000012"
- (NSString *)zhh_formatToDecimalWithDecimals:(int)decimals;
@end

NS_ASSUME_NONNULL_END
