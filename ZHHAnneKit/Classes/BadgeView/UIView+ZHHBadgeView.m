//
//  UIView+ZHHBadgeView.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHBadgeView.h"
#import "ZHHBadgeControl.h"
#import <objc/runtime.h>

static NSString *const ZHHBadgeViewKey = @"ZHHBadgeViewKey";

@implementation UIView (ZHHBadgeView)

/// 添加带文本内容的 Badge
- (void)zhh_addBadgeWithText:(NSString *)text {
    [self zhh_showBadge];
    self.badgeView.text = text;
    [self zhh_setBadgeFlexMode:self.badgeView.flexMode];
    
    // 获取当前宽度约束
    NSLayoutConstraint *currentWidthConstraint = self.badgeView.widthConstraint;
    NSLayoutRelation targetRelation = text.length > 0 ? NSLayoutRelationGreaterThanOrEqual : NSLayoutRelationEqual;
    
    // 如果当前约束关系已经是目标关系，则不需要修改
    if (currentWidthConstraint && currentWidthConstraint.relation == targetRelation) {
        return;
    }
    
    // 移除当前宽度约束
    if (currentWidthConstraint) {
        currentWidthConstraint.active = NO;
    }
    
    // 添加新的宽度约束
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView 
                                                                   attribute:NSLayoutAttributeWidth 
                                                                   relatedBy:targetRelation 
                                                                      toItem:self.badgeView 
                                                                   attribute:NSLayoutAttributeHeight 
                                                                  multiplier:1.0 
                                                                    constant:0];
    [self.badgeView addConstraint:newConstraint];
}

/// 添加带数字的 Badge
- (void)zhh_addBadgeWithValue:(NSInteger)value {
    if (value <= 0) {
        [self zhh_addBadgeWithText:@"0"];
        [self zhh_hiddenBadge];
        return;
    }
    [self zhh_addBadgeWithText:[NSString stringWithFormat:@"%ld", value]];
}

/// 添加小圆点 Badge，支持自定义颜色
- (void)zhh_addDotWithColor:(UIColor *)color {
    [self zhh_addBadgeWithText:nil];
    [self zhh_setBadgeHeight:8.0];
    self.badgeView.backgroundColor = color;
}

/// 设置 Badge 的偏移量
- (void)zhh_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y {
    self.badgeView.offset = CGPointMake(x, y);
    [self centerYConstraintWithItem:self.badgeView].constant = y;
    
    CGFloat badgeHeight = self.badgeView.heightConstraint.constant;
    switch (self.badgeView.flexMode) {
        case ZHHBadgeViewFlexModeHead: // 1. 左伸缩
            [self adjustTrailingConstraintWithX:x badgeHeight:badgeHeight];
            break;
        case ZHHBadgeViewFlexModeTail: // 2. 右伸缩
            [self adjustLeadingConstraintWithX:x badgeHeight:badgeHeight];
            break;
        case ZHHBadgeViewFlexModeMiddle: // 3. 左右伸缩
            [self adjustCenterXConstraintWithX:x];
            break;
    }
}

/// 设置 Badge 的伸缩模式
- (void)zhh_setBadgeFlexMode:(ZHHBadgeViewFlexMode)flexMode {
    self.badgeView.flexMode = flexMode;
    [self zhh_moveBadgeWithX:self.badgeView.offset.x Y:self.badgeView.offset.y];
}

/// 设置 Badge 的高度（宽度按比例调整）
- (void)zhh_setBadgeHeight:(CGFloat)height {
    self.badgeView.layer.cornerRadius = height * 0.5;
    self.badgeView.heightConstraint.constant = height;
    [self zhh_moveBadgeWithX:self.badgeView.offset.x Y:self.badgeView.offset.y];
}

/// 显示 Badge
- (void)zhh_showBadge {
    self.badgeView.hidden = NO;
}

/// 隐藏 Badge
- (void)zhh_hiddenBadge {
    self.badgeView.hidden = YES;
}

/// 数字加 1
- (void)zhh_incrementBadge {
    [self zhh_incrementBadgeBy:1];
}

/// 数字增加指定值
- (void)zhh_incrementBadgeBy:(NSInteger)value {
    NSInteger result = self.badgeView.text.integerValue + value;
    if (result > 0) {
        [self zhh_showBadge];
    }
    self.badgeView.text = [NSString stringWithFormat:@"%ld", result];
}

/// 数字减 1
- (void)zhh_decrementBadge {
    [self zhh_decrementBadgeBy:1];
}

/// 数字减少指定值
- (void)zhh_decrementBadgeBy:(NSInteger)value {
    NSInteger result = self.badgeView.text.integerValue - value;
    if (result <= 0) {
        [self zhh_hiddenBadge];
        self.badgeView.text = @"0";
        return;
    }
    self.badgeView.text = [NSString stringWithFormat:@"%ld", result];
}

#pragma mark - Private Methods

/// 调整 Badge 的右侧约束
- (void)adjustTrailingConstraintWithX:(CGFloat)x badgeHeight:(CGFloat)badgeHeight {
    [self centerXConstraintWithItem:self.badgeView].active = NO;
    [self leadingConstraintWithItem:self.badgeView].active = NO;
    if ([self trailingConstraintWithItem:self.badgeView]) {
        [self trailingConstraintWithItem:self.badgeView].constant = x + badgeHeight * 0.5;
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0
                                                                       constant:(x + badgeHeight * 0.5)];
        [self addConstraint:constraint];
    }
}

/// 调整 Badge 的左侧约束
- (void)adjustLeadingConstraintWithX:(CGFloat)x badgeHeight:(CGFloat)badgeHeight {
    [self centerXConstraintWithItem:self.badgeView].active = NO;
    [self trailingConstraintWithItem:self.badgeView].active = NO;
    if ([self leadingConstraintWithItem:self.badgeView]) {
        [self leadingConstraintWithItem:self.badgeView].constant = x - badgeHeight * 0.5;
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0
                                                                       constant:(x - badgeHeight * 0.5)];
        [self addConstraint:constraint];
    }
}

/// 调整 Badge 的水平中心约束
- (void)adjustCenterXConstraintWithX:(CGFloat)x {
    [self leadingConstraintWithItem:self.badgeView].active = NO;
    [self trailingConstraintWithItem:self.badgeView].active = NO;
    if ([self centerXConstraintWithItem:self.badgeView]) {
        [self centerXConstraintWithItem:self.badgeView].constant = x;
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0
                                                                       constant:x];
        [self addConstraint:constraint];
    }
}

- (void)addBadgeViewLayoutConstraint {
    [self.badgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    // 设置中心点 X 约束
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0 constant:0];
    // 设置中心点 Y 约束
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual toItem:self
                                                                         attribute:NSLayoutAttributeTop multiplier:1.0
                                                                          constant:0];
    // 设置宽度约束，宽度动态大于等于高度
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:self.badgeView
                                                                       attribute:NSLayoutAttributeHeight multiplier:1.0
                                                                        constant:0];
    // 设置高度约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:18];
    [self addConstraints:@[centerXConstraint, centerYConstraint]];
    [self.badgeView addConstraints:@[widthConstraint, heightConstraint]];
}

#pragma mark - setter/getter

- (ZHHBadgeControl *)badgeView {
    // 通过关联对象获取 Badge 视图
    ZHHBadgeControl *badgeView = objc_getAssociatedObject(self, &ZHHBadgeViewKey);
    if (!badgeView) {
        // 如果不存在，则创建一个默认的 Badge 视图
        badgeView = [ZHHBadgeControl defaultBadge];
        [self addSubview:badgeView]; // 添加到当前视图
        [self bringSubviewToFront:badgeView]; // 将 Badge 提到最前
        [self setBadgeView:badgeView]; // 保存到关联对象
        [self addBadgeViewLayoutConstraint]; // 添加布局约束
    }
    return badgeView;
}

- (void)setBadgeView:(ZHHBadgeControl *)badgeView {
    // 将 Badge 视图设置为关联对象，确保其内存安全
    objc_setAssociatedObject(self, &ZHHBadgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - UIView (Constraint)

@implementation UIView (Constraint)

/// 获取视图的宽度约束
- (NSLayoutConstraint *)widthConstraint {
    return [self constraint:self attribute:NSLayoutAttributeWidth];
}

/// 获取视图的高度约束
- (NSLayoutConstraint *)heightConstraint {
    return [self constraint:self attribute:NSLayoutAttributeHeight];
}

/// 获取视图与指定视图顶部对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)topConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeTop];
}

/// 获取视图与指定视图前边对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)leadingConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeLeading];
}

/// 获取视图与指定视图底部对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)bottomConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeBottom];
}

/// 获取视图与指定视图后边对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)trailingConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeTrailing];
}

/// 获取视图与指定视图水平中心对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)centerXConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeCenterX];
}

/// 获取视图与指定视图垂直中心对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)centerYConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeCenterY];
}

/// 通用方法：根据属性和参考视图获取对应的约束
/// @param item 对齐的参考视图
/// @param layoutAttribute 需要获取的约束属性（如宽度、高度等）
/// @return 如果存在对应的约束，返回它；否则返回 nil
- (NSLayoutConstraint *)constraint:(id)item attribute:(NSLayoutAttribute)layoutAttribute {
    // 优化：使用 NSPredicate 进行更高效的查找
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint *constraint, NSDictionary *bindings) {
        return constraint.firstItem == item && constraint.firstAttribute == layoutAttribute;
    }];
    
    NSArray *matchingConstraints = [self.constraints filteredArrayUsingPredicate:predicate];
    return matchingConstraints.firstObject;
}

@end
