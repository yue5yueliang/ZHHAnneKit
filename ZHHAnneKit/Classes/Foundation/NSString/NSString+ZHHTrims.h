//
//  NSString+ZHHTrims.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHTrims)
/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)zhh_stringByStrippingHTML;
/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)zhh_stringByRemovingScriptsAndStrippingHTML;
/**
 *  @brief  去除空格
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)zhh_trimmingWhitespace;
/**
 *  @brief  去除字符串与空行
 *
 *  @return 去除字符串与空行的字符串
 */
- (NSString *)zhh_trimmingWhitespaceAndNewlines;
/// 去掉最后一个字符串如", ."
- (NSString *)zhh_removeLastString;
/// 去掉结尾指定的子字符串
- (NSString *)zhh_removeLastSubString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
