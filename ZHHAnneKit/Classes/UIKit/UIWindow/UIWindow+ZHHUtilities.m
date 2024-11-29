//
//  UIWindow+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIWindow+ZHHUtilities.h"

@implementation UIWindow (ZHHUtilities)
/**
 获取当前应用程序最上层的视图控制器（Top Most ViewController）。

 此方法会遍历整个视图控制器栈，找到当前显示在屏幕上的最上层视图控制器。
 如果有多个视图控制器以模态方式显示（通过 `presentViewController`），此方法会依次查找每一个模态控制器，直到找到最顶层的控制器。

 适用场景：
 1. 获取当前显示的控制器，以进行界面跳转或操作。
 2. 当有多个模态控制器时，可以确保获取的是最上层的那个。

 @return 返回最上层的视图控制器（`UIViewController`），可能是根控制器、导航控制器或模态控制器中的某一个。
 */
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

/**
 获取当前的视图控制器（Current ViewController）。

 该方法会首先查找最上层的视图控制器，如果该控制器是一个导航控制器（`UINavigationController`），
 它将返回导航栈中的当前控制器（`topViewController`）。
 如果没有导航控制器，则直接返回最上层的控制器。

 适用场景：
 1. 在需要获取当前活动控制器时使用，尤其是在复杂的视图控制器栈中。
 2. 处理导航控制器时，可以确保返回的是当前的视图控制器，而不是整个导航控制器。

 @return 当前视图控制器（`UIViewController`）。
         如果是导航控制器，则返回导航栈中的 `topViewController`。
 */
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
