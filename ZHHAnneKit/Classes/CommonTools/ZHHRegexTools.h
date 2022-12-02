//
//  ZHHRegexTools.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHRegexTools : NSObject
/** 邮箱正则判断 */
+ (BOOL)zhh_checkEmail:(NSString *)object;
/// 正则匹配手机号
+ (BOOL)zhh_checkPhoneNumber:(NSString *)object;
/// 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)zhh_checkPassword:(NSString *)object;
/// 正则匹配用户姓名,20位的中文或英文
+ (BOOL)zhh_checkUserName:(NSString *)object;
/// 正则匹配用户身份证号
+ (BOOL)zhh_checkUserIdCard:(NSString *)object;
/// 正则匹配验证码为4位数字
+ (BOOL)zhh_checkValidationCode:(NSString *)object;
@end

NS_ASSUME_NONNULL_END
