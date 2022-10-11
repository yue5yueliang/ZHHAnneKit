//
//  NSData+ZHHAPNSToken.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSData+ZHHAPNSToken.h"

@implementation NSData (ZHHAPNSToken)
/**
 *  @brief  将APNS NSData类型token 格式化成字符串
 *
 *  @return 字符串token
 */
- (NSString *)zhh_APNSToken {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![self isKindOfClass:[NSData class]]) {
            return @"";
        }
        NSUInteger len = [self length];
        char *chars = (char *)[self bytes];
        NSMutableString *hexString = [[NSMutableString alloc]init];
        for (NSUInteger i=0; i<len; i++) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx" , chars[i]]];
        }
        return hexString;
    } else {
         NSString *myToken = [[self description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        return myToken;
    }
}
@end
