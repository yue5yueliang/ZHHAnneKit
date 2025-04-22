//
//  UIButton+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHCommon.h"
#import <objc/runtime.h>

static char * const ZHHIdentifier = "zhh_identifier";
static const void *ZHHUIButtonBlockKey = &ZHHUIButtonBlockKey;

@implementation UIButton (ZHHCommon)

#pragma mark - 关联标识

/// 获取按钮的唯一标识
- (NSObject *)zhh_identifier {
    return objc_getAssociatedObject(self, &ZHHIdentifier);
}

/// 设置按钮的唯一标识
- (void)setZhh_identifier:(NSString *)zhh_identifier{
    objc_setAssociatedObject(self, &ZHHIdentifier, zhh_identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 创建按钮

/// 创建一个带有标题、字体和颜色的按钮
/// @param title 按钮标题
/// @param titleColor 按钮字体颜色
/// @param font 按钮字体
+ (instancetype)zhh_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

#pragma mark - 点击热区

/// 获取按钮的额外点击热区
- (UIEdgeInsets)zhh_touchAreaInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(zhh_touchAreaInsets));
    return value ? [value UIEdgeInsetsValue] : UIEdgeInsetsZero;
}

/// 设置按钮的额外点击热区
/// @param touchAreaInsets 额外热区范围（可使用负值缩小点击范围）
- (void)setZhh_touchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(zhh_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 添加点击事件

/// 为按钮添加默认点击事件（UIControlEventTouchUpInside）
- (void)zhh_addActionHandler:(ZHHTouchedButtonBlock)touchHandler {
    [self zhh_addActionHandler:touchHandler forControlEvents:UIControlEventTouchUpInside];
}

/// 为按钮添加自定义事件类型
/// @param touchHandler 点击事件的回调
/// @param controlEvents 自定义的事件类型
- (void)zhh_addActionHandler:(ZHHTouchedButtonBlock)touchHandler forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, ZHHUIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(zhh_blockActionTouched:) forControlEvents:controlEvents];
}

#pragma mark - 触发事件

/// 按钮点击事件触发的方法
- (void)zhh_blockActionTouched:(UIButton *)sender {
    ZHHTouchedButtonBlock touchHandler = objc_getAssociatedObject(self, ZHHUIButtonBlockKey);
    if (touchHandler) {
        touchHandler(sender);
    }
}

@end
