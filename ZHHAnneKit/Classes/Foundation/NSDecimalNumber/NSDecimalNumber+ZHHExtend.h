//
//  NSDecimalNumber+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (ZHHExtend)
// doubles->float
+ (float)zhh_floatWithDouble:(double)doubles;

// doubles->double
+ (double)zhh_doubleWithDouble:(double)doubles;

// 主要使用这两个方法，先把类型转成double
// doubles->NSString
+ (NSString *)zhh_stringWithDouble:(double)doubles;

// doubles->NSString-￥
+ (NSString *)zhh_stringWithDouble:(double)doubles unit:(NSString *)unit;

// doubles->NSDecimalNumber
+ (NSDecimalNumber *)zhh_decimalNumberWithDouble:(double)doubles;

// +
+ (NSString *)zhh_multiplyStr1:(NSString *)str1 str2:(NSString *)str2;
// -
+ (NSString *)zhh_subtractingModelStr1:(NSString *)str1 str2:(NSString *)str2;
@end

NS_ASSUME_NONNULL_END
