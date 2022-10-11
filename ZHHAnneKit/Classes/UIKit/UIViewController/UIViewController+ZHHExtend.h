//
//  UIViewController+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZHHExtend)
/// 通过字符串跳转VC
- (void)zhh_pushViewControllerWithClassName:(NSString *)className title:(NSString *)titleName;

/// 跳回指定的控制器
/// @param clazz 指定控制器类名
/// @param complete 成功回调控制器
/// @return returns 跳转是否成功
- (BOOL)zhh_popTargetViewController:(Class)clazz complete:(void(^)(UIViewController * vc))complete;

/// 切换根视图控制器
- (void)zhh_changeRootViewController:(void(^)(BOOL success))complete;
/// 获取当前控制器
+ (UIViewController *)zhh_currentViewController;
@end

NS_ASSUME_NONNULL_END
