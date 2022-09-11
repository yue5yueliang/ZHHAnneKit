//
//  UILabel+Extend.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/25.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UILabel+Extend.h"
#import <objc/runtime.h>

@implementation UILabel (Extend)
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
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.zhh_textEdgeInsets)) {
        return [self _zhh_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    CGRect rect = [self _zhh_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.zhh_textEdgeInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.zhh_textEdgeInsets.left;
    rect.origin.y -= self.zhh_textEdgeInsets.top;
    rect.size.width += self.zhh_textEdgeInsets.left + self.zhh_textEdgeInsets.right;
    rect.size.height += self.zhh_textEdgeInsets.top + self.zhh_textEdgeInsets.bottom;
    return rect;
}

- (void)_zhh_drawTextInRect:(CGRect)rect {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.zhh_textEdgeInsets)) {
        return [self _zhh_drawTextInRect:rect];
    }
    return [self _zhh_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.zhh_textEdgeInsets)];
}

- (UIEdgeInsets)zhh_textEdgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setZhh_textEdgeInsets:(UIEdgeInsets)zhh_textEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, zhh_textEdgeInsets)) return;
    NSValue *value = [NSValue valueWithUIEdgeInsets:zhh_textEdgeInsets];
    objc_setAssociatedObject(self, @selector(zhh_textEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
