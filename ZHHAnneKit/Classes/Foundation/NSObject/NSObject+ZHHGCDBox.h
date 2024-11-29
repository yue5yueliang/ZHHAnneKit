//
//  NSObject+ZHHGCDBox.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHHGCDBox)
/// GCD 定时器是否挂起状态
@property (nonatomic, assign) BOOL zhh_isGCDTimerSuspended;

/**
 * 创建一个 GCD 定时器
 * @param async 是否异步执行
 * @param task 定时器执行的任务
 * @param start 定时器开始的延时时间（单位：秒）
 * @param interval 定时器的执行间隔（单位：秒）
 * @param repeats 是否重复执行
 * @return 返回创建的 GCD 定时器对象
 *
 * 示例：
 * dispatch_source_t timer = [object zhh_createGCDTimerWithAsync:YES task:^{
 *     NSLog(@"定时器触发");
 * } start:1 interval:2 repeats:YES];
 */
- (dispatch_source_t)zhh_createGCDTimerWithAsync:(BOOL)async task:(dispatch_block_t)task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats;

/**
 * 取消 GCD 定时器
 * @param timer 要取消的 GCD 定时器对象
 *
 * 示例：
 * [object zhh_cancelGCDTimer:timer];
 */
- (void)zhh_cancelGCDTimer:(dispatch_source_t)timer;

/**
 * 暂停 GCD 定时器
 * @param timer 要暂停的 GCD 定时器对象
 *
 * 示例：
 * [object zhh_pauseGCDTimer:timer];
 */
- (void)zhh_pauseGCDTimer:(dispatch_source_t)timer;

/**
 * 恢复 GCD 定时器
 * @param timer 要恢复的 GCD 定时器对象
 *
 * 示例：
 * [object zhh_resumeGCDTimer:timer];
 */
- (void)zhh_resumeGCDTimer:(dispatch_source_t)timer;

/**
 * 延迟恢复 GCD 定时器
 * @param timer 要恢复的 GCD 定时器对象
 * @param delay 延迟时间（单位：秒）
 *
 * 示例：
 * [object zhh_resumeGCDTimer:timer afterDelay:3.0];
 */
- (void)zhh_resumeGCDTimer:(dispatch_source_t)timer afterDelay:(NSTimeInterval)delay;

/**
 * 延迟执行任务
 * @param delay 延迟时间（单位：秒）
 * @param async 是否异步执行任务（YES 为异步，NO 为同步）
 * @param task 任务代码块
 *
 * 示例：
 * [object zhh_executeAfter:2.0 async:YES task:^{
 *     NSLog(@"延迟执行的任务");
 * }];
 */
- (void)zhh_executeAfter:(NSTimeInterval)delay async:(BOOL)async task:(dispatch_block_t)task;

/**
 * 异步并发迭代任务
 * @param task 执行任务的代码块
 * @param count 任务执行的次数
 *
 * 示例：
 * [object zhh_executeConcurrentTask:^BOOL(size_t index) {
 *     NSLog(@"第 %zu 次任务执行", index);
 *     return YES; // 返回 YES 继续任务执行
 * } count:5];
 */
- (void)zhh_executeConcurrentTask:(BOOL(^)(size_t index))task count:(NSUInteger)count;

/**
 * 异步执行任务
 * @param block 代码块
 *
 * 示例：
 * [object zhh_executeAsync:^{
 *     NSLog(@"异步任务执行");
 * }];
 */
- (void)zhh_executeAsync:(dispatch_block_t)block;

/**
 * 在主线程执行任务
 * @param block 代码块
 * @param shouldWait 是否同步请求（YES 为同步，NO 为异步）
 *
 * 示例：
 * [object zhh_executeOnMainThread:^{
 *     NSLog(@"主线程任务执行");
 * } wait:YES]; // 同步执行
 *
 * [object zhh_executeOnMainThread:^{
 *     NSLog(@"主线程任务执行");
 * } wait:NO]; // 异步执行
 */
- (void)zhh_executeOnMainThread:(dispatch_block_t)block wait:(BOOL)shouldWait;

/**
 * 延迟执行任务（主线程）
 * @param seconds 延迟时间（单位：秒）
 * @param block 代码块
 *
 * 示例：
 * [object zhh_executeAfter:3.0 block:^{
 *     NSLog(@"延迟 3 秒后的任务");
 * }];
 */
- (void)zhh_executeAfter:(NSTimeInterval)seconds block:(dispatch_block_t)block;

/// 获取全局并发队列
/// @return 返回一个全局的并发队列
+ (dispatch_queue_t)zhh_queue;

/**
 *  在主线程执行任务
 *  @param block 要在主线程执行的任务
 *  使用方式:
 *  [NSObject zhh_main:^{
 *      NSLog(@"主线程任务");
 *  }];
 */
+ (void)zhh_main:(dispatch_block_t)block;

/**
 *  在子线程异步执行任务
 *  @param block 要在子线程执行的任务
 *  使用方式:
 *  [NSObject zhh_async:^{
 *      NSLog(@"子线程异步任务");
 *  }];
 */
+ (void)zhh_async:(dispatch_block_t)block;

/**
 *  异步并行队列任务组，携带可变参数（以 nil 结尾）
 *  @param notify 通知任务
 *  @param block 第一个任务
 *  @param ... 后续任务（可变参数）
 *  使用方式:
 *  [NSObject zhh_groupNotify:^{
 *      NSLog(@"所有任务完成通知");
 *  } block:^{
 *      NSLog(@"任务 1");
 *  }, ^{
 *      NSLog(@"任务 2");
 *  }, nil];
 */
+ (void)zhh_groupNotify:(dispatch_block_t)notify block:(dispatch_block_t)block, ...;

/**
 *  栅栏任务，返回一个队列
 *  @param block 执行任务
 *  @param barrier 栅栏任务
 *  @return 返回创建的栅栏队列
 *  使用方式:
 *  [NSObject zhh_barrier:^{
 *      NSLog(@"任务 1");
 *  } barrier:^{
 *      NSLog(@"栅栏任务");
 *  }];
 */
+ (dispatch_queue_t)zhh_barrier:(dispatch_block_t)block barrier:(dispatch_block_t)barrier;

/**
 *  栅栏任务用于多读单写操作（携带可变参数，以 nil 结尾）
 *  @param barrier 栅栏任务（写操作）
 *  @param block 第一个读取任务
 *  @param ... 后续读取任务（可变参数）
 *  使用方式:
 *  [NSObject zhh_barrierReadWrite:^{
 *      NSLog(@"写操作");
 *  } block:^{
 *      NSLog(@"读操作 1");
 *  }, ^{
 *      NSLog(@"读操作 2");
 *  }, nil];
 */
+ (void)zhh_barrierReadWrite:(dispatch_block_t)barrier block:(dispatch_block_t)block, ...;

/**
 *  一次性任务
 *  @param block 要执行的任务
 *  使用方式:
 *  [NSObject zhh_once:^{
 *      NSLog(@"只执行一次的任务");
 *  }];
 */
+ (void)zhh_once:(dispatch_block_t)block;

/**
 *  延时执行任务
 *  @param delayInSeconds 延迟时间（秒）
 *  @param block 要延时执行的任务
 *  使用方式:
 *  [NSObject zhh_after:2 block:^{
 *      NSLog(@"延时 2 秒执行");
 *  }];
 */
+ (void)zhh_after:(int64_t)delayInSeconds block:(dispatch_block_t)block;

/**
 *  主线程延时执行任务
 *  @param delayInSeconds 延迟时间（秒）
 *  @param block 要延时执行的任务
 *  使用方式:
 *  [NSObject zhh_afterMain:3 block:^{
 *      NSLog(@"主线程延时 3 秒执行");
 *  }];
 */
+ (void)zhh_afterMain:(int64_t)delayInSeconds block:(dispatch_block_t)block;

/**
 *  并发迭代任务
 *  @param iterations 迭代次数
 *  @param block 每次迭代的任务
 *  使用方式:
 *  [NSObject zhh_apply:5 block:^(size_t idx) {
 *      NSLog(@"第 %zu 次执行", idx);
 *  }];
 */
+ (void)zhh_apply:(int)iterations block:(void(^)(size_t idx))block;

/**
 *  并发遍历数组
 *  @param array 要遍历的数组
 *  @param block 遍历的任务
 *  使用方式:
 *  NSArray *array = @[@"A", @"B", @"C"];
 *  [NSObject zhh_applyArray:array block:^(id obj, size_t idx) {
 *      NSLog(@"索引 %zu: %@", idx, obj);
 *  }];
 */
+ (void)zhh_applyArray:(NSArray *)array block:(void(^)(id obj, size_t idx))block;
@end

NS_ASSUME_NONNULL_END
