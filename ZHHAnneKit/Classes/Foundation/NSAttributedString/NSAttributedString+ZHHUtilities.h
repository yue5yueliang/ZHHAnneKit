//
//  NSAttributedString+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZHHUtilities)

/**
 *  @brief 获取字符串的完整范围
 *
 *  @discussion
 *  此方法返回当前字符串的完整范围，范围起点为 0，长度为字符串的字符总数。
 *  常用于需要对整个字符串进行操作的场景，例如正则表达式匹配、文本替换等。
 *
 *  @return 包含字符串所有字符的范围，若字符串为空，则范围为 (0, 0)。
 */
- (NSRange)zhh_rangeOfAll;
@end

NS_ASSUME_NONNULL_END
