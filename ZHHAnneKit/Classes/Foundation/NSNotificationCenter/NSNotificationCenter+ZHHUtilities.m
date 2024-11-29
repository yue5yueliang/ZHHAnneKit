//
//  NSNotificationCenter+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSNotificationCenter+ZHHUtilities.h"

@implementation NSNotificationCenter (ZHHUtilities)
/**
 *  @brief  在主线程中发送指定通知
 *
 *  @param notification 要发送的通知对象
 */
- (void)zhh_postToMainThread:(NSNotification *)notification {
    [self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
}

/**
 *  @brief  根据通知名称和对象，在主线程中发送通知
 *
 *  @param name    通知的名称，用于标识通知类型
 *  @param object  通知附带的对象，通常为触发通知的对象
 */
- (void)zhh_postNotificationWithName:(NSString *)name object:(id)object {
    NSNotification *notification = [NSNotification notificationWithName:name object:object];
    [self zhh_postToMainThread:notification];
}

/**
 *  @brief  根据通知名称、对象和用户信息，在主线程中发送通知
 *
 *  @param name     通知的名称，用于标识通知类型
 *  @param object   通知附带的对象，通常为触发通知的对象
 *  @param userInfo 通知附带的用户信息字典，传递额外信息
 */
- (void)zhh_postNotificationWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    NSNotification *notification = [NSNotification notificationWithName:name object:object userInfo:userInfo];
    [self zhh_postToMainThread:notification];
}

@end
