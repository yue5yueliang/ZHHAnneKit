//
//  NSDate+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZHHUtilities)
/// 将日期转化为本地时间
- (NSDate *)zhh_localeDate;

/// 获取当前时间戳（自1970年1月1日起的秒数）
/// @return 返回当前时间的时间戳（NSTimeInterval）
+ (NSTimeInterval)zhh_currentUnixTimestamp;

/// 获取当前时间的字符串（类方法）
/// @return 返回当前时间字符串，格式为："HH:mm:ss"
+ (NSString *)zhh_currentTime;

/// 获取当前时间的字符串（类方法）
/// @return 返回当前日期字符串，格式为："yyyy-MM-dd"
+ (NSString *)zhh_currentDate;

/// 获取当前时间的字符串（类方法）
/// @return 返回当前日期和时间的字符串，格式为："yyyy-MM-dd HH:mm:ss"
+ (NSString *)zhh_currentDateTime;

/// 将当前日期转换成指定格式的时间字符串（类方法）
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回格式化后的时间字符串
+ (NSString *)zhh_currentDateStringWithFormat:(NSString *)format;

/// 将 NSDate 转换成指定格式的时间字符串（类方法）
/// @param date 要转换的日期
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回格式化后的时间字符串
+ (NSString *)zhh_stringFromDate:(NSDate *)date format:(NSString *)format;

/// 获取共享的日期格式化器
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 配置好的共享 NSDateFormatter 对象
+ (NSDateFormatter *)zhh_sharedDateFormatterWithFormat:(NSString *)format;

/// 将当前日期转换为指定格式的时间字符串（实例方法）
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回格式化后的时间字符串
- (NSString *)zhh_stringWithFormat:(NSString *)format;

/// 将时间字符串转换为NSDate对象（类方法）
/// @param dateString 需要转换的时间字符串，例如："2024-09-08 14:30:00"
/// @param format 时间字符串的格式，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回对应的NSDate对象，如果转换失败，返回nil
+ (NSDate *)zhh_dateFromString:(NSString *)dateString format:(NSString *)format;

/**
 *  将日期字符串从一种格式转换为另一种格式
 *  @param datetime 要转换的日期字符串，例如："2024-09-08 14:30:00"
 *  @param sourceFormat 输入日期字符串的格式，例如："yyyy-MM-dd HH:mm:ss"
 *  @param targetFormat 目标日期格式，例如："yyyy/MM/dd"
 *  @return 返回目标格式的日期字符串；如果转换失败，返回空字符串
 */
+ (NSString *)zhh_reformatDateString:(NSString *)datetime fromFormat:(NSString *)sourceFormat toFormat:(NSString *)targetFormat;

/// 将 NSDate 转换为时间戳（支持秒级或毫秒级）
/// @param date 要转换的 NSDate 对象
/// @return 返回时间戳（秒级或毫秒级），如果 date 为 nil，返回 0
+ (NSInteger)zhh_timestampFromDate:(NSDate *)date;

/// 将时间戳转换为 NSDate
/// @param timestamp 要转换的时间戳（支持秒级或毫秒级）
/// @return 对应的 NSDate 对象。如果时间戳为负数，则返回1970年起始时间。
+ (NSDate *)zhh_dateFromTimestamp:(NSInteger)timestamp;

/// 将时间字符串按指定格式转换为时间戳 (秒级)
/// @param timeString 要转换的时间字符串，例如："2024-09-08 12:34:56"
/// @param format 时间字符串的格式，例如："yyyy-MM-dd HH:mm:ss"
/// @return 转换后的时间戳 (秒级整数)，如果转换失败，返回 0
+ (NSInteger)zhh_secondsTimestampFromTimeString:(NSString *)timeString withFormat:(NSString *)format;

/// 将时间戳转换为指定格式的时间字符串
/// @param timestamp 时间戳（支持秒级或毫秒级）
/// @param format 时间格式字符串，例如 @"yyyy-MM-dd HH:mm:ss"
/// @return 格式化后的时间字符串，若输入无效则返回空字符串
+ (NSString *)zhh_timeStringFromTimestamp:(NSTimeInterval)timestamp format:(NSString *)format;

/// 将 UTC 时间字符串转换为时间戳
/// @param timeString UTC 时间字符串，格式可以是 @"yyyy-MM-dd'T'HH:mm:ss" 或 @"yyyy-MM-dd'T'HH:mm:ss.SSS"
/// @return 转换后的时间戳（秒），如果转换失败则返回 0
+ (NSTimeInterval)zhh_timestampUTCWithTimeString:(NSString *)timeString;

/// 判断两个日期是否在同一周
/// @param date 要比较的日期
/// @return YES 表示在同一周，NO 表示不在同一周
/// NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:1704374400]; // 2024-01-06 (周六)
/// NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:1704460800]; // 2024-01-07 (周日)
/// BOOL isSameWeek = [date1 zhh_isSameWeekAsDate:date2];
/// NSLog(@"是否在同一周: %@", isSameWeek ? @"YES" : @"NO");
- (BOOL)zhh_isSameWeekAsDate:(NSDate *)date;

/// 判断两个日期是否是同一天
/// NSDate *date1 = [NSDate date];
/// NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:3600]; // 当前时间后一小时
/// BOOL isSameDay = [date1 zhh_isSameDayAsDate:date2];
/// NSLog(@"是否是同一天: %@", isSameDay ? @"YES" : @"NO");
- (BOOL)zhh_isSameDayAsDate:(NSDate *)date;

/// 使用蔡勒公式获取当前日期是周几（1-7）
/// 1 表示星期一，7 表示星期日
- (NSInteger)zhh_weekDay;

/// 获取当前周的周末日期（默认周末为星期日）
/// @return 本周周末的 NSDate 对象
- (NSDate *)zhh_weekendDate;

/// 获取当月的天数
- (NSUInteger)zhh_daysInMonth;

/// 返回当前日期的所在月份的第一天日期
- (NSDate *)zhh_monthFristDay;

/// 返回当前日期的所在月份的最后一天日期
- (NSDate *)zhh_monthLastDay;

/// 获取当前日期前后几天的日期
/// @param offsetDays 偏移天数，正数表示获取过去几天的日期，负数表示获取未来几天的日期
/// @param formatter 日期格式，例如："yyyy-MM-dd"
/// @return 返回指定格式的日期字符串
- (NSString *)zhh_dateByOffsetDays:(NSInteger)offsetDays formatter:(NSString *)formatter;

/// 获取当前日期偏移指定月份后的日期
/// @param offsetMonths 偏移月份，正数表示获取未来几个月的日期，负数表示获取过去几个月的日期
/// @param formatter 日期格式，例如："yyyy-MM-dd"
/// @return 返回偏移后的日期字符串，按指定格式
- (NSString *)zhh_dateByOffsetMonths:(NSInteger)offsetMonths formatter:(NSString *)formatter;

/// 判断当前时间是否在指定的时间段内（格式为 yyyy-MM-dd HH:mm:ss）
/// @param startDateTime 开始时间，格式为 "yyyy-MM-dd HH:mm:ss"
/// @param endDateTime 结束时间，格式为 "yyyy-MM-dd HH:mm:ss"
/// @return 是否在指定时间段内
+ (BOOL)zhh_isCurrentTimeInRange:(NSString *)startDateTime endDateTime:(NSString *)endDateTime;

/// 获取两个时间的差值
/// @param startTime 开始时间，格式为 "yyyy-MM-dd HH:mm:ss" NSString *time1 = @"2017-11-22 12:18:15";
/// @param endTime 结束时间，格式为 "yyyy-MM-dd HH:mm:ss" NSString *time2 = @"2020-11-23 10:10:10";
/// @return 返回时间差的 `NSDateComponents` 对象，包含年、月、日、小时、分钟和秒
+ (NSDateComponents *)zhh_dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 * 比较两个日期字符串的大小
 *
 * @param date01 第一个日期字符串
 * @param date02 第二个日期字符串
 * @param formatter 日期格式，如 @"yyyy-MM-dd HH:mm"
 * @return 比较结果：0（相等），1（date01 大于 date02），-1（date01 小于 date02）
 */
+ (int)zhh_compareDate:(NSString *)date01 withDate:(NSString *)date02 formatter:(NSString *)formatter;

/// 获取系统自上次启动以来的运行时间（以秒为单位）。
/// @return 系统运行时间（秒），若获取失败返回 -1
+ (NSTimeInterval)timeSinceSystemBoot;
@end

NS_ASSUME_NONNULL_END
