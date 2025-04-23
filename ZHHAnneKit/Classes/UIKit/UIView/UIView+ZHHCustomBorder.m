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
- (void)zhh_addTopBorderWithColor:(UIColor *)color height:(CGFloat)height {
    [self zhh_addBorderWithPosition:ZHHCustomBorderPositionTop color:color width:height inset:0 edgeType:ZHHBorderInsetNone];
}

/// 添加左侧边框
- (void)zhh_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)width {
    [self zhh_addBorderWithPosition:ZHHCustomBorderPositionLeft color:color width:width inset:0 edgeType:ZHHBorderInsetNone];
}

/// 添加底部边框
- (void)zhh_addBottomBorderWithColor:(UIColor *)color height:(CGFloat)height {
    [self zhh_addBorderWithPosition:ZHHCustomBorderPositionBottom color:color width:height inset:0 edgeType:ZHHBorderInsetNone];
}

/// 添加右侧边框
- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)width {
    [self zhh_addBorderWithPosition:ZHHCustomBorderPositionRight color:color width:width inset:0 edgeType:ZHHBorderInsetNone];
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
/// @param position 边框的 tag，用于标识边框
/// @param color 边框颜色
/// @param width 边框宽度
/// @param inset 排除起点或终点的长度
/// @param edgeType 指定排除点的类型
- (void)zhh_addBorderWithPosition:(NSInteger)position color:(UIColor *)color width:(CGFloat)width inset:(CGFloat)inset edgeType:(ZHHBorderInsetMode)edgeType {
    [self zhh_removeBorderWithTag:position];
    
    UIView *border = [[UIView alloc] init];
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = position;
    [self addSubview:border];
    
    CGFloat margin = (edgeType & ZHHBorderInsetEqual) ? inset : 0;
    
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        border.translatesAutoresizingMaskIntoConstraints = NO;
        [self zhh_setBorderConstraints:border position:position width:width inset:margin];
    } else {
        [self zhh_setBorderFrame:border position:position width:width inset:inset];
    }
}

/// 为指定方向的边框视图添加 Auto Layout 约束
///
/// @param border     要添加约束的边框视图（线条）
/// @param position   边框位置（上、下、左、右），使用 ZHHCustomBorderPosition 枚举标识
/// @param width      边框线条的厚度（横向为高度，纵向为宽度）
/// @param inset      边缘内间距（等距缩进，影响边框的起始点与终点）
///
/// @discussion 使用此方法可便捷地为指定方向的边框线设置自动布局约束，常用于 StackView 或其他布局容器中的分隔线场景。
- (void)zhh_setBorderConstraints:(UIView *)border position:(ZHHCustomBorderPosition)position width:(CGFloat)width inset:(CGFloat)inset {

    border.translatesAutoresizingMaskIntoConstraints = NO;

    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];

    switch (position) {
        case ZHHCustomBorderPositionTop: {
            [constraints addObjectsFromArray:@[
                [border.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:inset],
                [border.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-inset],
                [border.topAnchor constraintEqualToAnchor:self.topAnchor],
                [border.heightAnchor constraintEqualToConstant:width]
            ]];
        } break;

        case ZHHCustomBorderPositionBottom: {
            [constraints addObjectsFromArray:@[
                [border.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:inset],
                [border.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-inset],
                [border.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                [border.heightAnchor constraintEqualToConstant:width]
            ]];
        } break;

        case ZHHCustomBorderPositionLeft: {
            [constraints addObjectsFromArray:@[
                [border.topAnchor constraintEqualToAnchor:self.topAnchor constant:inset],
                [border.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-inset],
                [border.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [border.widthAnchor constraintEqualToConstant:width]
            ]];
        } break;

        case ZHHCustomBorderPositionRight: {
            [constraints addObjectsFromArray:@[
                [border.topAnchor constraintEqualToAnchor:self.topAnchor constant:inset],
                [border.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-inset],
                [border.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [border.widthAnchor constraintEqualToConstant:width]
            ]];
        } break;
    }

    [NSLayoutConstraint activateConstraints:constraints];
}

/// 手动设置边框的 frame（适用于非自动布局场景）
///
/// @param border    边框视图（线条视图）
/// @param position  边框方向（上、下、左、右），使用 ZHHCustomBorderPosition 枚举
/// @param width 边框线条的厚度（上/下为高度，左/右为宽度）
/// @param inset     边框线距离起止边的内边距（等距缩进）
///
/// @note 该方法用于根据位置手动设置边框的 frame，不依赖 Auto Layout
- (void)zhh_setBorderFrame:(UIView *)border position:(ZHHCustomBorderPosition)position width:(CGFloat)width inset:(CGFloat)inset {
    CGFloat _width = self.bounds.size.width;
    CGFloat _height = self.bounds.size.height;
    CGFloat doubleInset = inset * 2;

    CGRect frame = CGRectZero;

    switch (position) {
        case ZHHCustomBorderPositionTop:
            frame = CGRectMake(inset, 0, _width - doubleInset, width);
            break;

        case ZHHCustomBorderPositionLeft:
            frame = CGRectMake(0, inset, width, _height - doubleInset);
            break;

        case ZHHCustomBorderPositionBottom:
            frame = CGRectMake(inset, _height - width, _width - doubleInset, width);
            break;

        case ZHHCustomBorderPositionRight:
            frame = CGRectMake(_width - width, inset, width, _height - doubleInset);
            break;

        default:
            break;
    }

    border.frame = frame;
}

@end
