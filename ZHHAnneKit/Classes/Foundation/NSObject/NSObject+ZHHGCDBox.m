//
//  NSObject+ZHHGCDBox.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSObject+ZHHGCDBox.h"
#import <objc/runtime.h>

@implementation NSObject (ZHHGCDBox)

#pragma mark - 定时器暂停状态的关联属性
/// 获取 GCD 定时器的挂起状态
- (BOOL)zhh_isGCDTimerSuspended {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

/// 设置 GCD 定时器的挂起状态
- (void)setZhh_isGCDTimerSuspended:(BOOL)suspended {
    objc_setAssociatedObject(self, @selector(zhh_isGCDTimerSuspended), @(suspended), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - GCD 定时器方法
/// 创建一个 GCD 定时器
- (dispatch_source_t)zhh_createGCDTimerWithAsync:(BOOL)async task:(dispatch_block_t)task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats {
    // 参数校验：如果任务无效、延时小于零或者定时器为重复但间隔为零，则返回 nil
    if (!task || start < 0 || (interval <= 0 && repeats)) return nil;
    // 初始化挂起状态为 NO，表示定时器是启动的
    self.zhh_isGCDTimerSuspended = NO;
    // 根据是否异步，选择合适的队列执行定时任务
    dispatch_queue_t queue = async ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : dispatch_get_main_queue();
    // 创建定时器
    __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器触发的时间和间隔
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    // 弱引用 self，防止循环引用
    __weak typeof(self) weakSelf = self;
    // 设置定时器事件的处理逻辑
    dispatch_source_set_event_handler(timer, ^{
        // 如果 weakSelf 被释放，则取消定时器并释放
        if (!weakSelf) {
            dispatch_source_cancel(timer);
            timer = nil;
        } else {
            // 执行任务，如果不重复，则在任务执行后停止定时器
            if (repeats) {
                task();
            } else {
                task();
                [weakSelf zhh_cancelGCDTimer:timer];
            }
        }
    });
    // 启动定时器
    dispatch_resume(timer);
    // 返回定时器对象
    return timer;
}

/// 取消 GCD 定时器
- (void)zhh_cancelGCDTimer:(dispatch_source_t)timer {
    // 设置挂起状态为 NO
    self.zhh_isGCDTimerSuspended = NO;
    // 如果定时器存在，则取消并清空引用
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

/// 暂停 GCD 定时器
- (void)zhh_pauseGCDTimer:(dispatch_source_t)timer {
    // 如果定时器存在，则将挂起状态设置为 YES，并暂停定时器
    if (timer) {
        self.zhh_isGCDTimerSuspended = YES;
        dispatch_suspend(timer);
    }
}

/// 恢复 GCD 定时器
- (void)zhh_resumeGCDTimer:(dispatch_source_t)timer {
    // 如果定时器存在且当前是挂起状态，则恢复定时器
    if (timer && self.zhh_isGCDTimerSuspended) {
        self.zhh_isGCDTimerSuspended = NO;
        dispatch_resume(timer);
    }
}

/// 延迟恢复 GCD 定时器
- (void)zhh_resumeGCDTimer:(dispatch_source_t)timer afterDelay:(NSTimeInterval)delay {
    // 延迟恢复定时器
    if (timer) {
        [self zhh_executeAfter:delay async:NO task:^{
            [self zhh_resumeGCDTimer:timer];
        }];
    }
}

/// 延迟执行任务
- (void)zhh_executeAfter:(NSTimeInterval)delay async:(BOOL)async task:(dispatch_block_t)task {
    // 根据异步标志选择合适的队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : dispatch_get_main_queue();
    // 设置延迟执行的任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
        // 执行任务
        if (task) {
            task();
        }
    });
}

/// 异步并发迭代任务
- (void)zhh_executeConcurrentTask:(BOOL(^)(size_t index))task count:(NSUInteger)count {
    // 使用全局队列执行任务
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 执行任务迭代
    dispatch_apply(count, queue, ^(size_t index) {
        if (task(index)) {
            // 如果任务返回 YES，继续处理
        }
    });
}

/// 异步执行任务
- (void)zhh_executeAsync:(dispatch_block_t)block {
    // 获取全局队列并异步执行代码块
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, block);
}

/// 在主线程执行任务
- (void)zhh_executeOnMainThread:(dispatch_block_t)block wait:(BOOL)shouldWait {
    if (shouldWait) {
        // 如果是同步请求，则使用同步方式在主线程执行
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        // 如果是异步请求，则使用异步方式在主线程执行
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/// 延迟执行任务（主线程）
- (void)zhh_executeAfter:(NSTimeInterval)seconds block:(dispatch_block_t)block {
    // 计算延迟时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    // 在主线程执行延迟任务
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

/// 获取全局并发队列
+ (dispatch_queue_t)zhh_queue {
    /// 返回一个全局并发队列
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

/// 在主线程执行任务
+ (void)zhh_main:(dispatch_block_t)block {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    /// 如果当前线程已经是主线程，直接执行任务；否则使用主线程队列异步执行
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(mainQueue)) == 0) {
        block();
    } else if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(mainQueue, block);
    } else {
        dispatch_sync(mainQueue, block);
    }
}

/// 在子线程异步执行任务
+ (void)zhh_async:(dispatch_block_t)block {
    dispatch_queue_t queue = [self zhh_queue];
    /// 如果当前线程已经是目标队列，直接执行任务；否则异步执行任务
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    } else {
        dispatch_async(queue, block);
    }
}

/// 异步并行队列任务组，携带可变参数（以 nil 结尾）
+ (void)zhh_groupNotify:(dispatch_block_t)notify block:(dispatch_block_t)block, ... {
    dispatch_queue_t queue = [self zhh_queue];
    dispatch_group_t group = dispatch_group_create();
    // 第一个任务加入任务组
    dispatch_group_async(group, queue, block);
    
    // 使用可变参数添加任务
    va_list args;
    dispatch_block_t arg;
    va_start(args, block);
    while ((arg = va_arg(args, dispatch_block_t))) {
        dispatch_group_async(group, queue, arg);
    }
    va_end(args);
    
    // 所有任务完成后执行通知任务
    dispatch_group_notify(group, queue, notify);
}

/// 栅栏任务，返回一个队列
+ (dispatch_queue_t)zhh_barrier:(dispatch_block_t)block barrier:(dispatch_block_t)barrier {
    // 创建并发队列并执行任务，最后执行栅栏任务
    dispatch_queue_t queue = dispatch_queue_create("com.zhh.barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, block);
    dispatch_barrier_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), barrier);
    });
    return queue;
}

/// 栅栏任务用于多读单写操作（携带可变参数，以 nil 结尾）
+ (void)zhh_barrierReadWrite:(dispatch_block_t)barrier block:(dispatch_block_t)block, ... {
    // 创建并发队列执行任务，最后执行栅栏任务进行写操作
    dispatch_queue_t queue = dispatch_queue_create("com.zhh.barrier_rw", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, block);
    
    va_list args;
    dispatch_block_t arg;
    va_start(args, block);
    while ((arg = va_arg(args, dispatch_block_t))) {
        dispatch_async(queue, arg);
    }
    va_end(args);
    
    // 执行写操作任务（栅栏）
    dispatch_barrier_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), barrier);
    });
}

/// 一次性任务
+ (void)zhh_once:(dispatch_block_t)block {
    // 保证任务只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, block);
}

/// 延时执行任务
+ (void)zhh_after:(int64_t)delayInSeconds block:(dispatch_block_t)block {
    // 延时执行任务
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, [self zhh_queue], block);
}

/// 主线程延时执行任务
+ (void)zhh_afterMain:(int64_t)delayInSeconds block:(dispatch_block_t)block {
    // 在主线程延时执行任务
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), block);
}

/// 并发迭代任务
+ (void)zhh_apply:(int)iterations block:(void(^)(size_t idx))block {
    // 快速并发执行迭代任务
    dispatch_apply(iterations, [self zhh_queue], block);
}

/// 并发遍历数组
+ (void)zhh_applyArray:(NSArray *)array block:(void(^)(id obj, size_t idx))block {
    // 快速并发遍历数组
    dispatch_apply(array.count, [self zhh_queue], ^(size_t idx) {
        block(array[idx], idx);
    });
}

@end
