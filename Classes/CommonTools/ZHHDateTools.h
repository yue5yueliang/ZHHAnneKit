//
//  ZHHDateTools.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHDateModel : NSObject
@property(nonatomic, copy)NSString* beginDate;
@property(nonatomic, copy)NSString* endDate;
@end

@interface ZHHDateTools : NSObject
#pragma mark ------------ 日期相关的处理 ----------------------------
/** 当前时间是否在某个时间段内 (忽略年月日《格式为 02:22》) */
+ (BOOL)zhh_judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime;

/** 当前时间是否在某个时间段内 (格式为 2020-09-25 09:00:00) */
+ (BOOL)zhh_judgeTimeByStartAndEnd:(NSString *)startDateTime endDateTime:(NSString *)endDateTime;

/// 获取指定月的第一天和最后一天
+ (NSString *)zhh_getMonthBeginAndEndWith:(NSDate *)newDate dateFormatter:(NSString *)dateFormatter;
/// 获取月首和月尾的字符串日期
+ (ZHHDateModel *)zhh_getMonthBeginAndEndDateTime:(NSDate *)newDate;
/// 获取当前月的上月下月日期
+ (NSDate*)zhh_getPriousorLaterDateFromDate:(NSDate*)date withMonth:(int)month;

/** 返回本周开始时间和结束时间
 * @param number 0为当前周 小于0位本周以前的周 大于0位本周以后的周
 * @param formatter 返回日期时间的格式 如:yyyy-MM-dd HH:mm:ss
 */
+ (ZHHDateModel *)zhh_backToPassedTimeWithWeeksNumber:(NSInteger)number formatter:(NSString *)formatter;

/** 获取当前系统指定的格式日期时间 */
+ (NSString*)zhh_currentDateTime:(NSString *)dateFormatter;

/**
 *  根据日期时间获得多少分钟后的时间
 *  @param hourMinutes 需要转换的日期时间 如 21:29
 *  @param minutes 多少分钟后
 */
+ (NSString *)zhh_newDateTime:(NSString *)hourMinutes minutes:(NSInteger)minutes;
/**
 *  根据时分转换成日期时间格式，最后转成时间戳
 *  @param hourMinutes 需要转换的日期时间 如 21:29
 *  @param seconds 需要转换的日期时间 如 开始为00，截止为59
 *  返回时间戳
 */
+ (NSTimeInterval)zhh_newDateTimetamp:(NSString *)hourMinutes seconds:(NSString *)seconds;
/**
 *  多少分钟后的时间戳
 *  @param timetamp 时间戳
 *  @param minutes 多少分钟后
 *  返回时间戳
 */
+ (NSTimeInterval)zhh_howManyMinutesAfter:(NSTimeInterval)timetamp minutes:(NSInteger)minutes;
/**
 *  检查日期是否是今日
 *  @param datetime 日期时间
 *  返回否是今日
 */
+ (BOOL)zhh_checkTheDateIsToday:(NSString *)datetime;
/**
 *  时间戳转换为时间
 *
 *  @param timeString 时间戳
 *  @param formatter 设置时间戳h转时间的格式 如 @"yyyy-MM-dd HH:mm:ss"
 *  @param isJetlag 是否需要加上时差28800
 *  @return 返回字符串格式时间
 */
+ (NSString *)zhh_timeWithTimeIntervalString:(NSString *)timeString formatter:(NSString *)formatter isJetlag:(BOOL)isJetlag;
/**
 *  获取当前系统时间
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)zhh_currentTime;

/**
 *  获取当前系统日期
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)zhh_currentDate;
/**
 *  获取n天后的日期
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)zhh_n_dayDate:(int)days isShowTime:(BOOL)isShowTime;
/** 获取当前时间的时间戳 */
+ (NSString *)zhh_currentTimestamp;

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
+ (NSInteger)zhh_getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr;
/**
 *  时间转时间戳
 *  dateTime 日期时间
 *  @return 时间戳
 */
+ (NSInteger)zhh_getDateTimeWithTimetamp:(NSString*)dateTime;

/**
 *  将数字转换为 时、分、秒、
 *
 *  @param totalSecond 时间转换
 *
 *  @return 返回字符串格式
 */
+ (NSString *)zhh_timeFormatter:(int)totalSecond;

/**
 *  两个时间差
 *
 *  @param startTime 开始时间
 *  @param endTime 结束时间
 *  @return 时间差
 */
+ (NSDateComponents *)zhh_dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */
+ (BOOL)zhh_judgeTimeByStartTime:(NSString *)startTime endTime:(NSString *)expireTime;

/// 获取时间
+ (NSString *)zhh_getYMDSWith:(NSString *)time;
@end

NS_ASSUME_NONNULL_END
