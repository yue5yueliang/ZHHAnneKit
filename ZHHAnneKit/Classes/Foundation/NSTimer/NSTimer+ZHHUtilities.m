//
//  NSTimer+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSTimer+ZHHUtilities.h"
#import <objc/runtime.h>

@implementation NSTimer (ZHHUtilities)

/**
 *  @brief 创建并调度一个定时器
 *
 *  @param interval 定时器的时间间隔（秒）
 *  @param repeats  是否重复执行（YES 表示重复执行，NO 表示仅触发一次）
 *  @param complete 定时器触发时的回调块，传递当前触发的定时器对象
 *
 *  @return 创建并调度的定时器对象
 */
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats complete:(void(^)(NSTimer *timer))complete {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(zhh_invokeTimerCallback:) userInfo:[complete copy] repeats:repeats];
}

/**
 *  @brief  创建一个需要手动添加到线程的 `NSTimer` 对象
 *
 *  @discussion 该方法创建的定时器不会自动添加到当前线程的 `RunLoop` 中。
 *  调用方需要手动通过 `addTimer:forMode:` 方法将定时器添加到指定的 `RunLoop` 模式。
 *
 *  @param interval 定时器的时间间隔（秒）
 *  @param repeats  是否重复执行（YES 表示重复，NO 表示只执行一次）
 *  @param complete 定时器触发时的回调块
 *
 *  @return 返回一个未调度的 `NSTimer` 对象
 */
+ (NSTimer *)zhh_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats complete:(void(^)(NSTimer *timer))complete {
    // 创建一个 NSTimer 对象，指定回调块作为 userInfo 确保 Block 安全存储
    return [NSTimer timerWithTimeInterval:interval target:self selector:@selector(zhh_invokeTimerCallback:) userInfo:[complete copy] repeats:repeats];
}

/**
 *  @brief 创建并调度一个定时器，并将其添加到指定的 RunLoop 模式中
 *
 *  @param interval   定时器的时间间隔（秒）
 *  @param repeats    是否重复执行（YES 表示重复，NO 表示只执行一次）
 *  @param complete   定时器触发时的回调块
 *  @param mode       定时器将被添加到的 RunLoop 模式
 *
 *  @return 创建并调度好的定时器对象
 */
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats complete:(void(^)(NSTimer *timer))complete runLoopMode:(NSRunLoopMode)mode {
    // 创建定时器对象（未自动添加到 RunLoop）确保 Block 的存储方式安全
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(zhh_invokeTimerCallback:) userInfo:[complete copy] repeats:repeats];
    
    // 手动将定时器添加到指定的 RunLoop 模式
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:mode];
    return timer;
}

/**
 *  @brief 定时器触发时的回调方法
 *
 *  @param timer 定时器对象
 */
+ (void)zhh_invokeTimerCallback:(NSTimer *)timer {
    // 从 userInfo 中提取回调块并执行
    void (^callback)(NSTimer *timer) = timer.userInfo;
    if (callback) {
        callback(timer);
    }
}

/// 立即触发定时器
- (void)zhh_triggerImmediately {
    if (![self isValid]) return; // 如果定时器无效，则不执行
    [self fire]; // 立即触发定时器
}

/// 暂停定时器
- (void)zhh_pause {
    if (![self isValid]) return; // 如果定时器无效，则不执行
    [self setFireDate:[NSDate distantFuture]]; // 暂停定时器，将触发时间设置为无限未来
}

/// 恢复定时器执行
- (void)zhh_resume {
    if (![self isValid]) return; // 如果定时器无效，则不执行
    [self setFireDate:[NSDate date]]; // 恢复定时器，将触发时间设置为当前时间
}

/// 延时恢复定时器
- (void)zhh_resumeAfterDelay:(NSTimeInterval)delay {
    if (![self isValid]) return; // 如果定时器无效，则不执行
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:delay]]; // 延迟指定时间后恢复定时器
}

/// 释放并无效化定时器
+ (void)zhh_invalidate:(NSTimer **)timer {
    if (timer && *timer) {
        [*timer invalidate]; // 使定时器无效
        *timer = nil;        // 清空调用方的定时器引用，避免悬挂指针
    }
}
@end
