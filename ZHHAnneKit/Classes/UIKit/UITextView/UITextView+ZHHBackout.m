//
//  UITextView+Backout.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITextView+ZHHBackout.h"
#import <objc/runtime.h>

@implementation UITextView (ZHHBackout)
- (void)backoutSwizzled{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                       class_getInstanceMethod(self.class, @selector(zhh_backout_dealloc)));
    });
}
- (void)zhh_backout_dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textTemps removeAllObjects];
    [self zhh_backout_dealloc];
}

/// 撤销输入，相当于 command + z
- (void)zhh_textViewBackout{
    if (self.textTemps.count) {
        [self.textTemps removeLastObject];
        self.text = self.textTemps.lastObject;
    }
}

#pragma mark - NSNotification

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zhh_backoutTextViewNotification:) name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zhh_backoutTextViewNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)zhh_backoutTextViewNotification:(NSNotification *)notification{
    if ([notification.name isEqualToString:UITextViewTextDidBeginEditingNotification]) {
        if (self.textTemps.count == 0) [self zhh_backoutTextViewChangeText:self.text];
    } else if ([notification.name isEqualToString:UITextViewTextDidChangeNotification]) {
        if ([self.textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextPosition *position = [self positionFromPosition:self.markedTextRange.start offset:0];
            if (position == nil) [self zhh_backoutTextViewChangeText:self.text];
        } else {
            [self zhh_backoutTextViewChangeText:self.text];
        }
    }
}

/// 加入数组
- (void)zhh_backoutTextViewChangeText:(NSString *)text{
    if (text) {
        if ([self.textTemps.lastObject isEqualToString:text]) return;
        [self.textTemps addObject:text];
    }
}

#pragma mark - Associated

- (BOOL)openBackout{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setOpenBackout:(BOOL)openBackout{
    objc_setAssociatedObject(self, @selector(openBackout), @(openBackout), OBJC_ASSOCIATION_ASSIGN);
    [self backoutSwizzled];
    [self addNotification];
}
- (NSMutableArray *)textTemps{
    NSMutableArray *temps = objc_getAssociatedObject(self, @selector(textTemps));
    if (temps == nil) {
        temps = [NSMutableArray array];
        objc_setAssociatedObject(self, @selector(textTemps), temps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temps;
}

@end
