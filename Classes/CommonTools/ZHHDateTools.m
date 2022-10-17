//
//  ZHHDateTools.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHDateTools.h"

@implementation ZHHDateModel

@end

@implementation ZHHDateTools
/** 当前时间是否在某个时间段内 (忽略年月日《格式为 02:22》) */
+ (BOOL)zhh_judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:today];//将日期转换成字符串
    today = [formatter dateFromString:dateString];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [formatter dateFromString:startTime];
    NSDate *expire = [formatter dateFromString:expireTime];

    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/** 当前时间是否在某个时间段内 (格式为 2020-09-25 09:00:00) */
+ (BOOL)zhh_judgeTimeByStartAndEnd:(NSString *)startDateTime endDateTime:(NSString *)endDateTime{
    //获取当前时间
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"yyyy:mm:HH:mm:ss"];
    NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
    today = [ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //start end 格式 "2016-05-18 9:00:00"
    NSDate *start = [dateFormat dateFromString:startDateTime];
    NSDate *expire = [dateFormat dateFromString:endDateTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/// 获取指定月的第一天和最后一天
+ (NSString *)zhh_getMonthBeginAndEndWith:(NSDate *)newDate dateFormatter:(NSString *)dateFormatter{
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd"];
//    NSDate *newDate=[format dateFromString:dateText];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:dateFormatter];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return s;
}

/// 获取月首和月尾的字符串日期
+ (ZHHDateModel *)zhh_getMonthBeginAndEndDateTime:(NSDate *)newDate{
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    ZHHDateModel *baseModel = [[ZHHDateModel alloc] init];

    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    baseModel.beginDate = [myDateFormatter stringFromDate:beginDate];

    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        baseModel.endDate = [myDateFormatter stringFromDate:endDate];
    }else {
        baseModel.endDate = @"";
    }
    return baseModel;
}

/// 获取当前月的上月下月日期
+ (NSDate*)zhh_getPriousorLaterDateFromDate:(NSDate*)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    // NSGregorianCalendar
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate*mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

/** 返回本周开始时间和结束时间
 * @param number 0为当前周 小于0位本周以前的周 大于0位本周以后的周
 * @param formatter 返回日期时间的格式 如:yyyy-MM-dd HH:mm:ss
 */
+ (ZHHDateModel *)zhh_backToPassedTimeWithWeeksNumber:(NSInteger)number formatter:(NSString *)formatter{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:7 * 24 * 3600 * number];
    //滚动后，算出当前日期所在的周（周一－周日）
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSInteger daycount = [comp weekday] - 2;
    
    NSDate *weekdaybegin=[date dateByAddingTimeInterval:-daycount*60*60*24];
    NSDate *weekdayend = [date dateByAddingTimeInterval:(6-daycount)*60*60*24];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekdaybegin];
    NSDateComponents *components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekdayend];
    
    NSDate *startDate = [calendar dateFromComponents:components];//这个不能改
    
    NSDate *startDate1 = [calendar dateFromComponents:components1];
    NSDate *endDate1 = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate1 options:0];
    
    //获取今天0点到明天0点的时间
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:formatter];
    NSString *monday = [formatter1 stringFromDate:startDate];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:formatter];
    NSString *sunday = [formatter2 stringFromDate:endDate1];
    
    ZHHDateModel *baseModel = [[ZHHDateModel alloc] init];
    baseModel.beginDate = monday;
    baseModel.endDate = sunday;
    return baseModel;
}

/** 获取当前系统指定的格式日期时间 */
+ (NSString*)zhh_currentDateTime:(NSString *)dateFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormatter];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"当前指定格式日期时间===%@",dateTime);
    return dateTime;
}

/**
 *  根据日期时间获得多少分钟后的时间
 *  @param hourMinutes 需要转换的日期时间 如 21:29
 *  @param minutes 多少分钟后
 */
+ (NSString *)zhh_newDateTime:(NSString *)hourMinutes minutes:(NSInteger)minutes{
    /// 获取当前日期
    NSString *currentDateText = [self zhh_currentDate];
    /// 拼接日期和时间的格式时间
    NSString *newDateText = [NSString stringWithFormat:@"%@ %@:00",currentDateText,hourMinutes];
    /// 将日期转换成时间戳
    NSTimeInterval timetamp = [self zhh_getDateTimeWithTimetamp:newDateText];
    /// 将时间戳减去时差的8小时+多少分钟后
    NSTimeInterval interval = timetamp + minutes * 60;//因为时差问题要减去8小时 == 28800 sec 再加上多少分钟后
    /// 将计算好的时间戳转换成指定格式的时间
    NSString *dateTimeText = [self zhh_timeWithTimeIntervalString:[NSString stringWithFormat:@"%f",interval] formatter:@"HH:mm" isJetlag:NO];
    return dateTimeText;
}

/**
 *  根据时分转换成日期时间格式，最后转成时间戳
 *  @param hourMinutes 需要转换的日期时间 如 21:29
 *  @param seconds 需要转换的日期时间 如 开始为00，截止为59
 *  返回时间戳
 */
+ (NSTimeInterval)zhh_newDateTimetamp:(NSString *)hourMinutes seconds:(NSString *)seconds{
    /// 获取当前日期
    NSString *currentDateText = [self zhh_currentDate];
    /// 拼接日期和时间的格式时间
    NSString *newDateText = [NSString stringWithFormat:@"%@ %@:%@",currentDateText,hourMinutes,seconds];
    /// 将日期转换成时间戳
    NSTimeInterval timetamp = [self zhh_getDateTimeWithTimetamp:newDateText];
    return timetamp;
}

/**
 *  多少分钟后的时间戳
 *  @param timetamp 时间戳
 *  @param minutes 多少分钟后
 *  返回时间戳
 */
+ (NSTimeInterval)zhh_howManyMinutesAfter:(NSTimeInterval)timetamp minutes:(NSInteger)minutes{
    NSTimeInterval interval = timetamp + minutes * 60;
    return interval;
}

/**
 *  检查日期是否是今日
 *  @param datetime 日期时间
 *  返回否是今日
 */
+ (BOOL)zhh_checkTheDateIsToday:(NSString *)datetime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:datetime];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    return isToday;
}

/**
 *  时间戳转换为时间
 *
 *  @param timeString 时间戳
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)zhh_timeWithTimeIntervalString:(NSString *)timeString formatter:(NSString *)formatter isJetlag:(BOOL)isJetlag{
    
    NSTimeInterval interval = [timeString doubleValue] + 28800;//因为时差问题要加8小时 == 28800 sec
    if (!isJetlag) {
        interval = interval - 28800;
    }
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:interval];
    //    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    //    NDLog(@"时间戳转换后的日期时间:%@",currentDateStr);
    return currentDateStr;
}

/**
 *  获取当前系统时间
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)zhh_currentTime {
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"当前时间是===%@",dateTime);
    // 输出currentDateStr
    return dateTime;
}

/**
 *  获取当前系统日期
 *
 *  @return 返回字符串格式时间
 */
+ (NSString*)zhh_currentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/**
 *  获取n天后的日期
 *
 *  @return 返回字符串格式时间
 */
+ (NSString*)zhh_n_dayDate:(int)days isShowTime:(BOOL)isShowTime{
    NSDate *appointDate;    // 指定日期声明
    NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
    NSDate *currentDate = [NSDate date];
    appointDate = [currentDate initWithTimeIntervalSinceNow:oneDay * days];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (isShowTime) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *dateTime = [formatter stringFromDate:appointDate];
    return dateTime;
}

/** 获取当前时间的时间戳 */
+ (NSString*)zhh_currentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
//    NSLog(@"当前时间是时间戳===%@",timeString);
    return timeString;
}


/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
+ (NSInteger)zhh_getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    NSInteger timeDifference = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    return timeDifference;
}

/**
 *  时间转时间戳
 *  dateTime 日期时间
 *  @return 时间戳
 */
+ (NSInteger)zhh_getDateTimeWithTimetamp:(NSString*)dateTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:dateTime];
    NSTimeInterval timetamp = [nowDate timeIntervalSince1970];
    return timetamp;
}

/**
 *  将数字转换为 时、分、秒、
 *
 *  @param totalSeconds 时间转换
 *
 *  @return 返回字符串格式
 */
+ (NSString *)zhh_timeFormatter:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}

/**
 *  两个时间差
 *
 *  @param startTime 开始时间
 *  @param endTime 结束时间
 *  @return 时间差
 */
+ (NSDateComponents *)zhh_dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    // 1.确定时间
//        NSString *time1 = @"2017-11-22 12:18:15";
//        NSString *time2 = @"2020-11-23 10:10:10";
    // 2.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *date2 = [formatter dateFromString:endTime];
    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 5.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", (long)cmps.year, (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute, (long)cmps.second);
    return cmps;
}

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */
+ (BOOL)zhh_judgeTimeByStartTime:(NSString *)startTime endTime:(NSString *)expireTime{
    // 当前时间是否在时间段内 (完整时间)
    // 获取当前时间
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //start end 格式 "2016-05-18 9:00:00"
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/// 时间转换
+ (NSString *)zhh_getYMDSWith:(NSString *)time{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *birthdayDate = [dateFormatter dateFromString:time];
    NSDate *newDate = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnitType = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:calendarUnitType fromDate:birthdayDate toDate:newDate options:0];

    
    if (cmps.year > 0){
        return [self zhh_getYearWith:time];
    }else if (cmps.month > 0 || cmps.day > 2){
        return [self zhh_getMonthWith:time];
       
    }else if (cmps.day > 2){
        return [self zhh_getMonthWith:time];
    }else if (cmps.day == 2){
        return [NSString stringWithFormat:@"前天%@",[self zhh_getHourWith:time]];
    }else if (cmps.day == 1){
        return [NSString stringWithFormat:@"昨天%@",[self zhh_getHourWith:time]];
    }else if (cmps.hour > 0){
        return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
    }else if (cmps.minute > 0){
        return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
    }else{
        return @"刚刚";
    }
}

+ (NSString *)zhh_getYearWith:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *birthdayDate = [dateFormatter dateFromString:time];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    return [newDateFormatter stringFromDate:birthdayDate];
}

+ (NSString *)zhh_getMonthWith:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *birthdayDate = [dateFormatter dateFromString:time];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [newDateFormatter stringFromDate:birthdayDate];
}

+ (NSString *)zhh_getHourWith:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *birthdayDate = [dateFormatter dateFromString:time];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:@"HH:mm"];
    return [newDateFormatter stringFromDate:birthdayDate];
}
@end
