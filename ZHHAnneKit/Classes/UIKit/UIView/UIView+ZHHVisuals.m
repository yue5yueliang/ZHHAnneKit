//
//  UIView+ZHHVisuals.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHVisuals.h"


// Degree -> Rad
#define zhh_degToRad(x) (M_PI * (x) / 180.0)
@implementation UIView (ZHHVisuals)
/*
 * 设置半径角，给定笔划大小和颜色
 */
- (void)zhh_cornerRadius:(CGFloat)radius strokeSize:(CGFloat)size color:(UIColor *)color {
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = size;
}

/*
 *  使用属性绘制阴影
 */
- (void)zhh_shadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.clipsToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

/*
 * 从带有淡入效果的超级视图中删除
 */
- (void)zhh_removeFromSuperviewWithFadeDuration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

/*
 * 添加具有给定过渡持续时间的子视图（&D）
 */
- (void)zhh_addSubview:(UIView *)subview withTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration {
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: duration];
    [UIView setAnimationTransition: transition forView: self cache: YES];
    [self addSubview: subview];
    [UIView commitAnimations];
}

/*
 * 从具有给定过渡持续时间的超级视图中删除视图（&D）
 */
- (void)zhh_removeFromSuperviewWithTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: duration];
    [UIView setAnimationTransition: transition forView:self.superview cache:YES];
    [self removeFromSuperview];
    [UIView commitAnimations];
}

/*
 * 按给定角度旋转视图。TimingFunction可以为零，默认为kCAMediaTimingFunctionEaseInEaseOut。
 */
- (void)zhh_rotateByAngle:(CGFloat)angle
                 duration:(NSTimeInterval)duration
              autoreverse:(BOOL)autoreverse
              repeatCount:(CGFloat)repeatCount
           timingFunction:(CAMediaTimingFunction *)timingFunction {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
    rotation.toValue = [NSNumber numberWithFloat: zhh_degToRad(angle)];
    rotation.duration = duration;
    rotation.repeatCount = repeatCount;
    rotation.autoreverses = autoreverse;
    rotation.removedOnCompletion = NO;
    rotation.fillMode = kCAFillModeBoth;
    rotation.timingFunction = timingFunction != nil ? timingFunction : [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation: rotation forKey: @"rotationAnimation"];
}

/*
 *  将视图移动到点。TimingFunction可以为零，默认为kCAMediaTimingFunctionEaseInEaseOut。
 */
- (void)zhh_moveToPoint:(CGPoint)newPoint
               duration:(NSTimeInterval)duration
            autoreverse:(BOOL)autoreverse
            repeatCount:(CGFloat)repeatCount
         timingFunction:(CAMediaTimingFunction *)timingFunction {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath: @"position"];
    move.toValue = [NSValue valueWithCGPoint: newPoint];
    move.duration = duration;
    move.removedOnCompletion = NO;
    move.repeatCount = repeatCount;
    move.autoreverses = autoreverse;
    move.fillMode = kCAFillModeBoth;
    move.timingFunction = timingFunction != nil ? timingFunction : [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation: move forKey: @"positionAnimation"];
}

@end
