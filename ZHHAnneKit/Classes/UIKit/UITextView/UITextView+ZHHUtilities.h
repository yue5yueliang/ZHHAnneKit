//
//  UITextView+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ZHHUtilities)

/// 获取默认的 placeholder 颜色
/// @return 默认的 placeholder 颜色
+ (UIColor *)zhh_defaultPlaceholderColor;

/// 获取文本视图的观察键列表，用于 KVO 观察
/// @return 观察的键列表
+ (NSArray<NSString *> *)zhh_observingKeys;

/// 获取或设置文本视图的 placeholder 标签
/// @return 返回 placeholder 标签
@property (nonatomic, readonly) UILabel *zhh_placeholderLabel;

/// 获取或设置文本视图的 placeholder 文本
/// @return 返回当前的 placeholder 文本
@property (nonatomic, copy) NSString *zhh_placeholder;

/// 获取或设置文本视图的 attributedPlaceholder
/// @return 返回当前的 attributedPlaceholder
@property (nonatomic, copy) NSAttributedString *zhh_attributedPlaceholder;

/// 获取或设置文本视图的 placeholder 颜色
/// @return 返回当前的 placeholder 颜色
@property (nonatomic, strong) UIColor *zhh_placeholderColor;

/// 判断文本视图是否需要更新字体
/// @return 返回是否需要更新字体
@property (nonatomic, assign) BOOL zhh_needsUpdateFont;
@end

NS_ASSUME_NONNULL_END
