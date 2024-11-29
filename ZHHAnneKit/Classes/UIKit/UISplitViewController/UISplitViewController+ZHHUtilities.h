//
//  UISplitViewController+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISplitViewController (ZHHUtilities)

/// 获取左侧控制器（第一个控制器）
/// 如果为导航控制器，则返回其顶部控制器
- (UIViewController *)zhh_leftController;

/// 获取右侧控制器（最后一个控制器）
/// 如果为导航控制器，则返回其顶部控制器
- (UIViewController *)zhh_rightController;
@end

NS_ASSUME_NONNULL_END
