//
//  NSNotificationCenter+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (ZHHUtilities)
/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param notification 要发送的通知对象
 */
- (void)zhh_postToMainThread:(NSNotification *)notification;
/**
 *  @brief  根据通知名称和对象，在主线程中发送一条通知
 *
 *  @param name    通知的名称，用于标识通知类型
 *  @param object 通知附带的对象，通常为触发通知的对象
 */
- (void)zhh_postNotificationWithName:(NSString *)name object:(id)object;
/**
 *  @brief  根据通知名称、对象和用户信息，在主线程中发送一条通知
 *
 *  @param name     通知的名称，用于标识通知类型
 *  @param object   通知附带的对象，通常为触发通知的对象
 *  @param userInfo 通知附带的用户信息字典，传递额外信息
 */
- (void)zhh_postNotificationWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
