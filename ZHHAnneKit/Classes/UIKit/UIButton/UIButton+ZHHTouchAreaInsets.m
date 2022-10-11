//
//  UIButton+ZHHTouchAreaInsets.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/9/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHTouchAreaInsets.h"
#import <objc/runtime.h>

@implementation UIButton (ZHHTouchAreaInsets)
- (UIEdgeInsets)zhh_touchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(zhh_touchAreaInsets)) UIEdgeInsetsValue];
}

/**
 *  @brief  设置按钮额外热区
 */
- (void)setZhh_touchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(zhh_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.zhh_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}
@end
