//
//  UINavigationController+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UINavigationController+ZHHUtilities.h"

@implementation UINavigationController (ZHHUtilities)

- (void)zhh_pushViewController:(UIViewController *)controller withTransitionType:(CATransitionType)type subtype:(CATransitionSubtype)subtype {
    if (!controller) return;

    // 创建 CATransition 动画
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = type ?: kCATransitionPush;        // 默认类型为 push
    transition.subtype = subtype ?: kCATransitionFromRight; // 默认方向为从右向左
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    // 添加动画到当前导航视图层
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:controller animated:NO];
}

/// 弹出当前 ViewController，并带有自定义动画。
- (UIViewController *)zhh_popViewController:(CATransitionType)type subtype:(CATransitionSubtype)subtype {
    if (!self.viewControllers.count) return nil;

    // 创建 CATransition 动画
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = type ?: kCATransitionPush;        // 默认类型为 push
    transition.subtype = subtype ?: kCATransitionFromLeft; // 默认方向为从左向右
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    // 添加动画到当前导航视图层
    [self.view.layer addAnimation:transition forKey:kCATransition];
    return [self popViewControllerAnimated:NO];
}

- (UIViewController * _Nullable)zhh_findViewControllerWithClassName:(NSString * _Nonnull)className {
    if (!className || className.length == 0) {
        NSLog(@"ZHHAnneKit 警告: 类名不能为空");
        return nil;
    }
    
    Class targetClass = NSClassFromString(className);
    if (!targetClass) {
        NSLog(@"ZHHAnneKit 警告: 未找到类 '%@'", className);
        return nil;
    }
    
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:targetClass]) {
            return viewController;
        }
    }
    return nil;
}

- (BOOL)zhh_isOnlyContainRootViewController {
    // 判断 viewControllers 是否非空并且只有一个元素
    return (self.viewControllers.count == 1);
}

- (UIViewController *)zhh_rootViewController {
    // 确保 viewControllers 数组非空且有元素
    return self.viewControllers.firstObject ?: nil;
}

- (NSArray<UIViewController *> *)zhh_popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated {
    // 获取指定类名的视图控制器
    UIViewController *targetViewController = [self zhh_findViewControllerWithClassName:className];
    
    // 如果目标视图控制器存在，则执行 pop 操作；否则返回 nil
    return targetViewController ? [self popToViewController:targetViewController animated:animated] : nil;
}

- (NSArray<UIViewController *> *)zhh_popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated {
    // 获取导航堆栈中的视图控制器数量
    NSInteger viewControllersCount = self.viewControllers.count;
    
    // 如果层级数合法，则返回到指定层级的控制器
    if (viewControllersCount > level && level >= 0) {
        NSInteger targetIndex = viewControllersCount - level - 1;
        UIViewController *targetViewController = self.viewControllers[targetIndex];
        return [self popToViewController:targetViewController animated:animated];
    }
    
    // 如果层级数无效，则返回到根视图控制器
    return [self popToRootViewControllerAnimated:animated];
}

@end
