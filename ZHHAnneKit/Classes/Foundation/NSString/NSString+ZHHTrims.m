//
//  NSString+ZHHTrims.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHTrims.h"

@implementation NSString (ZHHTrims)
/**
 *  @brief  清除html标签
 *
 *  @return 清除后的结果
 */
- (NSString *)zhh_stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}
/**
 *  @brief  清除js脚本
 *
 *  @return 清楚js后的结果
 */
- (NSString *)zhh_stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString zhh_stringByStrippingHTML];
}
/**
 *  @brief  去除空格
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)zhh_trimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
/**
 *  @brief  去除字符串与空行
 *
 *  @return 去除字符串与空行的字符串
 */
- (NSString *)zhh_trimmingWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  去掉最后一个字符串如", ."
 */
+ (NSString *)zhh_removeTheLastOneStr:(NSString*)string{
    if([string length] > 0){
        return [string substringToIndex:([string length]-1)];//去掉最后一个字符串如", ."
    }else{
        return string;
    }
}

/**
 *  移除结尾的子字符串
 */
- (NSString *)zhh_removeLastSubString:(NSString *)string {
    NSString *result = self;
    if ([result hasSuffix:string]) {
        result = [result substringToIndex:self.length - string.length];
        result = [result zhh_removeLastSubString:string];
    }
    return result;
}
@end
