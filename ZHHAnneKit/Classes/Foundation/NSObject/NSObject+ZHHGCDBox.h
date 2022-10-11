//
//  NSObject+ZHHGCDBox.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHHGCDBox)
/// 创建一个异步计时器，该计时器比NSTimer和CADisplayLink（两者都基于runloop处理）更精确
/// @param async is asynchronous
/// @param task event handling
/// @param start start time
/// @param interval interval time
/// @param repeats whether to repeat
/// @return returns the timer
- (dispatch_source_t)zhh_createGCDAsyncTimer:(BOOL)async
                                       task:(dispatch_block_t)task
                                      start:(NSTimeInterval)start
                                   interval:(NSTimeInterval)interval
                                    repeats:(BOOL)repeats;
/// 取消计时器
- (void)zhh_gcdStopTimer:(dispatch_source_t)timer;

/// 暂停计时器
- (void)zhh_gcdPauseTimer:(dispatch_source_t)timer;

/// 继续计时器
- (void)zhh_gcdResumeTimer:(dispatch_source_t)timer;

/// 延迟执行
/// @param task event handling
/// @param time delay time
/// @param async is asynchronous
- (void)zhh_gcdAfterTask:(dispatch_block_t)task time:(NSTimeInterval)time asyne:(BOOL)async;

/// Asynchronous fast iteration
/// @param task event handling
/// @param count total number of iterations
- (void)zhh_gcdApplyTask:(BOOL(^)(size_t index))task count:(NSUInteger)count;
/**
 *  @brief  异步执行代码块
 *
 *  @param block 代码块
 */
- (void)zhh_performAsynchronous:(void(^)(void))block;
/**
 *  @brief  GCD主线程执行代码块
 *
 *  @param block 代码块
 *  @param wait  是否同步请求
 */
- (void)zhh_performOnMainThread:(void(^)(void))block wait:(BOOL)wait;
/**
 *  @brief  延迟执行代码块
 *
 *  @param seconds 延迟时间 秒
 *  @param block   代码块
 */
- (void)zhh_performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;
#pragma mark - GCD threading

/// Create a queue
FOUNDATION_EXPORT dispatch_queue_t kGCD_queue(void);
/// 主线程
FOUNDATION_EXPORT void kGCD_main(dispatch_block_t block);
/// 子线程
FOUNDATION_EXPORT void kGCD_async(dispatch_block_t block);
/// 异步并行队列，携带可变参数（需要nil结尾）
FOUNDATION_EXPORT void kGCD_group_notify(dispatch_block_t notify, dispatch_block_t block,...);
/// 栅栏
FOUNDATION_EXPORT dispatch_queue_t kGCD_barrier(dispatch_block_t block, dispatch_block_t barrier);
/// 栅栏实现多读单写操作，barrier当中完成写操作，携带可变参数（需要nil结尾）
FOUNDATION_EXPORT void kGCD_barrier_read_write(dispatch_block_t barrier, dispatch_block_t block,...);
/// 一次性
FOUNDATION_EXPORT void kGCD_once(dispatch_block_t block);
/// 延时执行
FOUNDATION_EXPORT void kGCD_after(int64_t delayInSeconds, dispatch_block_t block);
/// 主线程当中延时执行
FOUNDATION_EXPORT void kGCD_after_main(int64_t delayInSeconds, dispatch_block_t block);
/// 快速迭代
FOUNDATION_EXPORT void kGCD_apply(int iterations, void(^block)(size_t idx));
/// 快速遍历数组
FOUNDATION_EXPORT void kGCD_apply_array(NSArray * temp, void(^block)(id obj, size_t index));
@end

NS_ASSUME_NONNULL_END
