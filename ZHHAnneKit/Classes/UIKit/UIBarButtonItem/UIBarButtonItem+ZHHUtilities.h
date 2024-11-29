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
/// 当UIBarButtonItem被点击时运行的块。
@property (nonatomic, copy) ZHHBarButtonActionBlock zhh_actionBlock;
/**
 * @brief 快速创建一个带图片的 UIBarButtonItem
 *
 * @discussion
 * 通过自定义的按钮创建方式，快速生成一个带普通图片和高亮图片状态的 UIBarButtonItem，适用于导航栏的按钮。
 *
 * @param imageName 普通状态下显示的图片名称（不能为空）
 * @param highImageName 高亮状态下显示的图片名称（可选，若为 nil，则无高亮效果）
 * @param target 按钮点击事件的目标对象
 * @param action 按钮点击事件的选择器
 *
 * @return 创建的 UIBarButtonItem 实例
 */
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *_Nullable)imageName highImageName:(NSString *_Nullable)highImageName target:(id)target action:(SEL)action;

/**
 * @brief 快速创建一个带图片的 UIBarButtonItem（无高亮效果）
 *
 * @discussion
 * 此方法仅创建一个带普通状态图片的 UIBarButtonItem，适合不需要高亮状态的情况。
 *
 * @param imageName 普通状态下显示的图片名称（不能为空）
 * @param target 按钮点击事件的目标对象
 * @param action 按钮点击事件的选择器
 *
 * @return 创建的 UIBarButtonItem 实例
 */
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

/**
 * @brief 使用系统方法初始化一个 UIBarButtonItem
 *
 * @discussion
 * 此方法通过系统提供的初始化方式，快速生成一个包含文字或图片的 UIBarButtonItem。
 * 可选择生成纯文字类型或图片类型的按钮，常用于导航栏操作按钮的创建。
 *
 * @param title 按钮标题（如“完成”或“取消”，当 textType 为 YES 时有效）
 * @param titleColor 按钮标题颜色（若为 nil，默认为 [UIColor whiteColor]）
 * @param imageName 按钮图片名称（当 textType 为 NO 时有效）
 * @param target 按钮点击事件的目标对象
 * @param selector 按钮点击事件的选择器
 * @param textType 是否为纯文字按钮（YES 表示纯文字，NO 表示图片按钮）
 *
 * @return 一个系统初始化的 UIBarButtonItem 实例
 */
+ (UIBarButtonItem *)zhh_systemItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                                    textType:(BOOL)textType;


/**
 * @brief 快速创建一个包含自定义按钮的 UIBarButtonItem
 *
 * @discussion
 * 该方法通过自定义按钮快速生成 UIBarButtonItem，按钮可设置标题、图片和对齐方式。
 * 常用于导航栏按钮的创建。
 *
 * @param title 按钮标题（如“完成”或“取消”，可选）
 * @param titleColor 按钮标题颜色（若为 nil，默认为 [UIColor whiteColor]）
 * @param imageName 按钮图片名称（可选）
 * @param target 按钮点击事件的目标对象
 * @param selector 按钮点击事件的选择器
 * @param contentHorizontalAlignment 按钮内容的水平对齐方式
 *
 * @return 自定义的 UIBarButtonItem 实例
 */
+ (UIBarButtonItem *)zhh_customItemWithTitle:(NSString *_Nullable)title
                                  titleColor:(UIColor *_Nullable)titleColor
                                   imageName:(NSString *_Nullable)imageName
                                      target:(id _Nullable)target
                                    selector:(SEL _Nullable)selector
                  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment;

/**
 * @brief 快速创建一个导航栏左侧返回按钮（leftBarButtonItem），支持 pop 或 dismiss 操作
 *
 * @discussion
 * 按钮为纯图片（如 "<" 或 "X" 样式），可设置标题文字（title 可选）。
 * 按钮点击区域经过优化，增加了点击范围，便于操作。
 *
 * @param title 按钮的标题（可选）
 * @param imageName 按钮图片的名称（纯图片，必传）
 * @param target 按钮点击事件的目标对象
 * @param action 按钮点击事件的选择器
 *
 * @return UIBarButtonItem 实例
 */
+ (UIBarButtonItem *)zhh_backItemWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(id _Nullable)target action:(SEL _Nullable)action;
@end

NS_ASSUME_NONNULL_END
