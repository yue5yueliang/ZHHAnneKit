//
//  UIWindow+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ZHHUtilities)

/// 获取当前最上层的视图控制器。
/// 会递归查找 `presentedViewController`，返回当前正在显示的控制器。
/// @return 最顶层的 UIViewController。
- (UIViewController *)zhh_topMostController;

/// 获取当前显示的视图控制器。
/// 在有导航控制器时返回 `topViewController`，否则返回最顶层控制器。
/// @return 当前活跃的 UIViewController。
- (UIViewController *)zhh_currentViewController;
@end

NS_ASSUME_NONNULL_END
