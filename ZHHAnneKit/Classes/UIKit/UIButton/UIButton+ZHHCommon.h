//
//  UIButton+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZHHTouchedButtonBlock)(UIButton * sender);

@interface UIButton (ZHHCommon)

/// 自定义button的唯一标识符
@property (nonatomic, copy) NSString *zhh_identifier;

/// 按钮的点击区域扩展值（负值可缩小点击区域）
@property (nonatomic, assign) UIEdgeInsets zhh_touchAreaInsets;

#pragma mark - 创建按钮

/// 创建普通按钮
/// @param title 按钮标题
/// @param titleColor 字体颜色
/// @param font 字号
/// @return 返回 UIButton 实例
+ (instancetype)zhh_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

#pragma mark - 点击事件处理

/// 添加点击事件，默认事件类型为 UIControlEventTouchUpInside
/// @param touchHandler 点击事件的回调 block
- (void)zhh_addActionHandler:(ZHHTouchedButtonBlock)touchHandler;

/// 添加事件，支持自定义事件类型
/// @param touchHandler 点击事件的回调 block
/// @param controlEvents 控件事件类型（如 UIControlEventTouchDown、UIControlEventTouchUpInside 等）
- (void)zhh_addActionHandler:(ZHHTouchedButtonBlock)touchHandler forControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
