//
//  NSObject+ZHHRunLoop.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHHRunLoop)
/// 常驻线程，线程保活
- (void)zhh_residentThread:(dispatch_block_t)withBlock;

/// 停止线程
- (void)zhh_stopResidentThread;

/// 空闲时刻执行
/// @param withBlock execute callback
/// @param queue thread, the default main thread
- (void)zhh_performOnLeisure:(dispatch_block_t)withBlock queue:(nullable dispatch_queue_t)queue;
@end

NS_ASSUME_NONNULL_END
