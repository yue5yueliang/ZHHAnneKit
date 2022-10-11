//
//  ZHHRegexTools.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHRegexTools.h"

@implementation ZHHRegexTools
/** 邮箱正则判断 */
+ (BOOL)zhh_checkEmail:(NSString *)email{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:email];
}
@end
