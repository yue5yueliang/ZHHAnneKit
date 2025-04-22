//
//  UIBarButtonItem+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ZHHBarButtonActionBlock)(void);

@interface UIBarButtonItem (ZHHUtilities)

/// 当 UIBarButtonItem 被点击时执行的回调块
@property (nonatomic, copy) ZHHBarButtonActionBlock zhh_actionBlock;

#pragma mark - 基础图片按钮

/// 创建带图片的 UIBarButtonItem（无高亮图）
/// @param imageName 普通状态图片
/// @param target 目标对象
/// @param action 响应事件
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action;

/// 创建带图片的 UIBarButtonItem（可选高亮图）
/// @param imageName 普通状态图片
/// @param highImageName 高亮状态图片（可选）
/// @param target 目标对象
/// @param action 响应事件
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *_Nullable)imageName
                             highImageName:(NSString *_Nullable)highImageName
                                    target:(id)target
                                    action:(SEL)action;

#pragma mark - 系统样式按钮（支持纯文字 / 图片）

/// 使用系统方式创建 UIBarButtonItem（支持文字或图片）
/// @param title 按钮标题
/// @param titleColor 标题颜色
/// @param imageName 图片名称
/// @param target 目标对象
/// @param selector 响应事件
/// @param textType 是否为纯文字按钮
+ (UIBarButtonItem *)zhh_systemItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                                    textType:(BOOL)textType;

#pragma mark - 自定义按钮（支持文字+图片+对齐）

/// 创建自定义按钮的 UIBarButtonItem
/// @param title 按钮标题
/// @param titleColor 标题颜色
/// @param imageName 图片名称
/// @param target 目标对象
/// @param selector 响应事件
/// @param contentHorizontalAlignment 水平对齐方式
+ (UIBarButtonItem *)zhh_customItemWithTitle:(NSString *_Nullable)title
                                  titleColor:(UIColor *_Nullable)titleColor
                                   imageName:(NSString *_Nullable)imageName
                                      target:(id _Nullable)target
                                    selector:(SEL _Nullable)selector
                  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment;

#pragma mark - 返回按钮样式

/// 创建导航栏返回按钮（图片 + 可选文字）
/// @param title 按钮标题（可选）
/// @param imageName 图片名称
/// @param target 目标对象
/// @param action 响应事件
+ (UIBarButtonItem *)zhh_backItemWithTitle:(NSString *_Nullable)title
                                 imageName:(NSString *_Nullable)imageName
                                    target:(id _Nullable)target
                                    action:(SEL _Nullable)action;
@end

NS_ASSUME_NONNULL_END
