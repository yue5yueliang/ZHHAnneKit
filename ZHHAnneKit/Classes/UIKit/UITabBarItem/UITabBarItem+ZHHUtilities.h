//
//  UITabBarItem+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (ZHHUtilities)

/// tabBarItem 被双击时触发的 block，包含当前 item 和其索引
@property(nonatomic, copy, nullable) void (^zhh_doubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index);

@end

NS_ASSUME_NONNULL_END
