//
//  UISplitViewController+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UISplitViewController+ZHHUtilities.h"

@implementation UISplitViewController (ZHHUtilities)
/// 获取左侧控制器（第一个控制器）
/// 如果为导航控制器，则返回其顶部控制器
- (UIViewController *)zhh_leftController {
    if (self.viewControllers.count == 0) return nil; // 确保存在子控制器
    
    UIViewController *leftVC = [self.viewControllers firstObject];
    
    // 如果是导航控制器，返回其顶部控制器
    if ([leftVC isKindOfClass:[UINavigationController class]]) {
        leftVC = [(UINavigationController *)leftVC topViewController];
    }
    
    return leftVC;
}

/// 获取右侧控制器（最后一个控制器）
/// 如果为导航控制器，则返回其顶部控制器
- (UIViewController *)zhh_rightController {
    if (self.viewControllers.count == 0) return nil; // 确保存在子控制器
    
    UIViewController *rightVC = [self.viewControllers lastObject];
    
    // 如果是导航控制器，返回其顶部控制器
    if ([rightVC isKindOfClass:[UINavigationController class]]) {
        rightVC = [(UINavigationController *)rightVC topViewController];
    }
    
    return rightVC;
}
@end
