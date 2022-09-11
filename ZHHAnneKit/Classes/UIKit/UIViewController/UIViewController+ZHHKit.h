//
//  UIViewController+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZHHKit)
/// 通过字符串跳转VC
- (void)zhh_pushViewControllerWithClassName:(NSString *)className title:(NSString *)titleName;

/// 跳回指定的控制器
/// @param clazz 指定控制器类名
/// @param complete 成功回调控制器
/// @return returns 跳转是否成功
- (BOOL)zhh_popTargetViewController:(Class)clazz complete:(void(^)(UIViewController * vc))complete;

/// 切换根视图控制器
- (void)zhh_changeRootViewController:(void(^)(BOOL success))complete;

+ (UIViewController *)zhh_currentViewController;
@end

NS_ASSUME_NONNULL_END
