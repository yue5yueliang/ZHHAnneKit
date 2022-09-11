//
//  UIControl+Control.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/9/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIControl+Control.h"
#import <objc/runtime.h>

@interface UIControl ()
/** 是否忽略点击 */
@property(nonatomic)BOOL zhh_ignoreEvent;
@end

@implementation UIControl (Control)
+ (void)load{
    Method sys_Method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method add_Method = class_getInstanceMethod(self, @selector(zhh_sendAction:to:forEvent:));
    method_exchangeImplementations(sys_Method, add_Method);
}

- (void)zhh_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if (self.zhh_ignoreEvent) return;
    
    if (self.zhh_acceptEventInterval > 0) {
        self.zhh_ignoreEvent = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.zhh_acceptEventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.zhh_ignoreEvent = NO;
        });
    }
    [self zhh_sendAction:action to:target forEvent:event];
}

- (void)setZhh_ignoreEvent:(BOOL)zhh_ignoreEvent{
    objc_setAssociatedObject(self, @selector(zhh_ignoreEvent), @(zhh_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhh_ignoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZhh_acceptEventInterval:(NSTimeInterval)zhh_acceptEventInterval{
    objc_setAssociatedObject(self, @selector(zhh_acceptEventInterval), @(zhh_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)zhh_acceptEventInterval{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
@end
