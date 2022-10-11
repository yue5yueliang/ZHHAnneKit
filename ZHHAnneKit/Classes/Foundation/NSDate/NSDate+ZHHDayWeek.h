//
//  NSDate+ZHHDayWeek.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZHHDayWeek)
/// 是昨天吗
@property (nonatomic, assign, readonly) BOOL isYesterday;

/// 是同一周吗
- (BOOL)zhh_weekSameDate:(NSDate *)date;

/// 是否同一天
- (BOOL)zhh_daySameDate:(NSDate *)date;

/// 蔡勒公式获取周几，返回1 - 7
- (NSInteger)zhh_weekDay;

/// 返回当前周的周末日期
- (NSDate *)zhh_weekendDate;

/// 本月多少天
- (NSUInteger)zhh_monthHowDays;

/// 获取当月最后一天
- (NSDate *)zhh_monthFristDay;

/// 获取当月最后一天
- (NSDate *)zhh_monthLastDay;

/// 获取今日前后几天的日期
/// @param day days before and after
/// @param format time format
- (NSString *)zhh_skewingDay:(NSInteger)day format:(NSString *)format;

/// 获取今天偏移几月的日期
/// @param month The number of months before and after
/// @param format time format
- (NSString *)zhh_skewingMonth:(NSInteger)month format:(NSString *)format;
@end

NS_ASSUME_NONNULL_END
