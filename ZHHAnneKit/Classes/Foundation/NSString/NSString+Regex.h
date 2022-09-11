//
//  NSString+Regex.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regex)
/// 是否包含该数据
/// @param regex 匹配元素
- (BOOL)zhh_matchWithRegex:(NSString *)regex;

/// 正则匹配
/// @param regex 匹配元素
- (NSString *)zhh_partStringWithRegex:(NSString *)regex;

/// 正则匹配
/// @param regex 匹配元素
- (NSArray<NSString *> *)zhh_checkStringArrayWithRegex:(NSString *)regex;
@end

NS_ASSUME_NONNULL_END
