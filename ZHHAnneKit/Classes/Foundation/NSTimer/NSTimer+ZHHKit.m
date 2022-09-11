//
//  NSTimer+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSTimer+ZHHKit.h"
#import <objc/runtime.h>

@implementation NSTimer (ZHHKit)
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                       complete:(void(^)(NSTimer * timer))complete{
    return [NSTimer scheduledTimerWithTimeInterval:inerval
                                            target:self
                                          selector:@selector(blcokInvoke:)
                                          userInfo:[complete copy]
                                           repeats:repeats];
}
+ (void)blcokInvoke:(NSTimer *)timer{
    void (^complete)(NSTimer * timer) = timer.userInfo;
    if (complete) complete(timer);
}

+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                       complete:(void(^)(NSTimer * timer))complete
                                    runLoopMode:(NSRunLoopMode)mode{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:inerval
                                                      target:self
                                                    selector:@selector(runLoopblcokInvoke:)
                                                    userInfo:[complete copy]
                                                     repeats:repeats];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:mode];
    return timer;
}
+ (void)runLoopblcokInvoke:(NSTimer*)timer{
    void (^complete)(NSTimer * timer) = timer.userInfo;
    if (complete) complete(timer);
}
/// 开启一个需添加到线程的可重复执行的NSTimer对象
+ (NSTimer *)zhh_timerWithTimeInterval:(NSTimeInterval)inerval
                               repeats:(BOOL)repeats
                              complete:(void(^)(NSTimer * timer))complete{
    return [NSTimer timerWithTimeInterval:inerval
                                   target:self
                                 selector:@selector(xxxblcokInvoke:)
                                 userInfo:[complete copy]
                                  repeats:repeats];
}
+ (void)xxxblcokInvoke:(NSTimer*)timer{
    void (^complete)(NSTimer * timer) = timer.userInfo;
    if (complete) complete(timer);
}

/// 立刻执行
- (void)zhh_immediatelyTimer{
    if (![self isValid]) return;
    [self fire];
}
/// 暂停
- (void)zhh_pauseTimer{
    if (![self isValid]) return;
    [self setFireDate:[NSDate distantFuture]];
}
/// 继续
- (void)zhh_resumeTimer{
    if (![self isValid]) return;
    [self setFireDate:[NSDate date]];
}
/// 延时执行
- (void)zhh_resumeTimerAfterTimeInterval:(NSTimeInterval)interval{
    if (![self isValid]) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
/// 释放计时器
+ (void)zhh_invalidateTimer:(NSTimer *)timer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
@end
