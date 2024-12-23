//
//  NSDate+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDate+ZHHUtilities.h"
#import <sys/sysctl.h>

@implementation NSDate (ZHHUtilities)
/// 将日期转化为本地时间
- (NSDate *)zhh_localeDate {
    // 获取当前系统的时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算当前日期相对于 GMT 的时区偏移量（单位：秒）
    NSInteger interval = [zone secondsFromGMTForDate:self];
    // 根据时区偏移量将日期转换为本地时间
    NSDate *localeDate = [self dateByAddingTimeInterval:interval];
    return localeDate;
}

/// 获取当前时间戳（自1970年1月1日起的秒数）
+ (NSTimeInterval)zhh_currentUnixTimestamp {
    return [[NSDate date] timeIntervalSince1970];
}

/// 获取当前时间的字符串（类方法）
/// @return 返回当前时间字符串，格式为："HH:mm:ss"
+ (NSString *)zhh_currentTime {
    return [self zhh_currentDateStringWithFormat:@"HH:mm:ss"];
}

/// 获取当前时间的字符串（类方法）
/// @return 返回当前日期字符串，格式为："yyyy-MM-dd"
+ (NSString *)zhh_currentDate {
    return [self zhh_currentDateStringWithFormat:@"yyyy-MM-dd"];
}

/// 获取当前时间的字符串（类方法）
/// @return 返回当前日期和时间的字符串，格式为："yyyy-MM-dd HH:mm:ss"
+ (NSString *)zhh_currentDateTime {
    return [self zhh_currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

/// 将当前日期转换成指定格式的时间字符串（类方法）
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回格式化后的当前时间字符串
+ (NSString *)zhh_currentDateStringWithFormat:(NSString *)format {
    // 调用实例方法，将当前日期转化为指定格式的字符串
    return [[NSDate date] zhh_stringWithFormat:format];
}

/// 将 NSDate 转换成指定格式的时间字符串（类方法）
/// @param date 要转换的日期
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回格式化后的时间字符串
+ (NSString *)zhh_stringFromDate:(NSDate *)date format:(NSString *)format {
    return [date zhh_stringWithFormat:format];
}

/// 获取共享的日期格式化器
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 配置好的共享 NSDateFormatter 对象
+ (NSDateFormatter *)zhh_sharedDateFormatterWithFormat:(NSString *)format {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]]; // 设置为系统默认区域
    });
    // 每次设置日期格式，确保使用最新的格式
    [formatter setDateFormat:format];
    return formatter;
}

/// 将当前日期转换为指定格式的时间字符串（实例方法）
/// @param format 时间格式字符串，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回格式化后的时间字符串
- (NSString *)zhh_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDate zhh_sharedDateFormatterWithFormat:format];
    return [formatter stringFromDate:self];
}

/// 将时间字符串转换为NSDate对象（类方法）
/// @param dateString 需要转换的时间字符串，例如："2024-09-08 14:30:00"
/// @param format 时间字符串的格式，例如："yyyy-MM-dd HH:mm:ss"
/// @return 返回对应的NSDate对象，如果转换失败，返回nil
+ (NSDate *)zhh_dateFromString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [self zhh_sharedDateFormatterWithFormat:format];
    return [formatter dateFromString:dateString];
}

/**
 *  将日期字符串从一种格式转换为另一种格式
 *  @param datetime 要转换的日期字符串，例如："2024-09-08 14:30:00"
 *  @param sourceFormat 输入日期字符串的格式，例如："yyyy-MM-dd HH:mm:ss"
 *  @param targetFormat 目标日期格式，例如："yyyy/MM/dd"
 *  @return 返回目标格式的日期字符串；如果转换失败，返回空字符串
 */
+ (NSString *)zhh_reformatDateString:(NSString *)datetime fromFormat:(NSString *)sourceFormat toFormat:(NSString *)targetFormat {
    // 检查输入是否为空
    if (!datetime || datetime.length == 0 || !sourceFormat || !targetFormat) {
        return @"";
    }
    
    // 创建并设置源日期格式的 NSDateFormatter
    NSDateFormatter *sourceFormatter = [[NSDateFormatter alloc] init];
    [sourceFormatter setDateFormat:sourceFormat];
    
    // 将输入的日期字符串转换为 NSDate 对象
    NSDate *date = [sourceFormatter dateFromString:datetime];
    if (!date) {
        NSLog(@"输入的日期字符串无法解析：%@，格式：%@", datetime, sourceFormat);
        return @"";
    }
    
    // 创建并设置目标日期格式的 NSDateFormatter
    NSDateFormatter *targetFormatter = [[NSDateFormatter alloc] init];
    [targetFormatter setDateFormat:targetFormat];
    
    // 将 NSDate 对象转换为目标格式的字符串
    return [targetFormatter stringFromDate:date];
}

/// 将 NSDate 转换为时间戳（支持秒级或毫秒级）
/// @param date 要转换的 NSDate 对象
/// @return 返回时间戳（秒级或毫秒级），如果 date 为 nil，返回 0
+ (NSInteger)zhh_timestampFromDate:(NSDate *)date {
    if (!date) {
        NSLog(@"日期参数为 nil，无法转换为时间戳");
        return 0;
    }
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    // 判断并返回对应的时间戳
    return timeInterval > 1000000000 ? (NSInteger)(timeInterval * 1000) : (NSInteger)timeInterval;
}

/// 将时间戳转换为 NSDate
/// @param timestamp 要转换的时间戳（支持秒级或毫秒级）
/// @return 对应的 NSDate 对象。如果时间戳为负数，则返回1970年起始时间。
+ (NSDate *)zhh_dateFromTimestamp:(NSInteger)timestamp {
    if (timestamp < 0) {
        NSLog(@"警告: 输入的时间戳为负数 (%ld)，将返回1970年起始时间", (long)timestamp);
        return [NSDate dateWithTimeIntervalSince1970:0];
    }

    // 判断是否为毫秒级时间戳（通常超过1000000000000为毫秒级）
    NSTimeInterval adjustedTimestamp = (timestamp > 1000000000000) ? timestamp / 1000.0 : timestamp;

    return [NSDate dateWithTimeIntervalSince1970:adjustedTimestamp];
}

/// 将时间字符串按指定格式转换为时间戳 (秒级)
/// @param timeString 要转换的时间字符串，例如："2024-09-08 12:34:56"
/// @param format 时间字符串的格式，例如："yyyy-MM-dd HH:mm:ss"
/// @return 转换后的时间戳 (秒级整数)，如果转换失败，返回 0
+ (NSInteger)zhh_secondsTimestampFromTimeString:(NSString *)timeString withFormat:(NSString *)format {
    // 检查输入参数
    if (!timeString || !format) {
        NSLog(@"无效的输入: timeString 或 format 为空");
        return 0; // 返回默认值
    }

    // 创建日期格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];

    // 设置时区为亚洲/北京
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];

    // 根据时间字符串和格式转换为 NSDate 对象
    NSDate *date = [formatter dateFromString:timeString];
    if (!date) {
        NSLog(@"日期格式化失败: timeString=%@, format=%@", timeString, format);
        return 0; // 转换失败返回 0
    }

    // 将 NSDate 转换为时间戳
    return [self zhh_timestampFromDate:date];
}

/// 将时间戳转换为指定格式的时间字符串
/// @param timestamp 时间戳（支持秒级或毫秒级）
/// @param format 时间格式字符串，例如 @"yyyy-MM-dd HH:mm:ss"
/// @return 格式化后的时间字符串，若输入无效则返回空字符串
+ (NSString *)zhh_timeStringFromTimestamp:(NSTimeInterval)timestamp format:(NSString *)format {
    // 检查格式是否有效
    if (!format || [format isEqualToString:@""]) {
        NSLog(@"格式字符串为空，无法格式化时间戳");
        return @"";
    }

    // 实例化日期格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    
    // 判断时间戳单位并进行转换（毫秒级时间戳 > 1000000000000）
    if (timestamp > 1000000000000) {
        timestamp /= 1000;
    }

    // 创建日期对象
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    // 返回格式化后的时间字符串
    return [formatter stringFromDate:date];
}

/// 将 UTC 时间字符串转换为时间戳
/// @param timeString UTC 时间字符串，格式可以是 @"yyyy-MM-dd'T'HH:mm:ss" 或 @"yyyy-MM-dd'T'HH:mm:ss.SSS"
/// @return 转换后的时间戳（秒），如果转换失败则返回 0
+ (NSTimeInterval)zhh_timestampUTCWithTimeString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    // 根据时间字符串的格式设置日期格式
    if ([timeString containsString:@"."]) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    NSDate *date = [formatter dateFromString:timeString];
    
    // 检查日期转换是否成功
    if (!date) {
        NSLog(@"警告: 时间字符串格式不正确或无法转换: %@", timeString);
        return 0; // 转换失败，返回 0
    }
    
    return [date timeIntervalSince1970];
}

/// 判断两个日期是否在同一周
/// @param date 要比较的日期
/// @return YES 表示在同一周，NO 表示不在同一周
- (BOOL)zhh_isSameWeekAsDate:(NSDate *)date {
    if (!date) {
        NSLog(@"输入日期为 nil，无法进行比较");
        return NO;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 2; // 设置星期一为一周的起始日（可根据需求调整）
    
    // 比较两个日期是否在同一周
    return [calendar isDate:self equalToDate:date toUnitGranularity:NSCalendarUnitWeekOfYear];
}

/// 判断两个日期是否是同一天
- (BOOL)zhh_isSameDayAsDate:(NSDate *)date {
    if (!date) {
        NSLog(@"日期参数为 nil，无法进行比较");
        return NO;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDate:self inSameDayAsDate:date];
}

/// 使用蔡勒公式获取当前日期是周几（1-7）
/// 1 表示星期一，7 表示星期日
- (NSInteger)zhh_weekDay {
    // 获取年、月、日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    
    // 蔡勒公式的修正数组
    static int benchmark[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if (month < 3) {
        year -= 1; // 前移一年（1月和2月视为上一年的13月和14月）
    }
    NSInteger weekDay = (year + year / 4 - year / 100 + year / 400 + benchmark[month - 1] + day) % 7;
    
    // 如果计算结果为 0，将其调整为 7（表示星期日）
    return weekDay == 0 ? 7 : weekDay;
}

/// 获取当前周的周末日期（默认周末为星期日）
/// @return 本周周末的 NSDate 对象
- (NSDate *)zhh_weekendDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 设置周起始日为星期一
    calendar.firstWeekday = 2;
    
    // 获取当前日期的星期偏移量
    NSDateComponents *weekdayComp = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger daysToWeekend = 8 - weekdayComp.weekday; // 假设周日为周末

    // 创建一个日期偏移量
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = daysToWeekend;

    // 返回计算后的周末日期
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/// 获取当月的天数
- (NSUInteger)zhh_daysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

/// 返回当前日期的所在月份的第一天日期
- (NSDate *)zhh_monthFristDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [components setDay:1];
    return [calendar dateFromComponents:components];
}

/// 获取当月最后一天
- (NSDate *)zhh_monthLastDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDayOfMonth = [self zhh_monthFristDay];
    
    // 获取下个月第一天
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *firstDayOfNextMonth = [calendar dateByAddingComponents:components toDate:firstDayOfMonth options:0];
    
    // 获取下个月第一天的前一天
    components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [calendar dateByAddingComponents:components toDate:firstDayOfNextMonth options:0];
}

/// 获取当前日期前后几天的日期
/// @param offsetDays 偏移天数，正数表示获取过去几天的日期，负数表示获取未来几天的日期
/// @param formatter 日期格式，例如："yyyy-MM-dd"
/// @return 返回指定格式的日期字符串
- (NSString *)zhh_dateByOffsetDays:(NSInteger)offsetDays formatter:(NSString *)formatter {
    // 计算日期偏移
    NSDate *newDate = [self dateByAddingTimeInterval:offsetDays * 24 * 60 * 60];
    
    // 创建日期格式化器并设置格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    
    // 返回格式化后的日期字符串
    return [dateFormatter stringFromDate:newDate];
}

/// 获取当前日期偏移指定月份后的日期
/// @param offsetMonths 偏移月份，正数表示获取未来几个月的日期，负数表示获取过去几个月的日期
/// @param formatter 日期格式，例如："yyyy-MM-dd"
/// @return 返回偏移后的日期字符串，按指定格式
- (NSString *)zhh_dateByOffsetMonths:(NSInteger)offsetMonths formatter:(NSString *)formatter {
    // 使用NSCalendar来计算偏移月份后的日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:offsetMonths];
    
    // 获取偏移后的日期
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:self options:0];
    
    // 格式化日期并返回字符串
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:newDate];
}

/// 判断当前时间是否在指定的时间段内（格式为 yyyy-MM-dd HH:mm:ss）
/// @param startDateTime 开始时间，格式为 "yyyy-MM-dd HH:mm:ss"
/// @param endDateTime 结束时间，格式为 "yyyy-MM-dd HH:mm:ss"
/// @return 是否在指定时间段内
+ (BOOL)zhh_isCurrentTimeInRange:(NSString *)startDateTime endDateTime:(NSString *)endDateTime {
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 创建并设置日期格式化器（复用）
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    // 将传入的 startDateTime 和 endDateTime 转换为 NSDate 对象
    NSDate *start = [dateFormatter dateFromString:startDateTime];
    NSDate *end = [dateFormatter dateFromString:endDateTime];
    
    // 判断当前时间是否在开始时间和结束时间之间
    if ([currentDate compare:start] == NSOrderedDescending && [currentDate compare:end] == NSOrderedAscending) {
        return YES;
    }
    
    return NO;
}

/**
 *  获取两个时间的差值
 *
 *  @param startTime 开始时间，格式为 "yyyy-MM-dd HH:mm:ss"
 *  @param endTime 结束时间，格式为 "yyyy-MM-dd HH:mm:ss"
 *  @return 返回时间差的 `NSDateComponents` 对象，包含年、月、日、小时、分钟和秒
 */
+ (NSDateComponents *)zhh_dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    // 1. 创建日期格式化器
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }

    // 2. 将时间字符串转换为 NSDate 对象
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *date2 = [formatter dateFromString:endTime];

    // 3. 使用当前日历计算时间差
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    // 4. 获取时间差
    NSDateComponents *cmps = [calendar components:units fromDate:date1 toDate:date2 options:0];

    // 5. 输出时间差（可选）
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", (long)cmps.year, (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute, (long)cmps.second);

    return cmps;
}

/**
 * 比较两个日期字符串的大小
 *
 * @param date01 第一个日期字符串
 * @param date02 第二个日期字符串
 * @param formatter 日期格式，如 @"yyyy-MM-dd HH:mm"
 * @return 比较结果：0（相等），1（date01 大于 date02），-1（date01 小于 date02）
 */
+ (int)zhh_compareDate:(NSString *)date01 withDate:(NSString *)date02 formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    
    NSDate *dt01 = [dateFormatter dateFromString:date01];
    NSDate *dt02 = [dateFormatter dateFromString:date02];
    
    // 检查日期是否有效
    if (!dt01 || !dt02) {
        NSLog(@"日期格式不匹配或无效日期: %@, %@", date01, date02);
        return -2; // 返回 -2 代表日期无效或格式不匹配
    }
    
    NSComparisonResult result = [dt01 compare:dt02];
    switch (result) {
        case NSOrderedAscending: return -1; // dt01 < dt02
        case NSOrderedDescending: return 1; // dt01 > dt02
        case NSOrderedSame: return 0; // dt01 == dt02
    }
    
    // 默认返回值（理论上不会到达这里）
    return 0;
}

/// 获取系统自上次启动以来的运行时间（以秒为单位）。
/// @return 系统运行时间（秒），若获取失败返回 -1
+ (NSTimeInterval)timeSinceSystemBoot {
    // 定义变量存储当前时间戳
    struct timeval now;
    struct timezone tz;
    
    // 获取当前设备的时间戳（受用户手动调整时间的影响）
    gettimeofday(&now, &tz);
    
    // 定义变量存储系统启动时间戳
    struct timeval boottime;
    // 设置 sysctl 获取启动时间的参数
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    
    // 初始化返回值，默认为 -1 表示获取失败
    double uptime = -1;
    
    // 调用 sysctl 获取系统启动时间戳
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        // 成功获取系统启动时间
        // 计算从启动到当前的秒数差值
        uptime = now.tv_sec - boottime.tv_sec;
        
        // 计算从启动到当前的微秒数差值，并转换为秒
        uptime += (double)(now.tv_usec - boottime.tv_usec) / 1000000.0;
    }
    
    // 返回系统运行时间，若失败则返回 -1
    return uptime;
}
@end
