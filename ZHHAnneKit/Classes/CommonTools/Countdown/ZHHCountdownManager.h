//
//  ZHHCountdownManager.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 声明回调类型，用于倒计时更新处理
typedef void(^ZHHCountdownHandler)(NSInteger remainingTime);

/// 声明回调类型，用于倒计时结束处理
typedef void(^ZHHCountdownCompletion)(void);

@interface ZHHCountdownManager : NSObject

/// 存储当前所有倒计时任务的字典，key 为任务的唯一标识，value 为对应的 timer
@property (nonatomic, strong) NSMutableDictionary<NSString *, dispatch_source_t> *countdownTasks;
/// 线程安全队列，用于保护 countdownTasks 字典的访问
@property (nonatomic, strong) dispatch_queue_t countdownQueue;

/// 获取单例管理器
+ (instancetype)sharedManager;

/// 启动带有唯一 Key 的倒计时任务
/// @param key 任务的唯一标识符，用于标识这个倒计时任务。
/// @param timeout 倒计时的时长（秒）。
/// @param countdownHandler 在每秒倒计时更新时回调，传入剩余的时间。
/// @param completion 当倒计时结束时回调，通常用于更新 UI 或进行后续操作。
- (void)zhh_startCountdownWithKey:(NSString *)key
                           timeout:(NSInteger)timeout
                  countdownHandler:(ZHHCountdownHandler)countdownHandler
                        completion:(ZHHCountdownCompletion)completion;

/// 启动匿名倒计时任务（不带 Key）
/// @param timeout 倒计时的时长（秒）。
/// @param countdownHandler 在每秒倒计时更新时回调，传入剩余的时间。
/// @param completion 当倒计时结束时回调，通常用于更新 UI 或进行后续操作。
- (void)zhh_startCountdownWithTimeout:(NSInteger)timeout
                     countdownHandler:(ZHHCountdownHandler)countdownHandler
                          completion:(ZHHCountdownCompletion)completion;

/// 取消指定 Key 的倒计时任务
/// @param key 需要取消的倒计时任务的唯一标识符。
- (void)zhh_cancelCountdownForKey:(NSString *)key;

/// 取消所有倒计时任务
- (void)zhh_cancelAllCountdowns;
@end

NS_ASSUME_NONNULL_END
