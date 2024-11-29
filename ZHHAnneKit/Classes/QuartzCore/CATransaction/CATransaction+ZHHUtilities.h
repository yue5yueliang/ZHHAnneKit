//
//  CATransaction+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CATransaction (ZHHUtilities)
/// 使用 CATransaction 执行动画块，并在完成时回调
/// @param duration   动画时长
/// @param animations 动画块，定义动画的具体内容
/// @param completion 动画完成后的回调
+ (void)zhh_animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
