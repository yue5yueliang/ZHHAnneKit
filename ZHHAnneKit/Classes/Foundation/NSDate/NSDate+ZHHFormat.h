//
//  NSDate+ZHHFormat.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZHHFormat)
/// 将日期转化为本地时间
- (NSDate *)zhh_localeDate;

/// 当前date转换成时间字符串 (+方法)
+ (NSString *)zhh_stringWithFormat:(NSString *)format;

/// 将date转换成时间字符串 (NSDate => TimeString)
+ (NSString *)zhh_stringWithDate:(NSDate *)date format:(NSString *)format;

/**
 将时间字符串转换成date (TimeString ==> NSDate)
 Example:
 NSString *string = @"2017-09-15";
 NSDate *date = [NSDate dateWithString:string format:@"yyyy-MM-dd"];
 */
+ (NSDate *)zhh_dateWithString:(NSString *)dateString format:(NSString *)format;
/**
 *  日期字符串转指定格式字符串日期
 *  @param datetime 需要设置的时间
 *  @param formatter 格式
 *  @return 返回指定格式字符串
 */
+ (NSString *)zhh_formatterDateTime:(NSString *)datetime formatter:(NSString *)formatter;

/// 将date转换成时间戳 (NSDate => Timestamp)
+ (NSInteger)zhh_timestampFromDate:(NSDate *)date;

/// 将时间戳转换成date (Timestamp => NSDate)
+ (NSDate *)zhh_dateFromTimestamp:(NSInteger)timestamp;
/**
 将时间字符串转换成时间戳 (TimeString => Timestamp) / 北京时间
 Example:
 NSString *timeString = @"2017-09-15 15:39";
 NSInteger timestamp = [NSDate timestampFromTimeString:timeString formatter:@"yyyy-MM-dd HH:mm"];
 */
+ (NSInteger)zhh_timestampFromTimeString:(NSString *)timeString formatter:(NSString *)format;

/// 将时间戳转换成时间字符串 (Timestamp => TimeString) / 北京时间
+ (NSString *)zhh_timeStringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)format;

/// 获取当前时间戳（无论是毫秒）
+ (NSTimeInterval)zhh_currentTimetampWithMsec:(BOOL)msec;

/// 时间戳到时间，内部判断为毫秒或秒
/// @param timestamp timestamp
/// @param format time format
+ (NSString *)zhh_timeWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format;

/// 获取指定时间的UTC时间戳
/// @param timeString specifies the time
+ (NSTimeInterval)zhh_timeStampUTCWithTimeString:(NSString *)timeString;

@end

NS_ASSUME_NONNULL_END
