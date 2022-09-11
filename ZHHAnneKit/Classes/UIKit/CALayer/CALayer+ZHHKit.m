//
//  CALayer+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "CALayer+ZHHKit.h"

@implementation CALayer (ZHHKit)
- (void)zhh_setBorderColorFromUIColor:(UIColor *)color{
    if (self.borderWidth == 0) self.borderWidth = 0.5;
    self.borderColor = color.CGColor;
}

- (void)zhh_setShadowColorFromUIColor:(UIColor *)color {
    self.shadowColor = color.CGColor;
    if (self.shadowOpacity == 0) {
        self.shadowOpacity = 0.5;
    }
    self.shadowOffset = CGSizeZero;
}

- (void)setZhh_borderUIColor:(UIColor *)zhh_borderUIColor {
    self.borderColor = zhh_borderUIColor.CGColor;
}

- (UIColor*)zhh_borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setZhh_shadowUIColor:(UIColor *)zhh_shadowUIColor{
    self.shadowColor = zhh_shadowUIColor.CGColor;
}
 
- (UIColor *)zhh_shadowUIColor{
    return [UIColor colorWithCGColor:self.shadowColor];
}

/**
 *  转场动画
 *  @param animType 转场动画类型
 *  @param subType  转动动画方向
 *  @param curve    转动动画曲线
 *  @param duration 转动动画时长
 *  @return 转场动画实例
 */
- (CATransition *)zhh_transitionWithAnimType:(TransitionAnimType)animType subType:(TransitionSubType)subType curve:(TransitionCurve)curve duration:(CGFloat)duration{
    
    NSString *key = @"transition";
    if([self animationForKey:key] != nil){
        [self removeAnimationForKey:key];
    }
    
    CATransition *transition    = [CATransition animation];
    //动画时长
    transition.duration         = duration;
    //动画类型
    transition.type             = [self zhh_animaTypeWithTransitionType:animType];
    //动画方向
    transition.subtype          = [self zhh_animaSubtype:subType];
    //缓动函数
    transition.timingFunction   = [CAMediaTimingFunction functionWithName:[self zhh_curve:curve]];
    //完成动画删除
    transition.removedOnCompletion = YES;
    [self addAnimation:transition forKey:key];
    return transition;
}

// 返回动画曲线
- (NSString *)zhh_curve:(TransitionCurve)curve{
    //曲线数组
    NSArray *funcNames = @[kCAMediaTimingFunctionDefault,
                           kCAMediaTimingFunctionEaseIn,
                           kCAMediaTimingFunctionEaseInEaseOut,
                           kCAMediaTimingFunctionEaseOut,
                           kCAMediaTimingFunctionLinear];
    return [self zhh_objFromArray:funcNames index:curve isRamdom:(TransitionCurveRamdom == curve)];
}

/** 返回动画方向 */
- (NSString *)zhh_animaSubtype:(TransitionSubType)subType{
    /// 设置转场动画的方向
    NSArray *subtypes = @[kCATransitionFromTop,kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromRight];
    return [self zhh_objFromArray:subtypes index:subType isRamdom:(TransitionSubtypesFromRamdom == subType)];
}

/** 返回动画类型 */
- (NSString *)zhh_animaTypeWithTransitionType:(TransitionAnimType)type{
    /// 设置转场动画的类型
    NSArray *animArray = @[@"rippleEffect",@"suckEffect",@"pageCurl",@"oglFlip",@"cube",@"reveal",@"pageUnCurl"];
    return [self zhh_objFromArray:animArray index:type isRamdom:(TransitionAnimTypeRamdom == type)];
}

/** 统一从数据返回对象 */
- (id)zhh_objFromArray:(NSArray *)array index:(NSUInteger)index isRamdom:(BOOL)isRamdom{
    NSUInteger count = array.count;
    NSUInteger i = isRamdom?arc4random_uniform((u_int32_t)count) : index;
    return array[i];
}
@end
