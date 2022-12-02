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

#pragma mark 去掉最后一个字符串如", ."
- (NSString *)zhh_removeLastString{
    if([self length] > 0){
        return [self substringToIndex:([self length]-1)];//去掉最后一个字符串如", ."
    }else{
        return self;
    }
}

#pragma mark 去掉结尾指定的子字符串
- (NSString *)zhh_removeLastSubString:(NSString *)string {
    NSString *result = self;
    if ([result hasSuffix:string]) {
        result = [result substringToIndex:self.length - string.length];
        result = [result zhh_removeLastSubString:string];
    }
    return result;
}

- (NSString *)zhh_formatBrowse {
    NSInteger count = self.integerValue;
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }else if(count < 100000000) {
        return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
    }else {
        return [NSString stringWithFormat:@"%.1f亿",count/100000000.0f];
    }
}

/// 将点金额(分)兑换成元
- (NSString *)zhh_formatYuan{
    return [NSString stringWithFormat:@"%.2f",self.floatValue / 100.f];
}

/**
 *  过滤器/ 将.2f格式化的字符串，去除末尾0(小数点后超过3位自动四舍五入)
 */
- (NSString *)zhh_formatAmount{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    NSString *numberStr = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.floatValue]];
    if (numberStr.length > 1) {
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return nil;
    }
}

@end
