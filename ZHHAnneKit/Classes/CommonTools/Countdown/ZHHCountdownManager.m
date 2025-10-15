//
//  ZHHCountdownManager.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHCountdownManager.h"

@implementation ZHHCountdownManager

// 单例获取管理器
+ (instancetype)sharedManager {
    static ZHHCountdownManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 创建串行队列用于保护 countdownTasks 字典的访问
        _countdownQueue = dispatch_queue_create("com.zhh.countdown.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

// 懒加载倒计时任务字典
- (NSMutableDictionary<NSString *, dispatch_source_t> *)countdownTasks {
    if (!_countdownTasks) {
        _countdownTasks = [NSMutableDictionary dictionary];
    }
    return _countdownTasks;
}

// 启动带 Key 的倒计时任务
- (void)zhh_startCountdownWithKey:(NSString *)key
                           timeout:(NSInteger)timeout
                  countdownHandler:(ZHHCountdownHandler)countdownHandler
                        completion:(ZHHCountdownCompletion)completion {
    // 参数验证
    if (!key || key.length == 0 || timeout <= 0) {
        NSLog(@"ZHHAnneKit 警告: 倒计时参数无效");
        return;
    }
    
    // 先取消可能存在的旧任务
    [self zhh_cancelCountdownForKey:key];

    // 倒计时的初始时间
    __block NSInteger remainingTime = timeout;
    // 获取后台全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的触发时间和间隔（每秒一次）
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    // 定时器事件处理
    dispatch_source_set_event_handler(timer, ^{
        // 当倒计时结束时
        if (remainingTime <= 0) {
            // 取消定时器
            dispatch_source_cancel(timer);
            // 调用完成回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
            // 从字典中移除定时器任务（线程安全）
            dispatch_async(self.countdownQueue, ^{
                [self.countdownTasks removeObjectForKey:key];
            });
        } else {
            // 更新剩余时间
            dispatch_async(dispatch_get_main_queue(), ^{
                if (countdownHandler) {
                    countdownHandler(remainingTime);
                }
            });
            // 剩余时间减1
            remainingTime--;
        }
    });
    // 将定时器保存到字典中（线程安全）
    dispatch_async(self.countdownQueue, ^{
        self.countdownTasks[key] = timer;
    });
    // 启动定时器
    dispatch_resume(timer);
}

// 启动匿名倒计时任务（不带 Key）
- (void)zhh_startCountdownWithTimeout:(NSInteger)timeout
                     countdownHandler:(ZHHCountdownHandler)countdownHandler
                          completion:(ZHHCountdownCompletion)completion {
    // 为匿名倒计时任务生成一个唯一 Key
    NSString *uniqueKey = [NSUUID UUID].UUIDString;
    
    // 使用生成的 Key 调用带 Key 的倒计时方法
    [self zhh_startCountdownWithKey:uniqueKey
                            timeout:timeout
                   countdownHandler:countdownHandler
                         completion:completion];
}

// 取消指定 Key 的倒计时任务
- (void)zhh_cancelCountdownForKey:(NSString *)key {
    if (!key || key.length == 0) {
        return;
    }
    
    // 线程安全地获取和移除定时器
    dispatch_async(self.countdownQueue, ^{
        dispatch_source_t timer = self.countdownTasks[key];
        if (timer) {
            // 取消定时器
            dispatch_source_cancel(timer);
            // 从字典中移除定时器任务
            [self.countdownTasks removeObjectForKey:key];
        }
    });
}

// 取消所有倒计时任务
- (void)zhh_cancelAllCountdowns {
    // 线程安全地取消所有倒计时任务
    dispatch_async(self.countdownQueue, ^{
        // 遍历并取消所有倒计时任务
        for (NSString *key in self.countdownTasks.allKeys) {
            dispatch_source_t timer = self.countdownTasks[key];
            if (timer) {
                dispatch_source_cancel(timer);
            }
        }
        // 清空任务字典
        [self.countdownTasks removeAllObjects];
    });
}

@end
