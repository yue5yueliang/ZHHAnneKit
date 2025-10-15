//
//  CALayer+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZHHUtilities)

/// 转场动画类型
typedef NS_ENUM(NSInteger, ZHHTransitionAnimType) {
    /// 波纹效果
    ZHHTransitionAnimTypeRippleEffect = 0,
    /// 吸收效果
    ZHHTransitionAnimTypeSuckEffect,
    /// 向上翻页效果
    ZHHTransitionAnimTypePageCurl,
    /// 翻转效果
    ZHHTransitionAnimTypeOglFlip,
    /// 立方体效果
    ZHHTransitionAnimTypeCube,
    /// 揭示效果
    ZHHTransitionAnimTypeReveal,
    /// 向下翻页效果
    ZHHTransitionAnimTypePageUnCurl,
    /// 随机动画效果
    ZHHTransitionAnimTypeRamdom,
};

/// 转场动画方向
typedef NS_ENUM(NSInteger, ZHHTransitionSubType) {
    /// 从顶部进入
    ZHHTransitionSubtypesFromTop = 0,
    /// 从左侧进入
    ZHHTransitionSubtypesFromLeft,
    /// 从底部进入
    ZHHTransitionSubtypesFromBottom,
    /// 从右侧进入
    ZHHTransitionSubtypesFromRight,
    /// 随机方向
    ZHHTransitionSubtypesFromRamdom,
};

/// 转场动画曲线
typedef NS_ENUM(NSInteger, ZHHTransitionCurve) {
    /// 默认曲线
    ZHHTransitionCurveDefault = 0,
    /// 加速进入
    ZHHTransitionCurveEaseIn,
    /// 加速退出
    ZHHTransitionCurveEaseOut,
    /// 加速进入并减速退出
    ZHHTransitionCurveEaseInEaseOut,
    /// 线性曲线
    ZHHTransitionCurveLinear,
    /// 随机曲线
    ZHHTransitionCurveRamdom,
};

/// 添加转场动画
/// @param animType 动画类型
/// @param subType 动画方向
/// @param curve 动画曲线
/// @param duration 动画时长
/// @return 转场动画实例
- (CATransition *)zhh_transitionWithAnimType:(ZHHTransitionAnimType)animType subType:(ZHHTransitionSubType)subType curve:(ZHHTransitionCurve)curve duration:(CGFloat)duration;

/// 用于在 Interface Builder (Storyboard) 里直接设置 `borderColor`
/// @param color 需要设置的边框颜色 (`UIColor`)
- (void)zhh_setBorderColor:(UIColor *)color;

/// 用于在 Interface Builder (Storyboard) 里直接设置 `shadowColor`
/// @param color 需要设置的阴影颜色 (`UIColor`)
- (void)zhh_setShadowColor:(UIColor *)color;

/// @brief  需要注意：
/// - 如果要 **同时** 设置圆角（cornerRadius）和阴影（shadow），
/// 请 **先设置阴影**，然后再设置圆角，否则可能会导致阴影效果被裁剪
/// `borderColor` 的 `UIColor` 便捷设置属性
@property (nonatomic, strong) UIColor *zhh_borderColor;
/// `shadowColor` 的 `UIColor` 便捷设置属性
@property (nonatomic, strong) UIColor *zhh_shadowColor;
@end

NS_ASSUME_NONNULL_END
