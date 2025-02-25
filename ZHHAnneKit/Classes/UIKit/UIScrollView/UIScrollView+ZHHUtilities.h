//
//  UINavigationBar+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZHHUtilities)

/// 滚动到底部
/// @param animated 动画
- (void)zhh_scrollToBottomWithAnimated:(BOOL)animated;

/// 滚动到头部
/// @param animated 动画
- (void)zhh_scrollToTopWithAnimated:(BOOL)animated;

/// 滚动到指定试图
/// @param toView 试图
/// @param animated 动画
- (void)zhh_scrollToView:(UIView *)toView animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
