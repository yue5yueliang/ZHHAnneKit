//
//  UITabBar+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITabBar+ZHHExtend.h"
#import <objc/runtime.h>

@implementation UITabBar (ZHHExtend)

+ (NSInteger)tabBarCount{
    return [objc_getAssociatedObject(self, @selector(tabBarCount)) intValue];
}

+ (void)setTabBarCount:(NSInteger)tabBarCount{
    objc_setAssociatedObject(self, @selector(tabBarCount), @(tabBarCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 当前的TabBar个数
+ (void)zhh_tabBarCount:(NSInteger)count{
    self.tabBarCount = count;
}

- (void)zhh_showBadgeOnItemIndex:(NSInteger)index{
    [self zhh_hideBadgeOnItemIndex:index];
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.backgroundColor = [UIColor redColor];
    float percentX = (index+0.6) / UITabBar.tabBarCount?:4;
    CGFloat x = ceilf(percentX * self.frame.size.width);
    CGFloat y = ceilf(0.1 * self.frame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    badgeView.layer.cornerRadius = badgeView.frame.size.width/2.;
    [self addSubview:badgeView];
}

- (void)zhh_hideBadgeOnItemIndex:(NSInteger)index{
    UIView *view = [self viewWithTag:888 + index];
    [view removeFromSuperview];
}
@end
