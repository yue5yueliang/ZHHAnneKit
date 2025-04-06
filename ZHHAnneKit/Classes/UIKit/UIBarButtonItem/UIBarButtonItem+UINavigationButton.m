//
//  UIBarButtonItem+UINavigationButton.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIBarButtonItem+ZHHUtilities.h"


@implementation UIBarButtonItem (UINavigationButton)
/// 使用自定义 UIButton 创建 UIBarButtonItem（适合自定义布局）
+ (instancetype)zhh_itemWithButton:(UIButton *)button target:(_Nullable id)target action:(_Nullable SEL)action {
    if (!button) return nil;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

/// 使用 UIImage 创建 UIBarButtonItem（系统默认布局）
+ (instancetype)zhh_itemWithImage:(UIImage *)image target:(_Nullable id)target action:(_Nullable SEL)action {
    if (!image) return nil;
    return [[self alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

/// 使用普通文字创建 UIBarButtonItem（系统默认字体，Plain 样式）
+ (instancetype)zhh_itemWithTitle:(NSString *)title target:(_Nullable id)target action:(_Nullable SEL)action {
    if (!title) return nil;
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

/// 使用粗体文字创建 UIBarButtonItem（系统 Done 样式，字体略粗）
+ (instancetype)zhh_itemWithBoldTitle:(NSString *)title target:(_Nullable id)target action:(_Nullable SEL)action {
    if (!title) return nil;
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
}

/// 创建固定间距的 UIBarButtonItem（用于 layout 调整）
+ (instancetype)zhh_fixedSpaceItemWithWidth:(CGFloat)width {
    UIBarButtonItem *item = [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    item.width = width;
    return item;
}

/// 创建自动拉伸的 flexible space（常用于 Toolbar）
+ (instancetype)zhh_flexibleSpaceItem {
    return [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
}
@end
