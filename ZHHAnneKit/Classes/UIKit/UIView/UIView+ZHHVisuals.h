//
//  UIView+ZHHVisuals.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHVisuals)
/*
 * 设置半径角，给定笔划大小和颜色
 */
- (void)zhh_cornerRadius:(CGFloat)radius strokeSize:(CGFloat)size color:(UIColor *)color;
/*
 * 设置圆角点
 */
- (void)zhh_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/*
 *  使用属性绘制阴影
 */
- (void)zhh_shadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;

/*
 * 从带有淡入效果的超级视图中删除
 */
- (void)zhh_removeFromSuperviewWithFadeDuration:(NSTimeInterval)duration;

/*
 * 添加具有给定过渡持续时间的子视图（&D）
 */
- (void)zhh_addSubview:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration;

/*
 * 从具有给定过渡持续时间的超级视图中删除视图（&D）
 */
- (void)zhh_removeFromSuperviewWithTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration;

/*
 * 按给定角度旋转视图。TimingFunction可以为零，默认为kCAMediaTimingFunctionEaseInEaseOut。
 */
- (void)zhh_rotateByAngle:(CGFloat)angle
                 duration:(NSTimeInterval)duration
              autoreverse:(BOOL)autoreverse
              repeatCount:(CGFloat)repeatCount
           timingFunction:(CAMediaTimingFunction *)timingFunction;

/*
 *  将视图移动到点。TimingFunction可以为零，默认为kCAMediaTimingFunctionEaseInEaseOut。
 */
- (void)zhh_moveToPoint:(CGPoint)newPoint
               duration:(NSTimeInterval)duration
            autoreverse:(BOOL)autoreverse
            repeatCount:(CGFloat)repeatCount
         timingFunction:(CAMediaTimingFunction *)timingFunction;

@end

NS_ASSUME_NONNULL_END
