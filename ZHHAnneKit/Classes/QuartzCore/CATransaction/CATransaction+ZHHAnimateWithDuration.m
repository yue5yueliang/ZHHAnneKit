//
//  CATransaction+ZHHAnimateWithDuration.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "CATransaction+ZHHAnimateWithDuration.h"

@implementation CATransaction (ZHHAnimateWithDuration)
/**
 *  @author Denys Telezhkin
 *
 *  @brief  CATransaction 动画执 block回调
 *
 *  @param duration   动画时间
 *  @param animations 动画块
 *  @param completion 动画结束回调
 */
+ (void)zhh_animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    
    if (completion) {
        [CATransaction setCompletionBlock:completion];
    }
    
    if (animations) {
        animations();
    }
    [CATransaction commit];
}
@end
