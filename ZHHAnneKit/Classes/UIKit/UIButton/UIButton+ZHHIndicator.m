//
//  UIButton+ZHHIndicator.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHIndicator.h"
#import <objc/runtime.h>

@implementation UIButton (Indicator)
#pragma mark - 指示器管理
- (void)zhh_beginSubmitting:(NSString *)title {
    if (self.zhh_submitting) return; // 防止重复调用

    self.zhh_submitting = YES;
    self.zhh_originalTitle = self.titleLabel.text; // 保存原始标题
    self.enabled = NO; // 禁用按钮
    [self setTitle:@"" forState:UIControlStateNormal];

    // 设置指示器
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.zhh_indicatorType ?: UIActivityIndicatorViewStyleMedium];
    self.zhh_indicatorView = indicator;
    [self addSubview:indicator];

    // 配置加载文字
    if (title.length > 0) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = self.titleLabel.font;
        label.textColor = self.titleLabel.textColor;
        self.zhh_indicatorLabel = label;
        [self addSubview:label];
    }

    [self zhh_updateIndicatorLayout];
    [indicator startAnimating];
}

- (void)zhh_endSubmitting {
    if (!self.zhh_submitting) return;

    self.zhh_submitting = NO;
    self.enabled = YES;

    // 恢复原始状态
    [self setTitle:self.zhh_originalTitle forState:UIControlStateNormal];
    [self.zhh_indicatorView stopAnimating];
    [self.zhh_indicatorView removeFromSuperview];
    [self.zhh_indicatorLabel removeFromSuperview];

    self.zhh_indicatorView = nil;
    self.zhh_indicatorLabel = nil;
}

#pragma mark - 布局更新

- (void)zhh_updateIndicatorLayout {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGFloat spacing = self.zhh_indicatorSpace ?: 5.0;
    CGFloat indicatorWidth = self.zhh_indicatorView.frame.size.width;
    CGFloat contentWidth = indicatorWidth;

    if (self.zhh_indicatorLabel) {
        CGSize labelSize = [self.zhh_indicatorLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)];
        self.zhh_indicatorLabel.frame = CGRectMake(0, 0, labelSize.width, height);
        contentWidth += spacing + labelSize.width;
    }

    CGFloat startX = (width - contentWidth) / 2.0;

    self.zhh_indicatorView.center = CGPointMake(startX + indicatorWidth / 2.0, height / 2.0);
    self.zhh_indicatorLabel.frame = CGRectMake(CGRectGetMaxX(self.zhh_indicatorView.frame) + spacing, 0, self.zhh_indicatorLabel.frame.size.width, height);
}

#pragma mark - Associated Properties

- (BOOL)zhh_submitting {
    return [objc_getAssociatedObject(self, @selector(zhh_submitting)) boolValue];
}

- (void)setZhh_submitting:(BOOL)submitting {
    objc_setAssociatedObject(self, @selector(zhh_submitting), @(submitting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)zhh_originalTitle {
    return objc_getAssociatedObject(self, @selector(zhh_originalTitle));
}

- (void)setZhh_originalTitle:(NSString *)originalTitle {
    objc_setAssociatedObject(self, @selector(zhh_originalTitle), originalTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIActivityIndicatorView *)zhh_indicatorView {
    return objc_getAssociatedObject(self, @selector(zhh_indicatorView));
}

- (void)setZhh_indicatorView:(UIActivityIndicatorView *)indicatorView {
    objc_setAssociatedObject(self, @selector(zhh_indicatorView), indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)zhh_indicatorLabel {
    return objc_getAssociatedObject(self, @selector(zhh_indicatorLabel));
}

- (void)setZhh_indicatorLabel:(UILabel *)indicatorLabel {
    objc_setAssociatedObject(self, @selector(zhh_indicatorLabel), indicatorLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorViewStyle)zhh_indicatorType {
    return (UIActivityIndicatorViewStyle)[objc_getAssociatedObject(self, @selector(zhh_indicatorType)) intValue];
}

- (void)setZhh_indicatorType:(UIActivityIndicatorViewStyle)indicatorType {
    objc_setAssociatedObject(self, @selector(zhh_indicatorType), @(indicatorType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zhh_indicatorSpace {
    return [objc_getAssociatedObject(self, @selector(zhh_indicatorSpace)) floatValue];
}

- (void)setZhh_indicatorSpace:(CGFloat)indicatorSpace {
    objc_setAssociatedObject(self, @selector(zhh_indicatorSpace), @(indicatorSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
