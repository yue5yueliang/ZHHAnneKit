//
//  CALayer+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "CALayer+ZHHUtilities.h"

@implementation CALayer (ZHHUtilities)
/// 添加转场动画
/// @param animType 动画类型
/// @param subType 动画方向
/// @param curve 动画曲线
/// @param duration 动画时长
/// @return 转场动画实例
- (CATransition *)zhh_transitionWithAnimType:(ZHHTransitionAnimType)animType subType:(ZHHTransitionSubType)subType curve:(ZHHTransitionCurve)curve duration:(CGFloat)duration {
    NSString *key = @"zhh_transition";
    // 检查是否已有相同动画，避免冲突
    if ([self animationForKey:key] != nil) {
        [self removeAnimationForKey:key];
    }
    
    // 创建转场动画
    CATransition *transition = [CATransition animation];
    transition.duration = duration; // 设置动画时长
    transition.type = [self zhh_typeForAnimType:animType]; // 设置动画类型
    transition.subtype = [self zhh_subtypeForAnimSubType:subType]; // 设置动画方向
    transition.timingFunction = [CAMediaTimingFunction functionWithName:[self zhh_curveForAnimCurve:curve]]; // 设置动画曲线
    transition.removedOnCompletion = YES; // 动画完成后移除
    
    // 添加动画到图层
    [self addAnimation:transition forKey:key];
    return transition;
}

/// 获取动画曲线名称
/// @param curve 动画曲线类型
/// @return 对应的曲线名称
- (NSString *)zhh_curveForAnimCurve:(ZHHTransitionCurve)curve {
    NSArray *curveOptions = @[
        kCAMediaTimingFunctionDefault,
        kCAMediaTimingFunctionEaseIn,
        kCAMediaTimingFunctionEaseOut,
        kCAMediaTimingFunctionEaseInEaseOut,
        kCAMediaTimingFunctionLinear
    ];
    return [self zhh_objectFromArray:curveOptions index:curve isRandom:(curve == ZHHTransitionCurveRamdom)];
}

/// 获取动画方向
/// @param subType 动画方向类型
/// @return 对应的方向名称
- (NSString *)zhh_subtypeForAnimSubType:(ZHHTransitionSubType)subType {
    NSArray *subtypeOptions = @[
        kCATransitionFromTop,
        kCATransitionFromLeft,
        kCATransitionFromBottom,
        kCATransitionFromRight
    ];
    return [self zhh_objectFromArray:subtypeOptions index:subType isRandom:(subType == ZHHTransitionSubtypesFromRamdom)];
}

/// 获取动画类型
/// @param animType 动画类型
/// @return 对应的类型名称
- (NSString *)zhh_typeForAnimType:(ZHHTransitionAnimType)animType {
    NSArray *animOptions = @[
        @"rippleEffect", // 波纹
        @"suckEffect",   // 吸收
        @"pageCurl",     // 向上翻页
        @"oglFlip",      // 翻转
        @"cube",         // 立方体
        @"reveal",       // 揭示
        @"pageUnCurl"    // 向下翻页
    ];
    return [self zhh_objectFromArray:animOptions index:animType isRandom:(animType == ZHHTransitionAnimTypeRamdom)];
}

/// 从数组中获取对象
/// @param array 对象数组
/// @param index 索引
/// @param isRandom 是否随机
/// @return 对应的对象
- (id)zhh_objectFromArray:(NSArray *)array index:(NSUInteger)index isRandom:(BOOL)isRandom {
    NSUInteger count = array.count;
    NSUInteger finalIndex = isRandom ? arc4random_uniform((u_int32_t)count) : index;
    return array[finalIndex];
}

@end
