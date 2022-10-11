//
//  UITextField+ZHHShake.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHShakedDirection) {
    ZHHShakedDirectionHorizontal,
    ZHHShakedDirectionVertical
};
@interface UITextField (ZHHShake)
/**-----------------------------------------------------------------------------
 * @name UITextField+Shake
 * -----------------------------------------------------------------------------
 */

/** 晃动 the UITextField
 *
 *  用默认值晃动文本字段
 */
- (void)zhh_shake;

/** Shake the UITextField
 *
 * 将文本字段摇动给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UITextField
 *
 * 将文本字段摇动给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta completion:(void((^ _Nullable)(void)))handler;

/** 以自定义速度震动UITextFieldvoid
 *
 * 以给定速度将文本字段摇动给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/** 以自定义速度震动UITextField
 *  以给定速度将文本字段摇动给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^ _Nullable)(void)))handler;

/** 以自定义速度震动UITextField
 *
 *  以给定速度将文本字段摇动给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param shakeDirection 摇晃的声音
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakedDirection)shakeDirection;

/** 以自定义速度震动UITextField
 *
 *  以给定速度将文本字段摇动给定次数
 *
 * @param times 震动次数
 * @param delta 震动的宽度
 * @param interval 一次震动的持续时间
 * @param shakeDirection 摇晃的声音
 * @param handler 抖动序列结束时要执行的块对象
 */
- (void)zhh_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ZHHShakedDirection)shakeDirection completion:(void((^ _Nullable)(void)))handler;

@end

NS_ASSUME_NONNULL_END
