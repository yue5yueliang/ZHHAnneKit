//
//  UITextField+ZHHShake.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITextField+ZHHShake.h"

@implementation UITextField (ZHHShake)
- (void)zhh_shake {
    [self zhh_shake:10 withDelta:5 completion:nil];
}

- (void)zhh_shake:(int)times withDelta:(CGFloat)delta {
    [self zhh_shake:times withDelta:delta completion:nil];
}

- (void)zhh_shake:(int)times withDelta:(CGFloat)delta completion:(void(^ _Nullable)(void))handler {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:ZHHShakedDirectionHorizontal completion:handler];
}

- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self zhh_shake:times withDelta:delta speed:interval completion:nil];
}

- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^ _Nullable)(void))handler {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:ZHHShakedDirectionHorizontal completion:handler];
}

- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakedDirection)shakeDirection {
    [self zhh_shake:times withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakedDirection)shakeDirection completion:(void(^)(void))handler {
    [self _zhh_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:handler];
}

- (void)_zhh_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakedDirection)shakeDirection completion:(void(^ _Nullable)(void))handler {
    [UIView animateWithDuration:interval animations:^{
        self.transform = (shakeDirection == ZHHShakedDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (handler) {
                    handler();
                }
            }];
            return;
        }
        [self _zhh_shake:(times - 1) direction:direction * -1 currentTimes:current + 1 withDelta:delta speed:interval shakeDirection:shakeDirection completion:handler];
    }];
}

@end
