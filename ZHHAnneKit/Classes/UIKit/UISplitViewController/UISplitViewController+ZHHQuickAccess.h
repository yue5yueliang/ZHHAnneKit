//
//  UISplitViewController+ZHHQuickAccess.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//
//  https://github.com/HiddenJester/UISplitViewController-QuickAccess

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISplitViewController (ZHHQuickAccess)
@property (weak, readonly, nonatomic) UIViewController *zhh_leftController;
@property (weak, readonly, nonatomic) UIViewController *zhh_rightController;
@end

NS_ASSUME_NONNULL_END
