//
//  UIWindow+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIWindow+ZHHUtilities.h"

@implementation UIWindow (ZHHUtilities)

/// 获取当前最上层的视图控制器。
/// 会递归查找 `presentedViewController`，返回当前正在显示的控制器。
/// @return 最顶层的 UIViewController。
- (UIViewController *)zhh_topMostController {
    // 获取根视图控制器
    UIViewController *topController = [self rootViewController];
    
    // 遍历找到最上层控制器
    while ([topController presentedViewController]) {
        // 如果有 presentedViewController（模态视图控制器），继续向上查找
        topController = [topController presentedViewController];
    }
    
    // 返回最上层的视图控制器
    return topController;
}

/// 获取当前显示的视图控制器。
/// 在有导航控制器时返回 `topViewController`，否则返回最顶层控制器。
/// @return 当前活跃的 UIViewController。
- (UIViewController *)zhh_currentViewController {
    // 获取最上层的视图控制器
    UIViewController *currentViewController = [self zhh_topMostController];
    
    // 如果当前控制器是导航控制器，继续查找其导航栈中的 topViewController
    while ([currentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)currentViewController;
        // 如果导航控制器有顶部控制器，继续获取
        if (navigationController.topViewController) {
            currentViewController = navigationController.topViewController;
        } else {
            break; // 如果没有顶部控制器，退出循环
        }
    }
    
    // 返回最终找到的当前视图控制器
    return currentViewController;
}
@end
