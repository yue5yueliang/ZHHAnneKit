//
//  CATransaction+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "CATransaction+ZHHUtilities.h"

@implementation CATransaction (ZHHUtilities)
/// 使用 CATransaction 执行动画块，并在完成时回调
/// @param duration   动画时长
/// @param animations 动画块，定义动画的具体内容
/// @param completion 动画完成后的回调
+ (void)zhh_animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion {
    // 参数验证
    if (duration < 0) {
        NSLog(@"ZHHAnneKit 警告: 动画时长不能为负数");
        return;
    }
    
    // 开始事务
    [CATransaction begin];
    // 设置动画持续时间
    [CATransaction setAnimationDuration:duration];
    
    // 如果有完成回调，设置完成块
    if (completion) {
        [CATransaction setCompletionBlock:^{
            completion();
        }];
    }
    
    // 执行动画块
    if (animations) {
        animations();
    }
    
    // 提交事务
    [CATransaction commit];
}
@end
