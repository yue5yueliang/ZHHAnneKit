//
//  UIBarButtonItem+UINavigationButton.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (UINavigationButton)
/// 使用自定义 UIButton 创建 UIBarButtonItem
+ (instancetype)zhh_itemWithButton:(UIButton *)button target:(_Nullable id)target action:(_Nullable SEL)action;

/// 使用图片创建 UIBarButtonItem
+ (instancetype)zhh_itemWithImage:(UIImage *)image target:(_Nullable id)target action:(_Nullable SEL)action;

/// 使用文字创建 UIBarButtonItem（系统默认字体）
+ (instancetype)zhh_itemWithTitle:(NSString *)title target:(_Nullable id)target action:(_Nullable SEL)action;

/// 使用加粗文字创建 UIBarButtonItem（boldSystemFont）
+ (instancetype)zhh_itemWithBoldTitle:(NSString *)title target:(_Nullable id)target action:(_Nullable SEL)action;

/// 创建返回样式的 UIBarButtonItem（带可选文字）
+ (instancetype)zhh_backItemWithTitle:(nullable NSString *)title target:(_Nullable id)target action:(_Nullable SEL)action;

/// 创建固定宽度的占位 UIBarButtonItem（一般用于左/右间距调整）
+ (instancetype)zhh_fixedSpaceItemWithWidth:(CGFloat)width;

/// 创建 flexible space（自动撑开中间空隙）
+ (instancetype)zhh_flexibleSpaceItem;

@end

NS_ASSUME_NONNULL_END
