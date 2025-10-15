//
//  UITabBarItem+ZHHBadgeView.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITabBarItem+ZHHBadgeView.h"

@implementation UITabBarItem (ZHHBadgeView)
#pragma mark - Badge 相关功能扩展

/// 获取或创建 `ZHHBadgeControl` 对象
- (ZHHBadgeControl *)badgeView {
    return [self zhh_bottomView].badgeView;
}

/// 添加带文本的 Badge
/// @param text 显示的文本内容
- (void)zhh_addBadgeWithText:(NSString *)text {
    // 调用底部视图的方法
    [[self zhh_bottomView] zhh_addBadgeWithText:text];
    // 设置默认偏移量，确保位置正确
    [[self zhh_bottomView] zhh_moveBadgeWithX:4 Y:3];
}

/// 添加带数字的 Badge
/// @param value 显示的数字
- (void)zhh_addBadgeWithValue:(NSInteger)value {
    [[self zhh_bottomView] zhh_addBadgeWithValue:value];
    [[self zhh_bottomView] zhh_moveBadgeWithX:4 Y:3];
}

/// 添加红点类型的 Badge
/// @param color 红点的颜色
- (void)zhh_addDotWithColor:(UIColor *)color {
    [[self zhh_bottomView] zhh_addDotWithColor:color];
}

/// 设置 Badge 的高度
/// @param height 高度值
- (void)zhh_setBadgeHeight:(CGFloat)height {
    [[self zhh_bottomView] zhh_setBadgeHeight:height];
}

/// 设置 Badge 的伸缩模式
/// @param flexMode `ZHHBadgeViewFlexMode` 伸缩模式
- (void)zhh_setBadgeFlexMode:(ZHHBadgeViewFlexMode)flexMode {
    [[self zhh_bottomView] zhh_setBadgeFlexMode:flexMode];
}

/// 调整 Badge 的位置偏移
/// @param x X 轴偏移
/// @param y Y 轴偏移
- (void)zhh_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y {
    [[self zhh_bottomView] zhh_moveBadgeWithX:x Y:y];
}

/// 显示 Badge
- (void)zhh_showBadge {
    [[self zhh_bottomView] zhh_showBadge];
}

/// 隐藏 Badge
- (void)zhh_hiddenBadge {
    [[self zhh_bottomView] zhh_hiddenBadge];
}

/// 增加 Badge 数字
- (void)zhh_incrementBadge {
    [[self zhh_bottomView] zhh_incrementBadge];
}

/// 增加指定数值的 Badge
/// @param value 增加的数值
- (void)zhh_incrementBadgeBy:(NSInteger)value {
    [[self zhh_bottomView] zhh_incrementBadgeBy:value];
}

/// 减少 Badge 数字
- (void)zhh_decrementBadge {
    [[self zhh_bottomView] zhh_decrementBadge];
}

/// 减少指定数值的 Badge
/// @param value 减少的数值
- (void)zhh_decrementBadgeBy:(NSInteger)value {
    [[self zhh_bottomView] zhh_decrementBadgeBy:value];
}

#pragma mark - 获取 Badge 的父视图

/// 获取 UITabBarItem 的底层视图
/// 通过视图层级分析，Badge 通常添加在 UIImageView 上
- (UIView *)zhh_bottomView {
    // 利用 KVC 获取底层视图对象
    UIView *tabBarButton = [self valueForKey:@"_view"];
    if (!tabBarButton) {
        NSLog(@"ZHHAnneKit 警告: 无法获取 UITabBarItem 的标签栏按钮");
        return nil; // 防止获取失败导致崩溃
    }

    // 遍历子视图，优先找到 UIImageView 类型视图作为 Badge 的父视图
    for (UIView *subView in tabBarButton.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UIImageView")]) {
            return subView; // 返回找到的 UIImageView
        }
    }

    // 若未找到 UIImageView，则默认返回 TabBarButton 本身
    return tabBarButton;
}
@end
