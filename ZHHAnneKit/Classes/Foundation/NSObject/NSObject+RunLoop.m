//
//  NSObject+RunLoop.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSObject+RunLoop.h"
#import <objc/runtime.h>

@implementation NSObject (RunLoop)
- (BOOL)stopResidentThread{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setStopResidentThread:(BOOL)stopResidentThread{
    objc_setAssociatedObject(self, @selector(stopResidentThread), @(stopResidentThread), OBJC_ASSOCIATION_ASSIGN);
}

static char kThreadKey;
- (NSThread *)residentThread{
    NSThread *thread = objc_getAssociatedObject(self, &kThreadKey);
    if (thread == nil) {
        thread = [[NSThread alloc]initWithTarget:self selector:@selector(_residentThreadRun) object:nil];
        thread.name = @"常驻线程";
        [thread start];
        objc_setAssociatedObject(self, &kThreadKey, thread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return thread;
}

- (void)_residentThreadRun{
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

/// 常驻线程，线程保活
- (void)zhh_residentThread:(dispatch_block_t)withBlock{
    if (self.stopResidentThread) return;
    [self performSelector:@selector(_residentThreadAction:) onThread:self.residentThread withObject:withBlock waitUntilDone:YES];
}

- (void)_residentThreadAction:(dispatch_block_t)withBlock{
    withBlock ? withBlock() : nil;
}

/// 停止线程
- (void)zhh_stopResidentThread{
    if (objc_getAssociatedObject(self, &kThreadKey)) {
        self.stopResidentThread = YES;
        CFRunLoopStop(CFRunLoopGetCurrent());
        objc_setAssociatedObject(self, &kThreadKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

/// 空闲时刻执行
/// @param withBlock 执行回调
/// @param queue 线程，默认主线程
- (void)zhh_performOnLeisure:(dispatch_block_t)withBlock queue:(dispatch_queue_t)queue{
    if (queue == nil) queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [self performSelector:@selector(_performTask:) withObject:withBlock afterDelay:0.0 inModes:@[NSDefaultRunLoopMode]];
    });
}
- (void)_performTask:(dispatch_block_t)withBlock{
    withBlock ? withBlock() : nil;
}
@end
