//
//  UIBarButtonItem+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/9/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (ZHHExtend)
/**
 *  快速创建一个 UIBarButtonItem
 *
 *  @param imageName     普通状态下的图片
 *  @param highImageName 高亮状态下的图片
 *  @param target        目标
 *  @param action        操作
 *
 */
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName highImageName:(NSString *_Nullable)highImageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;


/**
 通过系统的方法，初始化一个UIBarButtonItem
 
 @param title 显示的文字，例如'完成'、'取消'
 @param titleColor title的颜色，if nil ，The Color is [UIColor whiteColor]
 @param imageName 图片名称
 @param target target
 @param selector selector
 @param textType 是否是纯文字
 @return init a UIBarButtonItem
 */
+ (UIBarButtonItem *)zhh_systemItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                                    textType:(BOOL)textType;


/**
 通过自定义的方法，快速初始化一个UIBarButtonItem，内部是按钮
 
 @param title 显示的文字，例如'完成'、'取消'
 @param titleColor title的颜色，if nil ，The Color is [UIColor whiteColor]
 @param imageName 图片名称
 @param target target
 @param selector selector
 @param contentHorizontalAlignment 文本对齐方向
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)zhh_customItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *_Nullable)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment;

/**
 快速创建一个导航栏leftBarButtonItem 用于返回（pop）或者（dismiss），切记只能是纯图片 （eg: < or X）
 且可以加大点击范围
 @param title title
 @param imageName 返回按钮的图片
 @param target target
 @param action action
 @return UIBarButtonItem Instance
 */
+ (UIBarButtonItem *)zhh_backItemWithTitle:(NSString *)title
                                 imageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
