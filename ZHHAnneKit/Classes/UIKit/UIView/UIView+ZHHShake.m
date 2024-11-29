//
//  UIView+ZHHShake.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHShake.h"

@implementation UIView (ZHHShake)
/// 将视图摇动默认次数
- (void)zhh_shake {
    [self zhh_shake:10 withDelta:5 speed:0.03 shakeDirection:ZHHShakeDirectionHorizontal completion:nil];
}

/// 摇动的UIView
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta {
    [self zhh_shake:times withDelta:delta speed:0.03 shakeDirection:ZHHShakeDirectionHorizontal completion:nil];
}

/// 摇动的UIView，并在完成时执行回调
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta completion:(void(^)(void))handler {
    [self zhh_shake:times withDelta:delta speed:0.03 shakeDirection:ZHHShakeDirectionHorizontal completion:handler];
}

/// 以自定义速度震动UIView
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self zhh_shake:times withDelta:delta speed:interval shakeDirection:ZHHShakeDirectionHorizontal completion:nil];
}

/// 以自定义速度震动UIView，并在完成时执行回调
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^)(void))handler {
    [self zhh_shake:times withDelta:delta speed:interval shakeDirection:ZHHShakeDirectionHorizontal completion:handler];
}

/// 以自定义速度震动UIView，并指定方向
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection {
    [self zhh_shake:times withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

/// 以自定义速度震动UIView，并指定方向，完成时执行回调
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection completion:(void (^)(void))completion {
    [self zhh_shake:times currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:completion];
}

/** 以自定义速度震动UIView
 *
 * 使用完成处理程序以给定速度将视图摇晃给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param shakeDirection    震动方向
 * @param completion 当视图完成震动时调用
 */
- (void)zhh_shake:(int)times currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection completion:(void (^ _Nullable)(void))completion {
    
    // 确保动画执行在主线程
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:interval animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 设置摇晃方向和距离
        CGAffineTransform transform;
        if (shakeDirection == ZHHShakeDirectionHorizontal) {
            transform = CGAffineTransformMakeTranslation(delta * (current % 2 == 0 ? 1 : -1), 0);
        } else {
            transform = CGAffineTransformMakeTranslation(0, delta * (current % 2 == 0 ? 1 : -1));
        }
        strongSelf.layer.affineTransform = transform;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (current >= times) {
            // 恢复初始状态
            [UIView animateWithDuration:interval animations:^{
                strongSelf.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if (completion != nil) {
                    completion();
                }
            }];
        } else {
            // 递归调用，继续摇晃
            [strongSelf zhh_shake:times currentTimes:current + 1 withDelta:delta speed:interval shakeDirection:shakeDirection completion:completion];
        }
    }];
}
@end
