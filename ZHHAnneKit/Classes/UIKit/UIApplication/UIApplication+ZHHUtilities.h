//
//  UIApplication+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ZHHUtilities)
/// 获取当前键盘的 frame
/// @return 当前键盘的 frame，如果键盘隐藏则返回 CGRectZero
- (CGRect)zhh_keyboardFrame;
/// 获取当前的windows窗口
/// 当前活动的 `UIWindow` 对象
/// 该方法适用于最低支持 iOS 13 的应用，使用 `UIScene` 获取当前 `UIWindowScene` 的窗口。
+ (UIWindow *)zhh_currentWindow;
@end

///=============================================================================
/// @name 应用信息
///=============================================================================
@interface UIApplication (ZHHAppInfo)

/// 获取应用程序的版本号
@property (nonatomic, class, readonly) NSString *zhh_appVersion;

/// 获取应用程序的显示名称
@property (nonatomic, class, readonly) NSString *zhh_appName;

/// 获取应用程序的 Build 版本号
@property (nonatomic, class, readonly) NSString *zhh_buildVersion;

/// 获取应用程序的 Bundle Identifier
@property (nonatomic, class, readonly) NSString *zhh_bundleIdentifier;

/// 获取应用程序图标
@property (nonatomic, class, readonly) UIImage *zhh_appIcon;

/// 获取启动页面图片
@property (nonatomic, class, readonly) UIImage *zhh_launchImage;

@end

NS_ASSUME_NONNULL_END

