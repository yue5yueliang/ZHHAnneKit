//
//  NSDate+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZHHExtend)
/** 获取当前的时间 */
+ (NSString *)zhh_currentDateString;
/** 获取当前的时间自定义格式 */
+ (NSString *)zhh_currentDateStringWithFormat:(NSString *)formatterStr;
/**
 //     和当前时间比较
 //     1）1分钟以内 显示        :    刚刚
 //     2）1小时以内 显示        :    X分钟前
 //     3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 //     4）当前时间之前或者明天 显示      :    今天 09:30   明天 09:30
 //     5) 今年显示              :   09月12日
 //     6) 大于本年      显示    :    2013/09/09
 //
 //     @param dateString @"2016-04-04 20:21"
 //     @param formatter  @"YYYY-MM-dd HH:mm"
 //     hh与HH的区别:分别表示12小时制,24小时制
 **/
+ (NSString *)zhh_formateDate:(NSString *)dateString formatter:(NSString *)formatter;

/**
 *  判断两个日期的大小
 *  date01 : 第一个日期
 *  date02 : 第二个日期
 *  format : 日期格式 如：@"yyyy-MM-dd HH:mm"
 *  return : 0（等于）1（大于）-1（小于）
 */
+ (int)zhh_compareDate:(NSString *)date01 withDate:(NSString *)date02 toDateFormat:(NSString*)format;

@end

NS_ASSUME_NONNULL_END
