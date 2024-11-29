//
//  UIView+ZHHCustomBorder.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHCustomBorder.h"
#import <objc/runtime.h>

@implementation UIView (ZHHCustomBorder)

#pragma mark - Public Methods

/// 移除顶部边框
- (void)zhh_removeTopBorder {
    [self zhh_removeBorderWithTag:ZHHCustomBorderPositionTop];
}

/// 移除左侧边框
- (void)zhh_removeLeftBorder {
    [self zhh_removeBorderWithTag:ZHHCustomBorderPositionLeft];
}

/// 移除底部边框
- (void)zhh_removeBottomBorder {
    [self zhh_removeBorderWithTag:ZHHCustomBorderPositionBottom];
}

/// 移除右侧边框
- (void)zhh_removeRightBorder {
    [self zhh_removeBorderWithTag:ZHHCustomBorderPositionRight];
}

/// 添加顶部边框
- (void)zhh_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addBorderWithTag:ZHHCustomBorderPositionTop color:color width:borderWidth excludePoint:0 edgeType:0];
}

/// 添加左侧边框
- (void)zhh_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addBorderWithTag:ZHHCustomBorderPositionLeft color:color width:borderWidth excludePoint:0 edgeType:0];
}

/// 添加底部边框
- (void)zhh_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addBorderWithTag:ZHHCustomBorderPositionBottom color:color width:borderWidth excludePoint:0 edgeType:0];
}

/// 添加右侧边框
- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addBorderWithTag:ZHHCustomBorderPositionRight color:color width:borderWidth excludePoint:0 edgeType:0];
}

#pragma mark - Private Methods

/// 移除指定 tag 的边框
/// @param tag 边框的 tag
- (void)zhh_removeBorderWithTag:(NSInteger)tag {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == tag) {
            [subView removeFromSuperview];
        }
    }];
}

/// 添加指定位置的边框
/// @param tag 边框的 tag，用于标识边框
/// @param color 边框颜色
/// @param borderWidth 边框宽度
/// @param excludePoint 排除起点或终点的长度
/// @param edgeType 指定排除点的类型
- (void)zhh_addBorderWithTag:(NSInteger)tag color:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)excludePoint edgeType:(ZHHExcludePoint)edgeType {
    [self zhh_removeBorderWithTag:tag];
    
    UIView *border = [[UIView alloc] init];
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = tag;
    [self addSubview:border];
    
    CGFloat startPoint = (edgeType & ZHHExcludeStartPoint) ? excludePoint : 0;
    CGFloat endPoint = (edgeType & ZHHExcludeEndPoint) ? excludePoint : 0;
    
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        border.translatesAutoresizingMaskIntoConstraints = NO;
        [self zhh_addConstraintsForBorder:border withTag:tag width:borderWidth startPoint:startPoint endPoint:endPoint];
    } else {
        [self zhh_setBorderFrame:border withTag:tag width:borderWidth startPoint:startPoint endPoint:endPoint];
    }
}

/// 添加边框的布局约束
/// @param border 边框视图
/// @param position 边框 位置，用于区分方向
/// @param width 边框宽度
/// @param startPoint 边框起点偏移量
/// @param endPoint 边框终点偏移量
- (void)zhh_addConstraintsForBorder:(UIView *)border withTag:(ZHHCustomBorderPosition)position width:(CGFloat)width startPoint:(CGFloat)startPoint endPoint:(CGFloat)endPoint {
    switch (position) {
        case ZHHCustomBorderPositionTop:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:startPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-endPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
            break;
        case ZHHCustomBorderPositionLeft:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:startPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-endPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
            break;
        case ZHHCustomBorderPositionBottom:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:startPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-endPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
            break;
        case ZHHCustomBorderPositionRight:
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:startPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-endPoint]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
            break;
    }
}

/// 手动设置边框的 frame
/// @param border 边框视图
/// @param tag 边框 tag，用于区分方向
/// @param width 边框宽度
/// @param startPoint 边框起点偏移量
/// @param endPoint 边框终点偏移量
- (void)zhh_setBorderFrame:(UIView *)border withTag:(NSInteger)tag width:(CGFloat)width startPoint:(CGFloat)startPoint endPoint:(CGFloat)endPoint {
    switch (tag) {
        case ZHHCustomBorderPositionTop:
            border.frame = CGRectMake(startPoint, 0, self.bounds.size.width - startPoint - endPoint, width);
            break;
        case ZHHCustomBorderPositionLeft:
            border.frame = CGRectMake(0, startPoint, width, self.bounds.size.height - startPoint - endPoint);
            break;
        case ZHHCustomBorderPositionBottom:
            border.frame = CGRectMake(startPoint, self.bounds.size.height - width, self.bounds.size.width - startPoint - endPoint, width);
            break;
        case ZHHCustomBorderPositionRight:
            border.frame = CGRectMake(self.bounds.size.width - width, startPoint, width, self.bounds.size.height - startPoint - endPoint);
            break;
    }
}

@end
