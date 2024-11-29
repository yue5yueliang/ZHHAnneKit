//
//  NSObject+ZHHRunLoop.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSObject+ZHHRunLoop.h"
#import <objc/runtime.h>

@implementation NSObject (ZHHRunLoop)

#pragma mark - 相关的属性

/// 获取或设置线程是否停止
- (BOOL)zhh_stopThread {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZhh_stopThread:(BOOL)zhh_stopThread {
    objc_setAssociatedObject(self, @selector(zhh_stopThread), @(zhh_stopThread), OBJC_ASSOCIATION_ASSIGN);
}

/// 线程对象的存储键
static char kThreadKey;
/// 获取当前关联线程
- (NSThread *)zhh_thread {
    NSThread *thread = objc_getAssociatedObject(self, &kThreadKey);
    if (!thread) {
        // 初始化线程，关联对象
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(_zhh_threadRunLoop) object:nil];
        thread.name = @"ZHH_Thread";
        [thread start];
        objc_setAssociatedObject(self, &kThreadKey, thread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return thread;
}

#pragma mark - Thread Management
/// 线程运行入口，启动线程并保持运行
- (void)_zhh_threadRunLoop {
    @autoreleasepool {
        // 为线程的 RunLoop 添加一个 Port，确保线程保活
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

/// 在当前线程执行任务
+ (void)zhh_executeTaskOnThread:(dispatch_block_t)block {
    if (!block || self.zhh_stopThread) return;
    // 在关联线程中执行任务
    [self performSelector:@selector(_zhh_executeBlock:) onThread:self.zhh_thread withObject:block waitUntilDone:YES];
}

/// 停止并释放当前线程
+ (void)zhh_stopThreadExecution {
    if (objc_getAssociatedObject(self, &kThreadKey)) {
        self.zhh_stopThread = YES;
        // 停止当前线程的 RunLoop
        CFRunLoopStop(CFRunLoopGetCurrent());
        objc_setAssociatedObject(self, &kThreadKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - Perform on Leisure
/// 在空闲时执行任务
/// @param block 要执行的任务代码块
/// @param queue 任务执行的队列（默认为主线程）
/// @discussion 使用此方法可以在指定队列的空闲时间执行非紧急任务，避免阻塞主线程。
+ (void)zhh_performOnLeisure:(dispatch_block_t)block queue:(nullable dispatch_queue_t)queue {
    if (!block) return; // 如果没有提供任务代码块，则直接返回
    if (!queue) queue = dispatch_get_main_queue(); // 如果未指定队列，默认使用主队列
    dispatch_async(queue, ^{
        // 延迟执行任务，确保在队列的空闲时刻运行
        [self performSelector:@selector(_zhh_executeBlock:) withObject:block afterDelay:0.0 inModes:@[NSDefaultRunLoopMode]];
    });
}

/// 执行代码块（内部方法）
+ (void)_zhh_executeBlock:(dispatch_block_t)block {
    if (block) block();
}
@end
