//
//  UIViewController+ZHHStatusBarStyle.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/26.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZHHStatusBarStyle)
@property (nonatomic, assign) BOOL zhh_statusBarHidden;
@property (nonatomic, assign) UIStatusBarStyle zhh_statusBarStyle;
- (void)zhh_statusBarRestoreDefaults;
@end

NS_ASSUME_NONNULL_END
