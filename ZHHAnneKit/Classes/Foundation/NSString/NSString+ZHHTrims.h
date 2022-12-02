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
/// 将点赞、浏览等大额数以w为单位展示
- (NSString *)zhh_formatBrowse;
/// 将点金额(分)兑换成元
- (NSString *)zhh_formatYuan;
/// 过滤器/ 将.2f格式化的字符串，去除末尾0(小数点后超过3位自动四舍五入)
- (NSString *)zhh_formatAmount;
@end

NS_ASSUME_NONNULL_END
