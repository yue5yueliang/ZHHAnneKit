//
//  NSNumber+ZHHRomanNumerals.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (ZHHRomanNumerals)
/**
 *
 *  A category on NSNumber that returns the value as a roman numeral
 *
 *  @return 罗马数字格式的字符串
 */
- (NSString *)zhh_romanNumeral;
@end

NS_ASSUME_NONNULL_END
