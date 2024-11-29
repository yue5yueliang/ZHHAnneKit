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

- (NSObject *)zhh_identifier {
    return objc_getAssociatedObject(self, &ZHHIdentifier);
}

- (void)setZhh_identifier:(NSString *)zhh_identifier{
    objc_setAssociatedObject(self, &ZHHIdentifier, zhh_identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark --- 创建默认按钮--有标题、字体、颜色
+ (instancetype)zhh_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

#pragma mark --- 获取按钮额外的点击热区
/// 获取按钮额外的点击热区
- (UIEdgeInsets)zhh_touchAreaInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(zhh_touchAreaInsets));
    if (value) {
        return [value UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero; // 默认无扩展
}

/// 设置按钮额外的点击热区
/// @param touchAreaInsets 额外热区范围（使用负值可缩小点击范围）
- (void)setZhh_touchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(zhh_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 修改按钮点击区域，使用自定义热区
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.zhh_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

#pragma mark --- 添加点击事件
/// 添加点击事件，默认UIControlEventTouchUpInside
- (void)zhh_addActionHandler:(ZHHTouchedButtonBlock)touchHandler{
    [self zhh_addActionHandler:touchHandler forControlEvents:UIControlEventTouchUpInside];
}

/// 添加事件，支持自定义 UIControlEvents
- (void)zhh_addActionHandler:(ZHHTouchedButtonBlock)touchHandler forControlEvents:(UIControlEvents)controlEvents {
    // 绑定事件 block 到 UIButton
    objc_setAssociatedObject(self, ZHHUIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 绑定点击事件
    [self addTarget:self action:@selector(zhh_blockActionTouched:) forControlEvents:controlEvents];
}

#pragma mark - 触发事件的处理方法
/// 按钮点击触发方法
- (void)zhh_blockActionTouched:(UIButton *)sender {
    ZHHTouchedButtonBlock touchHandler = objc_getAssociatedObject(self, ZHHUIButtonBlockKey);
    if (touchHandler) {
        touchHandler(sender);
    }
}

@end
