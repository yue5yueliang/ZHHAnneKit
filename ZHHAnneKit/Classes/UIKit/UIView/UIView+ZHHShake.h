//
//  UIView+ZHHShake.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZHHShakeDirection) {
    ZHHShakeDirectionHorizontal = 0,
    ZHHShakeDirectionVertical
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHShake)
/**-----------------------------------------------------------------------------
 * @name UIView+Shake
 * -----------------------------------------------------------------------------
 */

/** 摇动的UIView
 *
 * 将视图摇动默认次数
 */
- (void)zhh_shake;

/** 摇动的UIView
 *
 * 将视图摇晃给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta;

/** 摇动的UIView
 *
 * 将视图摇晃给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta completion:(void((^)(void)))handler;

/** 以自定义速度震动UIView
 *
 * 以给定速度振动视图给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/** 以自定义速度震动UIView
 *
 * 以给定速度振动视图给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)(void)))handler;

/** 以自定义速度震动UIView
 *
 * 以给定速度振动视图给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param shakeDirection 震动方向
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection;

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
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakeDirection)shakeDirection completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
