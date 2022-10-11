//
//  NSDate+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDate+ZHHExtend.h"

@implementation NSDate (ZHHExtend)
#pragma mark - 获取当前的时间
+ (NSString *)zhh_currentDateString {
    return [self zhh_currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)zhh_currentDateStringWithFormat:(NSString *)formatterStr{
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

/**
 //     和当前时间比较
 //     1）1分钟以内 显示        :    刚刚
 //     2）1小时以内 显示        :    X分钟前
 //     3）当前时间之前或者昨天 显示      :    今天 09:30   昨天 09:30
 //     4）当前时间之前或者明天 显示      :    今天 09:30   明天 09:30
 //     5) 今年显示              :   09月12日
 //     6) 大于本年      显示    :    2013/09/09
 //
 //     @param dateString @"2016-04-04 20:21"
 //     @param formatter  @"YYYY-MM-dd hh:mm"
 //     hh与HH的区别:分别表示12小时制,24小时制
 */
+ (NSString *)zhh_formateDate:(NSString *)dateString formatter:(NSString *)formatter{
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatter];
        
        NSDate * nowDate = [NSDate date];
        //  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        //  取当前时间和转换时间两个日期对象的时间间隔
        //  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        // 再然后，把间隔的秒数折算成天数和小时数：
        NSString *dateStr = @"";
        if (time < 0) {
            if (time >= -60*60*24) {
                dateStr = @"明天";
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
                NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                if ([need_yMd isEqualToString:now_yMd]) {
                    //在同一天
                    dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
                }else{
                    //明天天
                    dateStr = [NSString stringWithFormat:@"明天 %@",[dateFormatter stringFromDate:needFormatDate]];
                }
            }else{
                [dateFormatter setDateFormat:@"yyyy"];
                NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
                NSString *nowYear = [dateFormatter stringFromDate:nowDate];
                
                if ([yearStr isEqualToString:nowYear]) {
                    ////  在同一年
                    [dateFormatter setDateFormat:@"MM月dd日"];
                    dateStr = [dateFormatter stringFromDate:needFormatDate];
                }else{
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    dateStr = [dateFormatter stringFromDate:needFormatDate];
                }
            }
        } else if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        }else if(time<=60*60*24){   //// 在两天内的
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    } @catch (NSException *exception) {
        return @"";
    }
}

/**
 *  判断两个日期的大小
 *  date01 : 第一个日期
 *  date02 : 第二个日期
 *  format : 日期格式 如：@"yyyy-MM-dd HH:mm"
 *  return : 0（等于）1（大于）-1（小于）
 */
+ (int)zhh_compareDate:(NSString*)date01 withDate:(NSString*)date02 toDateFormat:(NSString*)format{
    int num;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSDate*dt01 = [[NSDate alloc]init];
    NSDate*dt02 = [[NSDate alloc]init];

    dt01 = [df dateFromString:date01];
    dt02 = [df dateFromString:date02];
    
    NSComparisonResult result = [dt01 compare:dt02];
    switch(result){
        case NSOrderedAscending: num=1;break;
        case NSOrderedDescending: num=-1;break;
        case NSOrderedSame: num=0;break;
        default:
            NSLog(@"erorr dates %@, %@", dt02, dt01);
            break;
    }
    return num;
}
@end
