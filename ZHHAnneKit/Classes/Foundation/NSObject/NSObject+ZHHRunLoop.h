//
//  NSObject+ZHHRunLoop.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHHRunLoop)
/// 当前对象的关联线程（默认是一个常驻线程，按需创建）
@property (nonatomic, strong, readonly) NSThread *zhh_thread;

/// 停止当前对象关联线程的标志，设置为 YES 时，停止线程运行
@property (nonatomic, assign) BOOL zhh_stopThread;

/// 在当前对象的关联线程中执行任务
/// @param block 需要执行的任务代码块
/// @discussion 如果关联线程未创建，会自动创建一个线程。
/// 示例
/// [NSObject zhh_executeTaskOnThread:^{
///     NSLog(@"任务在常驻线程中执行");
/// }];
+ (void)zhh_executeTaskOnThread:(dispatch_block_t)block;

/// 停止并释放当前对象的关联线程
/// @discussion 停止后，关联线程将被销毁，下次调用任务时会重新创建。
/// 示例
/// [NSObject zhh_stopThreadExecution];
+ (void)zhh_stopThreadExecution;

/// 在空闲时执行任务
/// @param block 要执行的任务代码块
/// @param queue 任务执行的队列（默认为主线程）
/// @discussion 使用此方法可以在指定队列的空闲时间执行非紧急任务，避免阻塞主线程。
/// 示例
/// [NSObject zhh_performOnLeisure:^{
///     NSLog(@"空闲时刻执行任务");
/// }];
+ (void)zhh_performOnLeisure:(dispatch_block_t)block queue:(nullable dispatch_queue_t)queue;
@end

NS_ASSUME_NONNULL_END
