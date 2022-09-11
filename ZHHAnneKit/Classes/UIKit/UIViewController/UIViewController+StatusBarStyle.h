//
//  UIViewController+StatusBarStyle.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/26.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (StatusBarStyle)
@property (nonatomic, assign) BOOL zhh_statusBarHidden;
@property (nonatomic, assign) UIStatusBarStyle zhh_statusBarStyle;
- (void)zhh_statusBarRestoreDefaults;
@end

NS_ASSUME_NONNULL_END
