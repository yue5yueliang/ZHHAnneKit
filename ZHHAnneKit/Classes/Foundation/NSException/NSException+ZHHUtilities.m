//
//  NSException+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSException+ZHHUtilities.h"
#include <execinfo.h>

@implementation NSException (ZHHUtilities)
/**
 * @brief 获取当前线程的调用栈信息
 *
 * @discussion 此方法生成当前线程的调用栈信息，返回一个字符串数组，其中每个元素代表调用栈中的一个符号。
 *
 * @return 包含调用栈符号的字符串数组
 */
- (NSArray *)zhh_backtrace {
    // 获取当前线程的调用栈地址
    NSArray *addresses = self.callStackReturnAddresses;
    unsigned count = (unsigned)addresses.count;

    // 为调用栈地址分配内存空间
    void **stack = malloc(count * sizeof(void *));
    if (!stack) {
        return @[]; // 如果分配失败，返回空数组
    }

    // 将调用栈地址保存到指针数组中
    for (unsigned i = 0; i < count; ++i) {
        stack[i] = (void *)[addresses[i] longValue];
    }

    // 获取调用栈符号
    char **symbols = backtrace_symbols(stack, count);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];

    // 将符号信息转换为NSString并存入结果数组
    for (unsigned i = 0; i < count; ++i) {
        if (symbols[i]) {
            [result addObject:@(symbols[i])];
        }
    }

    // 释放分配的内存
    free(stack);
    free(symbols);

    // 返回调用栈符号数组
    return result;
}
@end
