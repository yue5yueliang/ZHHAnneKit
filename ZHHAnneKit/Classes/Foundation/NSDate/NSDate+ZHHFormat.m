//
//  NSDate+ZHHFormat.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDate+ZHHFormat.h"

@implementation NSDate (ZHHFormat)
/// 将日期转化为本地时间
- (NSDate *)zhh_localeDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *localeDate = [self dateByAddingTimeInterval:interval];
    return localeDate;
}

/// 当前date转换成时间字符串 (+方法)
+ (NSString *)zhh_stringWithFormat:(NSString *)format{
    return [[NSDate date] zhh_stringWithFormat:format];
}

- (NSString *)zhh_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

/// 将date转换成时间字符串 (NSDate => TimeString)
+ (NSString *)zhh_stringWithDate:(NSDate *)date format:(NSString *)format{
    return [date zhh_stringWithFormat:format];
}

/// 将时间字符串转换成date (TimeString ==> NSDate)
+ (NSDate *)zhh_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

/**
 *  日期字符串转指定格式字符串日期
 *  @param datetime 需要设置的时间
 *  @param formatter 格式
 *  @return 返回指定格式字符串
 */
+ (NSString *)zhh_formatterDateTime:(NSString *)datetime formatter:(NSString *)formatter{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 要转换的日期字符串
    NSString *dateString = datetime;
    // NSDate形式的日期
    NSDate *date = [formatter1 dateFromString:dateString];

    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatter];
    NSString *dateString2 = [formatter2 stringFromDate:date];
    return dateString2;
}

// (NSDate => Timestamp)
+ (NSInteger)zhh_timestampFromDate:(NSDate *)date {
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
}

// (Timestamp => NSDate)
+ (NSDate *)zhh_dateFromTimestamp:(NSInteger)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

// (TimeString => Timestamp)
+ (NSInteger)zhh_timestampFromTimeString:(NSString *)timeString formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    // 将字符串按formatter转成NSDate
    NSDate *date = [formatter dateFromString:timeString];
    return [self zhh_timestampFromDate:date];
}

// (Timestamp => TimeString)
+ (NSString *)zhh_timeStringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *timeDate = [self zhh_dateFromTimestamp:timestamp];
    return [formatter stringFromDate:timeDate];
}

/// 获取当前时间戳，是否为毫秒
+ (NSTimeInterval)zhh_currentTimetampWithMsec:(BOOL)msec{
    return [[NSDate date] timeIntervalSince1970] * (msec ? 1000 : 1);
}
/// 时间戳转时间，内部判断是毫秒还是秒
+ (NSString *)zhh_timeWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSString * string = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:timestamp]];
    NSDecimalNumber * decimalA = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber * decimalB = [NSDecimalNumber decimalNumberWithString:@"1000000000000"];//毫秒量级
    NSDecimalNumber * decimalC = [NSDecimalNumber decimalNumberWithString:@"1000"];
    if ([decimalA compare:decimalB] == NSOrderedDescending) {// timestamp > 1000000000000，毫秒
        timestamp = [[decimalA decimalNumberByDividingBy:decimalC] doubleValue];
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [formatter stringFromDate:date];
}

+ (NSTimeInterval)zhh_timeStampUTCWithTimeString:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    if ([timeString containsString:@"."]) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return [[formatter dateFromString:timeString] timeIntervalSince1970];
}
@end
