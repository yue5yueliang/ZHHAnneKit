//
//  UIView+ZHHCustomBorder.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHCustomBorder.h"

typedef NS_ENUM(NSInteger, EdgeType) {
    TopBorder = 10000,
    LeftBorder = 20000,
    BottomBorder = 30000,
    RightBorder = 40000
};
@implementation UIView (ZHHCustomBorder)
- (void)zhh_removeTopBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == TopBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)zhh_removeLeftBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == LeftBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)zhh_removeBottomBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == BottomBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)zhh_removeRightBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == RightBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)zhh_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addTopBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)zhh_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addLeftBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)zhh_addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth {
    [self zhh_addBottomBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth {
    [self zhh_addRightBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)zhh_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge {
    [self zhh_removeTopBorder];
    
    UIView *border = [[UIView alloc] init];
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        border.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = TopBorder;
    
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ZHHExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ZHHExcludeEndPoint) {
        endPoint += point;
    }
    
    if (border.translatesAutoresizingMaskIntoConstraints) {
        CGFloat borderLenght = self.bounds.size.width - endPoint - startPoint;
        border.frame = CGRectMake(startPoint, 0.0, borderLenght, borderWidth);
        return;
    }
    
    // AutoLayout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:startPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-endPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth]];
}


- (void)zhh_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge {
    [self zhh_removeLeftBorder];
    
    UIView *border = [[UIView alloc] init];
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        border.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = LeftBorder;
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ZHHExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ZHHExcludeEndPoint) {
        endPoint += point;
    }
    
    if (border.translatesAutoresizingMaskIntoConstraints) {
        CGFloat borderLength = self.bounds.size.height - startPoint - endPoint;
        border.frame = CGRectMake(0.0, startPoint, borderWidth, borderLength);
        return;
    }
    
    // AutoLayout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:startPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-endPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth]];
    
}


- (void)zhh_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge {
    [self zhh_removeBottomBorder];
    
    UIView *border = [[UIView alloc] init];
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        border.translatesAutoresizingMaskIntoConstraints = NO;
    }
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = BottomBorder;
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ZHHExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ZHHExcludeEndPoint) {
        endPoint += point;
    }

    
    if (border.translatesAutoresizingMaskIntoConstraints) {
        CGFloat borderLength = self.bounds.size.width - startPoint - endPoint;
        border.frame = CGRectMake(startPoint, self.bounds.size.height - borderWidth, borderLength, borderWidth);
        return;
    }
    
    // AutoLayout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:startPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-endPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth]];
}

- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge {
    [self zhh_removeRightBorder];
    
    UIView *border = [[UIView alloc] init];
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        border.translatesAutoresizingMaskIntoConstraints = NO;
    }
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = RightBorder;
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ZHHExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ZHHExcludeEndPoint) {
        endPoint += point;
    }

    if (border.translatesAutoresizingMaskIntoConstraints) {
        CGFloat borderLength = self.bounds.size.height - startPoint - endPoint;
        border.frame = CGRectMake(self.bounds.size.width - borderWidth, startPoint, borderWidth, borderLength);
        return;
    }
    
    // AutoLayout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:startPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-endPoint]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth]];
}


@end
