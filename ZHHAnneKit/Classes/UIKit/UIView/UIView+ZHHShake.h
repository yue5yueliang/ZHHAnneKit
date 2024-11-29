//
//  UIView+ZHHShake.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/// 震动方向枚举
typedef NS_ENUM(NSInteger, ZHHShakeDirection) {
    ZHHShakeDirectionHorizontal = 0, ///< 水平震动 (默认值)
    ZHHShakeDirectionVertical        ///< 垂直震动
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHShake)
/// 将视图摇动默认次数
/// @discussion 默认震动次数为 10 次，震动幅度为 5，速度为 0.03 秒，方向为水平震动。
- (void)zhh_shake;

/// 摇动的 UIView
/// @discussion 默认速度为 0.03 秒，方向为水平震动。
/// @param times 震动次数
/// @param delta 震动的幅度
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta;

/// 摇动的 UIView，并在完成时执行回调
/// @discussion 默认速度为 0.03 秒，方向为水平震动。
/// @param times 震动次数
/// @param delta 震动的幅度
/// @param handler 动画完成后执行的回调
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta completion:(nullable void(^)(void))handler;

/// 以自定义速度震动 UIView
/// @discussion 方向默认为水平震动。
/// @param times 震动次数
/// @param delta 震动的幅度
/// @param interval 每次震动的持续时间
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/// 以自定义速度震动 UIView，并在完成时执行回调
/// @discussion 方向默认为水平震动。
/// @param times 震动次数
/// @param delta 震动的幅度
/// @param interval 每次震动的持续时间
/// @param handler 动画完成后执行的回调
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(nullable void(^)(void))handler;

/// 以自定义速度震动 UIView，并指定方向
/// @param times 震动次数
/// @param delta 震动的幅度
/// @param interval 每次震动的持续时间
/// @param shakeDirection 震动的方向 (水平或垂直)
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection;

/// 以自定义速度震动 UIView，并指定方向，完成时执行回调
/// @param times 震动次数
/// @param delta 震动的幅度
/// @param interval 每次震动的持续时间
/// @param shakeDirection 震动的方向 (水平或垂直)
/// @param completion 动画完成后执行的回调
- (void)zhh_shake:(int)times currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection completion:(void (^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
