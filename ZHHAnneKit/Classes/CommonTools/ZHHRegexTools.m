//
//  ZHHRegexTools.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHRegexTools.h"

@implementation ZHHRegexTools
+ (BOOL)zhh_regexWithObject:(NSString *)object regex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:object];
}
/** 邮箱正则判断 */
+ (BOOL)zhh_checkEmail:(NSString *)object{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self zhh_regexWithObject:object regex:regex];
}

/// 正则匹配手机号
+ (BOOL)zhh_checkPhoneNumber:(NSString *)object {
    NSString *regex = @"^1[34578]\\d{9}$";
    return [self zhh_regexWithObject:object regex:regex];
}

#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)zhh_checkPassword:(NSString *)object {
    NSString *regex = @"^[a-zA-Z0-9]{6,18}+$";
    return [self zhh_regexWithObject:object regex:regex];
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)zhh_checkUserName:(NSString *)object {
    NSString *regex = @"^[\u4e00-\u9fa5]{4,8}$";
    return [self zhh_regexWithObject:object regex:regex];
}

#pragma 正则匹配用户身份证号14或17位
+ (BOOL)zhh_checkUserIdCard:(NSString *)object {
    BOOL flag;
    if (object.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self zhh_regexWithObject:object regex:regex];
}

#pragma 正则匹配验证码为4位数字
+ (BOOL)zhh_checkValidationCode:(NSString *)object{
    BOOL flag;
    if (object.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex = @"^\\d{4}$";
    return [self zhh_regexWithObject:object regex:regex];
}
@end
