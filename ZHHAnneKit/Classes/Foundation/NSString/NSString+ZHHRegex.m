//
//  NSString+ZHHRegex.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHRegex.h"

@implementation NSString (ZHHRegex)
/// 是否包含该数据
/// @param regex 匹配元素
- (BOOL)zhh_matchWithRegex:(NSString *)regex{
    if (self == nil) return NO;
    NSError *error = NULL;
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:options
                                                                                  error:&error];
    NSTextCheckingResult *result = [expression firstMatchInString:self
                                                          options:NSMatchingReportProgress
                                                            range:NSMakeRange(0, [self length])];
    return result != nil;
}

/// 正则匹配
/// @param regex 匹配元素
- (NSString *)zhh_partStringWithRegex:(NSString *)regex{
    if (self == nil) return nil;
    NSError *error = NULL;
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    NSTextCheckingResult *result = [expression firstMatchInString:self
                                                          options:NSMatchingReportProgress
                                                            range:NSMakeRange(0, [self length])];
    return result ? [self substringWithRange:result.range] : nil;
}

/// 正则匹配
/// @param regex 匹配元素
- (NSArray<NSString *> *)zhh_checkStringArrayWithRegex:(NSString *)regex{
    if (self == nil) return nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    NSArray * matches = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray * __autoreleasing array = [NSMutableArray array];
    for (NSTextCheckingResult * match in matches) {
        NSString * matchString = @"";
        if (match.range.location != NSNotFound) {
            matchString = [self substringWithRange:match.range];
        }
        [array addObject:matchString];
    }
    return [array copy];
}
@end
