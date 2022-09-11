//
//  UITabBar+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UITabBarBadgeProtocol <NSObject>
/// 代理设置，只需在初始位置调用一次
/// @param count TabBar的数量
+ (void)zhh_tabBarCount:(NSInteger)count;

@end

@interface UITabBar (ZHHKit)<UITabBarBadgeProtocol>

/// Show the little red dot
- (void)zhh_showBadgeOnItemIndex:(NSInteger)index;

/// hide the little red dot
- (void)zhh_hideBadgeOnItemIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
