//
//  NSTimer+ZHHExtend.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZHHExtend)
/**
 *  @brief 创建并调度一个定时器
 *
 *  @param interval 定时器的时间间隔（秒）
 *  @param repeats  是否重复执行（YES 表示重复执行，NO 表示仅触发一次）
 *  @param complete 定时器触发时的回调块，传递当前触发的定时器对象
 *
 *  @return 创建并调度的定时器对象
 */
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats complete:(void(^)(NSTimer *timer))complete;
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
+ (NSTimer *)zhh_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats complete:(void(^)(NSTimer *timer))complete;
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
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats complete:(void(^)(NSTimer *timer))complete runLoopMode:(NSRunLoopMode)mode;

/// 立即触发定时器
- (void)zhh_triggerImmediately;

/// 暂停定时器
- (void)zhh_pause;

/// 恢复定时器执行
- (void)zhh_resume;

/// 延时恢复定时器
- (void)zhh_resumeAfterDelay:(NSTimeInterval)delay;

/// 释放并无效化定时器
/// @param timer 定时器的指针地址，传入时需要使用 & 符号（即传递变量的地址）
///
/// @discussion 调用此方法会使定时器失效，并将调用者持有的变量置为 nil，避免悬挂指针。
/// [NSTimer zhh_invalidate:&timer];
+ (void)zhh_invalidate:(NSTimer * _Nullable * _Nonnull)timer;
@end

NS_ASSUME_NONNULL_END
