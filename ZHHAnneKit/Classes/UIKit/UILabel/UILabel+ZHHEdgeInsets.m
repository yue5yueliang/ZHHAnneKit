//
//  UILabel+ZHHEdgeInsets.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/25.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UILabel+ZHHEdgeInsets.h"
#import <objc/runtime.h>

@implementation UILabel (ZHHEdgeInsets)
+ (void)load {
    SEL selectors[] = {
        @selector(textRectForBounds:limitedToNumberOfLines:),
        @selector(drawTextInRect:),
    };
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"_zhh_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (CGRect)_zhh_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.zhh_edgeInsets)) {
        return [self _zhh_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    CGRect rect = [self _zhh_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.zhh_edgeInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.zhh_edgeInsets.left;
    rect.origin.y -= self.zhh_edgeInsets.top;
    rect.size.width += self.zhh_edgeInsets.left + self.zhh_edgeInsets.right;
    rect.size.height += self.zhh_edgeInsets.top + self.zhh_edgeInsets.bottom;
    return rect;
}

- (void)_zhh_drawTextInRect:(CGRect)rect {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.zhh_edgeInsets)) {
        return [self _zhh_drawTextInRect:rect];
    }
    return [self _zhh_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.zhh_edgeInsets)];
}

- (UIEdgeInsets)zhh_edgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setZhh_edgeInsets:(UIEdgeInsets)zhh_edgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, zhh_edgeInsets)) return;
    NSValue *value = [NSValue valueWithUIEdgeInsets:zhh_edgeInsets];
    objc_setAssociatedObject(self, @selector(zhh_edgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
