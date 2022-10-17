//
//  CATransaction+ZHHAnimateWithDuration.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CATransaction (ZHHAnimateWithDuration)
/**
 *  @author Denys Telezhkin
 *
 *  @brief  CATransaction 动画执行 block 回调
 *
 *  @param duration   动画时间
 *  @param animations 动画块
 *  @param completion 动画结束回调
 */
+ (void)zhh_animateWithDuration:(NSTimeInterval)duration
                    animations:(nullable void (^)(void))animations
                    completion:(nullable void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
