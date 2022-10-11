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
    [self _zhh_shake:10 direction:1 currentTimes:0 withDelta:5 speed:0.03 shakeDirection:ZHHShakeDirectionHorizontal completion:nil];
}

/** 摇动的UIView
 *
 * 将视图摇晃给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:ZHHShakeDirectionHorizontal completion:nil];
}

/** 摇动的UIView
 *
 * 将视图摇晃给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta completion:(void(^)(void))handler {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:ZHHShakeDirectionHorizontal completion:handler];
}

/** 以自定义速度震动UIView
 *
 * 以给定速度振动视图给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:ZHHShakeDirectionHorizontal completion:nil];
}

/** 以自定义速度震动UIView
 *
 * 以给定速度振动视图给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^)(void))handler {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:ZHHShakeDirectionHorizontal completion:handler];
}

/** 以自定义速度震动UIView
 *
 * 以给定速度振动视图给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param shakeDirection 震动方向
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
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
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection completion:(void (^)(void))completion {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:completion];
}

- (void)_zhh_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection completion:(void (^)(void))completionHandler {
    [UIView animateWithDuration:interval animations:^{
        self.layer.affineTransform = (shakeDirection == ZHHShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if (completionHandler != nil) {
                    completionHandler();
                }
            }];
            return;
        }
        [self _zhh_shake:(times - 1)
           direction:direction * -1
        currentTimes:current + 1
           withDelta:delta
               speed:interval
      shakeDirection:shakeDirection
          completion:completionHandler];
    }];
}
@end
