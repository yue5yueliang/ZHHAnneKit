//
//  NSTimer+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZHHKit)
/// 打开可以在当前线程中重复执行的NSTimer对象
/// @param inerval interval time
/// @param repeats whether to repeat
/// @param complete event processing
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                       complete:(void(^)(NSTimer * timer))complete;
/// 打开可以在当前线程中重复执行的NSTimer对象
/// @param inerval interval time
/// @param repeats whether to repeat
/// @param complete event handling
/// @param mode RunLoop type
+ (NSTimer *)zhh_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                       complete:(void(^)(NSTimer * timer))complete
                                    runLoopMode:(NSRunLoopMode)mode;
/// 打开需要添加到线程的可重复NSTimer对象
/// @param inerval interval time
/// @param repeats whether to repeat
/// @param complete event processing
+ (NSTimer *)zhh_timerWithTimeInterval:(NSTimeInterval)inerval
                               repeats:(BOOL)repeats
                              complete:(void(^)(NSTimer * timer))complete;
/// 立即执行
- (void)zhh_immediatelyTimer;

/// 暂停
- (void)zhh_pauseTimer;

/// 重启定时器
- (void)zhh_resumeTimer;

/// 延迟执行
/// @param interval delay
- (void)zhh_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

/// 释放定时器n 
+ (void)zhh_invalidateTimer:(NSTimer *)timer;
@end

NS_ASSUME_NONNULL_END
