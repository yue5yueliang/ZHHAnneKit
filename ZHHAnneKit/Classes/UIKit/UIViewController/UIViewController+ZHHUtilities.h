//
//  UIViewController+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZHHUtilities) <UINavigationControllerDelegate>

/// 通过类名字符串跳转到指定的 ViewController
/// @param className 控制器类名字符串
- (void)zhh_pushViewControllerWithClassName:(NSString *)className;

/// 通过类名字符串跳转到指定的 ViewController
/// @param className 控制器类名字符串
/// @param titleName 控制器标题
- (void)zhh_pushViewControllerWithClassName:(NSString *)className title:(NSString *)titleName;

/// 跳转回指定控制器
/// @param clazz 指定控制器的类
/// @param complete 跳转完成的回调，返回目标控制器实例
/// @return 是否成功找到并跳转到目标控制器
- (BOOL)zhh_popTargetViewController:(Class)clazz complete:(void(^)(UIViewController *vc))complete;

/// 切换根视图控制器
/// @param complete 切换完成的回调，返回成功与否的布尔值
- (void)zhh_changeRootViewController:(void(^)(BOOL success))complete;

/// 获取当前显示的控制器
+ (UIViewController *)zhh_currentViewController;

/// 是否开启侧滑返回手势
/// @param open 是否开启
- (void)zhh_openPopGesture:(BOOL)open;

/// 调起系统自带分享功能
/// @param items 要分享的内容数组
/// @param complete 分享完成的回调
/// @return 返回系统分享的活动视图控制器
- (UIActivityViewController *)zhh_shareActivityWithItems:(NSArray *)items complete:(void(^)(BOOL success))complete;
@end

NS_ASSUME_NONNULL_END
