//
//  NSString+ZHHContains.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHContains)
/**
 *  是否包含中文
 */
- (BOOL)zhh_isContainChinese;
/**
 *  @brief  是否包含空格
 */
- (BOOL)zhh_isContainBlank;

/**
 *  @brief  Unicode编码的字符串转成NSString
 */
- (NSString *)zhh_makeUnicodeToString;

- (BOOL)zhh_containsCharacterSet:(NSCharacterSet *)set;
/**
 *  @brief 是否包含字符串
 *
 *  @param string 字符串
 *
 *  @return YES, 包含;
 */
- (BOOL)zhh_containsaString:(NSString *)string;
/**
 *  @brief 获取字符数量
 */
- (int)zhh_wordsCount;
@end

NS_ASSUME_NONNULL_END
