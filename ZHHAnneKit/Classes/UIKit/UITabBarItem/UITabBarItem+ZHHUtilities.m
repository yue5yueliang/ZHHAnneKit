//
//  UITabBarItem+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITabBarItem+ZHHUtilities.h"
#import <objc/runtime.h>

@implementation UITabBarItem (ZHHUtilities)

#pragma mark - zhh_doubleTapBlock
- (void)setZhh_doubleTapBlock:(void (^)(UITabBarItem *tabBarItem, NSInteger index))block {
    objc_setAssociatedObject(self, @selector(zhh_doubleTapBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITabBarItem *tabBarItem, NSInteger index))zhh_doubleTapBlock {
    return objc_getAssociatedObject(self, @selector(zhh_doubleTapBlock));
}

@end
