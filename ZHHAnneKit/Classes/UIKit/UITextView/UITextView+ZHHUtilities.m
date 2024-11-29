//
//  UITextView+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITextView+ZHHUtilities.h"
#import <objc/runtime.h>

@implementation UITextView (ZHHUtilities)

#pragma mark - Swizzling dealloc 方法

+ (void)load {
    // 替换 dealloc 方法，确保正确移除观察者
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(zhh_swizzledDealloc)));
}

- (void)zhh_swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(zhh_placeholderLabel));
    if (label) {
        // 移除 KVO 观察
        for (NSString *key in self.class.zhh_observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // 捕获异常，但不处理
            }
        }
    }
    // 调用原 dealloc 方法
    [self zhh_swizzledDealloc];
}

#pragma mark - 类方法

+ (UIColor *)zhh_defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 默认 placeholder 颜色
        color = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    });
    return color;
}

+ (NSArray<NSString *> *)zhh_observingKeys {
    // 需要观察的键
    return @[@"attributedText", @"bounds", @"font", @"frame", @"text", @"textAlignment", @"textContainerInset"];
}

#pragma mark - Properties

- (UILabel *)zhh_placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(zhh_placeholderLabel));
    if (!label) {
        // 延迟创建 placeholder 标签
        self.text = @" "; // 设置字体
        label = [[UILabel alloc] init];
        label.textColor = [self.class zhh_defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(zhh_placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.zhh_needsUpdateFont = YES;
        [self zhh_updatePlaceholderLabel];
        self.zhh_needsUpdateFont = NO;

        // 添加文本变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(zhh_updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        // 添加 KVO 观察
        for (NSString *key in self.class.zhh_observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return label;
}

- (NSString *)zhh_placeholder {
    return self.zhh_placeholderLabel.text;
}

- (void)setZhh_placeholder:(NSString *)placeholder {
    self.zhh_placeholderLabel.text = placeholder;
    [self zhh_updatePlaceholderLabel];
}

- (NSAttributedString *)zhh_attributedPlaceholder {
    return self.zhh_placeholderLabel.attributedText;
}

- (void)setZhh_attributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.zhh_placeholderLabel.attributedText = attributedPlaceholder;
    [self zhh_updatePlaceholderLabel];
}

- (UIColor *)zhh_placeholderColor {
    return self.zhh_placeholderLabel.textColor;
}

- (void)setZhh_placeholderColor:(UIColor *)placeholderColor {
    self.zhh_placeholderLabel.textColor = placeholderColor;
}

- (BOOL)zhh_needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(zhh_needsUpdateFont)) boolValue];
}

- (void)setZhh_needsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(zhh_needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.zhh_needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self zhh_updatePlaceholderLabel];
}

#pragma mark - 更新 placeholder 标签
- (void)zhh_updatePlaceholderLabel {
    if (self.text.length) {
        // 如果文本已经输入，移除 placeholder 标签
        [self.zhh_placeholderLabel removeFromSuperview];
        return;
    }

    [self insertSubview:self.zhh_placeholderLabel atIndex:0];

    if (self.zhh_needsUpdateFont) {
        // 更新字体
        self.zhh_placeholderLabel.font = self.font;
        self.zhh_needsUpdateFont = NO;
    }
    self.zhh_placeholderLabel.textAlignment = self.textAlignment;

    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    UIEdgeInsets textContainerInset = self.textContainerInset;

    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.zhh_placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.zhh_placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end
