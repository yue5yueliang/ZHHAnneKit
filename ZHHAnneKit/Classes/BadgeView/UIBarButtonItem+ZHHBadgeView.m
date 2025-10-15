//
//  UIBarButtonItem+ZHHBadgeView.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIBarButtonItem+ZHHBadgeView.h"

@implementation UIBarButtonItem (ZHHBadgeView)

/// 返回 Badge 视图
/// @return 绑定在父视图上的 `ZHHBadgeControl` 对象
- (ZHHBadgeControl *)badgeView {
    return [self zhh_bottomView].badgeView;
}

/// 添加带有文本内容的 Badge
/// @param text 要显示的文本内容
- (void)zhh_addBadgeWithText:(NSString *)text {
    [[self zhh_bottomView] zhh_addBadgeWithText:text];
}

/// 添加带有数字内容的 Badge
/// @param value 要显示的数字内容
- (void)zhh_addBadgeWithValue:(NSInteger)value {
    [[self zhh_bottomView] zhh_addBadgeWithValue:value];
}

/// 添加带有颜色的小圆点 Badge
/// @param color 圆点的颜色
- (void)zhh_addDotWithColor:(UIColor *)color {
    [[self zhh_bottomView] zhh_addDotWithColor:color];
}

/// 设置 Badge 的高度
/// @param height Badge 的高度
- (void)zhh_setBadgeHeight:(CGFloat)height {
    [[self zhh_bottomView] zhh_setBadgeHeight:height];
}

/// 设置 Badge 的伸缩模式
/// @param flexMode 伸缩模式，指定内容的布局方式
- (void)zhh_setBadgeFlexMode:(ZHHBadgeViewFlexMode)flexMode {
    [[self zhh_bottomView] zhh_setBadgeFlexMode:flexMode];
}

/// 设置 Badge 的偏移量
/// @param x X 轴偏移量
/// @param y Y 轴偏移量
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

/// 数字增加 1
- (void)zhh_incrementBadge {
    [[self zhh_bottomView] zhh_incrementBadge];
}

/// 数字增加指定值
/// @param value 增加的数值
- (void)zhh_incrementBadgeBy:(NSInteger)value {
    [[self zhh_bottomView] zhh_incrementBadgeBy:value];
}

/// 数字减少 1
- (void)zhh_decrementBadge {
    [[self zhh_bottomView] zhh_decrementBadge];
}

/// 数字减少指定值
/// @param value 减少的数值
- (void)zhh_decrementBadgeBy:(NSInteger)value {
    [[self zhh_bottomView] zhh_decrementBadgeBy:value];
}

#pragma mark - 获取 Badge 的父视图
- (UIView *)zhh_bottomView {
    // 使用 Xcode 视图调试工具发现 UIBarButtonItem 的 Badge 父视图为 UIButton
    UIView *navigationButton = [self valueForKey:@"_view"];
    
    // 添加空值检查
    if (!navigationButton) {
                NSLog(@"ZHHAnneKit 警告: 无法获取 UIBarButtonItem 的导航按钮");
        return nil;
    }
    
    for (UIView *subView in navigationButton.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.masksToBounds = NO; // 取消裁剪以便显示 Badge
            return subView;
        }
    }
    return navigationButton;
}
@end
