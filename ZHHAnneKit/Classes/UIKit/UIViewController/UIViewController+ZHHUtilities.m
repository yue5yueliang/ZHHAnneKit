//
//  UIViewController+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIViewController+ZHHUtilities.h"

@implementation UIViewController (ZHHUtilities)

- (void)zhh_pushViewControllerWithClassName:(NSString *)className {
    [self zhh_pushViewControllerWithClassName:className title:@""];
}

/// 通过类名字符串跳转到指定的 ViewController
/// @param className 控制器类名字符串
/// @param titleName 控制器标题
- (void)zhh_pushViewControllerWithClassName:(NSString *)className title:(NSString *)titleName {
    // 获取类对象
    Class controllerClass = NSClassFromString(className);
    
    // 判断是否是 UIViewController 子类
    if (controllerClass && [controllerClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *viewController = [[controllerClass alloc] init];
        viewController.title = titleName;
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部 TabBar
        
        // 确保 self 具有 navigationController
        if ([self isKindOfClass:[UIViewController class]] && self.navigationController) {
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            NSLog(@"❌ 当前对象无 navigationController，无法 push");
        }
    } else {
        NSLog(@"❌ 无法找到对应的控制器类: %@", className);
    }
}

/// 跳转回指定控制器
/// @param clazz 指定控制器的类
/// @param complete 跳转完成的回调，返回目标控制器实例
/// @return 是否成功找到并跳转到目标控制器
- (BOOL)zhh_popTargetViewController:(Class)clazz complete:(void(^)(UIViewController *vc))complete {
    if (!clazz) return NO; // 如果传入类为空，直接返回 NO

    UIViewController *targetViewController = nil;
    
    // 遍历导航控制器的控制器栈，寻找指定类的控制器
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:clazz]) {
            targetViewController = vc;
            break;
        }
    }
    
    // 如果未找到目标控制器，返回 NO
    if (!targetViewController) return NO;

    // 跳转到目标控制器
    [self.navigationController popToViewController:targetViewController animated:YES];

    // 执行回调，传递目标控制器实例
    if (complete) {
        complete(targetViewController);
    }
    
    return YES;
}

/// 切换根视图控制器
/// @param complete 切换完成的回调，返回成功与否的布尔值
- (void)zhh_changeRootViewController:(void(^)(BOOL success))complete {
    // 获取应用主窗口
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    if (!window) {
        if (complete) complete(NO);
        return;
    }
    
    // 通过动画切换根视图控制器
    [UIView transitionWithView:window duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        // 禁用动画状态，避免可能的多余动画
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = self;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        if (complete) complete(finished);
    }];
}

/// 获取当前显示的控制器
+ (UIViewController *)zhh_currentViewController {
    // 从根视图控制器递归查找当前显示的控制器
    return [self zhh_currentViewControllerFrom:[self zhh_rootViewController]];
}

/// 从指定的控制器递归找到当前显示的控制器
/// @param viewController 开始查找的控制器
+ (UIViewController *)zhh_currentViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        // 如果是导航控制器，获取其栈顶控制器
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self zhh_currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        // 如果是标签栏控制器，获取当前选中的控制器
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self zhh_currentViewControllerFrom:tabBarController.selectedViewController];
    } else if (viewController.presentedViewController) {
        // 如果当前控制器有模态推出的控制器，递归查找
        return [self zhh_currentViewControllerFrom:viewController.presentedViewController];
    } else {
        // 返回最终的控制器
        return viewController;
    }
}

/// 获取根视图控制器
+ (UIViewController *)zhh_rootViewController {
    // 从 iOS 13 开始，通过 `UIWindowScene` 获取主窗口
    for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            return windowScene.windows.firstObject.rootViewController;
        }
    }
    return nil; // 如果没有找到合适的窗口，返回 nil
}

#pragma mark - UINavigationControllerDelegate

/// UINavigationControllerDelegate 方法，用于控制导航栏的显示隐藏逻辑
/// @param navigationController 当前导航控制器
/// @param viewController 即将显示的控制器
/// @param animated 是否有动画效果
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        // 如果是当前控制器，隐藏导航栏
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        // 如果是其他控制器，显示导航栏
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            // 对于图片选择器，保留其默认行为
            return;
        }
        [navigationController setNavigationBarHidden:NO animated:YES];
        
        // 避免委托循环，解除当前的委托设置
        if (navigationController.delegate == self) {
            navigationController.delegate = nil;
        }
    }
}

#pragma mark - 手势控制

/// 是否开启侧滑返回手势
/// @param open 是否开启
- (void)zhh_openPopGesture:(BOOL)open {
    // iOS 13.0+ 直接使用 interactivePopGestureRecognizer
    if (self.navigationController.interactivePopGestureRecognizer) {
        // 遍历所有与侧滑手势相关的手势识别器并设置是否启用
        for (UIGestureRecognizer *popGesture in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = open;
        }
    }
}

#pragma mark - 系统分享功能

/// 调起系统自带分享功能
/// @param items 要分享的内容数组
/// @param complete 分享完成的回调
/// @return 返回系统分享的活动视图控制器
- (UIActivityViewController *)zhh_shareActivityWithItems:(NSArray *)items complete:(void(^)(BOOL success))complete {
    if (items.count == 0) return nil; // 如果没有内容，不执行操作
    
    // 初始化活动视图控制器
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    // 设置需要排除的活动类型
    vc.excludedActivityTypes = @[
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypeOpenInIBooks,
        UIActivityTypeMarkupAsPDF
    ];
    
    // 设置分享完成后的回调
    vc.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (complete) complete(completed);
    };
    
    // 适配 iPad，确保弹出视图的位置正确
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        vc.popoverPresentationController.sourceView = self.view;
        vc.popoverPresentationController.sourceRect = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2,
                                                                 CGRectGetHeight([UIScreen mainScreen].bounds), 0, 0);
    }
    
    // 弹出分享视图控制器
    [self presentViewController:vc animated:YES completion:nil];
    
    return vc;
}
@end
