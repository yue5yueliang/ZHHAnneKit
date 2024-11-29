//
//  NSException+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSException (ZHHUtilities)
/// @brief 获取当前线程的调用栈信息
/// @discussion 此方法生成当前线程的调用栈信息，返回一个字符串数组，其中每个元素代表调用栈中的一个符号。
/// @return 包含调用栈符号的字符串数组
- (NSArray *)zhh_backtrace;
@end

NS_ASSUME_NONNULL_END
