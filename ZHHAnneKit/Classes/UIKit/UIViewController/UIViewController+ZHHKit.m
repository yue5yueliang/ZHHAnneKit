//
//  UIViewController+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIViewController+ZHHKit.h"

@implementation UIViewController (ZHHKit)

/// 通过字符串跳转VC
- (void)zhh_pushViewControllerWithClassName:(NSString *)className title:(NSString *)titleName{
    Class controller = NSClassFromString(className);
    //    id controller = [[NSClassFromString(className) alloc] init];
    if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
        UIViewController *view = [[controller alloc] init];
        view.title = titleName;
        [view setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        NSLog(@"没有对应控制器");
    }
}

/// 跳转回指定控制器
- (BOOL)zhh_popTargetViewController:(Class)clazz complete:(void(^)(UIViewController *vc))complete{
    UIViewController *vc = nil;
    for (UIViewController *__vc in self.navigationController.viewControllers) {
        if ([__vc isKindOfClass:clazz]) {
            vc = __vc;
            break;
        }
    }
    if (vc == nil) return NO;
    [self.navigationController popToViewController:vc animated:YES];
    if (complete) complete(vc);
    return YES;
}

/// 切换根视图控制器
- (void)zhh_changeRootViewController:(void(^)(BOOL success))complete{
    UIWindow *window = ({
        UIWindow *window;
        if (@available(iOS 13.0, *)) {
            window = [UIApplication sharedApplication].windows.firstObject;
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }
        window;
    });
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = self;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        if (complete) complete(finished);
    }];
}

+ (UIViewController *)zhh_currentViewController {
    UIViewController *rootViewController = [self getRootViewController];
    return [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController {
    // 如果传入的控制器是导航控制器,则返回最后一个
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }
    // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    }
    // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}

+ (UIViewController *)getRootViewController{
    UIWindow* window = nil;
    if (@available(iOS 13.0, *)) {
       for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
           if (windowScene.activationState == UISceneActivationStateForegroundActive){
              window = windowScene.windows.firstObject;
               break;
          }
       }
   }else{
       #pragma clang diagnostic push
       #pragma clang diagnostic ignored "-Wdeprecated-declarations"
       // 这部分使用到的过期api
        window = [UIApplication sharedApplication].keyWindow;
       #pragma clang diagnostic pop
   }
    if([window.rootViewController isKindOfClass:NSNull.class]){
        return nil;
    }
    return window.rootViewController;
}
@end
