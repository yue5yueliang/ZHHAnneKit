//
//  CALayer+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZHHExtend)
/**
 用于 storyboard 的 runtime 中设置borderColor;
 
 @param color UIColor
 */
- (void)zhh_setBorderColorFromUIColor:(UIColor *)color;

/**
 用于 storyboard 的 runtime 中设置shadowColor;
 
 @param color UIColor
 */
- (void)zhh_setShadowColorFromUIColor:(UIColor *)color;

//注意：如果你想设置圆角的同时设置阴影，那你就先设置阴影后设置圆角
@property(nonatomic, strong) UIColor *zhh_borderUIColor;
@property(nonatomic, strong) UIColor *zhh_shadowUIColor;

// 动画类型
typedef NS_ENUM(NSInteger, TransitionAnimType){
    /// 波纹
    TransitionAnimTypeRippleEffect=0,
    /// 吸收
    TransitionAnimTypeSuckEffect,
    /// 向上翻一页
    TransitionAnimTypePageCurl,
    /// 翻转
    TransitionAnimTypeOglFlip,
    /// 立方体
    TransitionAnimTypeCube,
    /// 揭示
    TransitionAnimTypeReveal,
    /// 向下翻一页
    TransitionAnimTypePageUnCurl,
    TransitionAnimTypeRamdom,
};

// 方向
typedef NS_ENUM(NSInteger, TransitionSubType){
    TransitionSubtypesFromTop=0,
    TransitionSubtypesFromLeft,
    TransitionSubtypesFromBotoom,
    TransitionSubtypesFromRight,
    TransitionSubtypesFromRamdom,
};

// 动画曲线
typedef NS_ENUM(NSInteger, TransitionCurve) {
    TransitionCurveDefault,
    TransitionCurveEaseIn,
    TransitionCurveEaseOut,
    TransitionCurveEaseInEaseOut,
    TransitionCurveLinear,
    TransitionCurveRamdom,
};

/**
 *  转场动画
 *
 *  @param animType 转场动画类型
 *  @param subType  转动动画方向
 *  @param curve    转动动画曲线
 *  @param duration 转动动画时长
 *
 *  @return 转场动画实例
 */
- (CATransition *)zhh_transitionWithAnimType:(TransitionAnimType)animType subType:(TransitionSubType)subType curve:(TransitionCurve)curve duration:(CGFloat)duration;
@end

NS_ASSUME_NONNULL_END
