//
//  UIView+ZHHCustomBorder.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 边距排除模式
typedef NS_ENUM(NSInteger, ZHHBorderInsetMode) {
    ZHHBorderInsetNone     = 0, ///< 默认不设置边距
    ZHHBorderInsetEqual    = 1  ///< 起点/终点均设置统一边距
};

typedef NS_ENUM(NSInteger, ZHHCustomBorderPosition) {
    ZHHCustomBorderPositionTop,    ///< 顶部边框
    ZHHCustomBorderPositionLeft,   ///< 左侧边框
    ZHHCustomBorderPositionBottom, ///< 底部边框
    ZHHCustomBorderPositionRight   ///< 右侧边框
};

@interface UIView (ZHHCustomBorder)

/// 移除顶部边框
- (void)zhh_removeTopBorder;

/// 移除左侧边框
- (void)zhh_removeLeftBorder;

/// 移除底部边框
- (void)zhh_removeBottomBorder;

/// 移除右侧边框
- (void)zhh_removeRightBorder;

/// 添加顶部边框
/// @param color 边框颜色
/// @param height 边框高度
- (void)zhh_addTopBorderWithColor:(UIColor *)color height:(CGFloat)height;

/// 添加左侧边框
/// @param color 边框颜色
/// @param width 边框宽度
- (void)zhh_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)width;

/// 添加底部边框
/// @param color 边框颜色
/// @param height 边框宽度
- (void)zhh_addBottomBorderWithColor:(UIColor *)color height:(CGFloat)height;

/// 添加右侧边框
/// @param color 边框颜色
/// @param width 边框宽度
- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)width;

/// 为指定方向的边框视图添加 Auto Layout 约束
///
/// @param border     要添加约束的边框视图（线条）
/// @param position   边框位置（上、下、左、右），使用 ZHHCustomBorderPosition 枚举标识
/// @param width      边框线条的厚度（横向为高度，纵向为宽度）
/// @param inset      边缘内间距（等距缩进，影响边框的起始点与终点）
///
/// @discussion 使用此方法可便捷地为指定方向的边框线设置自动布局约束，常用于 StackView 或其他布局容器中的分隔线场景。
- (void)zhh_setBorderConstraints:(UIView *)border position:(ZHHCustomBorderPosition)position width:(CGFloat)width inset:(CGFloat)inset;

/// 手动设置边框的 frame（适用于非自动布局场景）
///
/// @param border    边框视图（线条视图）
/// @param position  边框方向（上、下、左、右），使用 ZHHCustomBorderPosition 枚举
/// @param width     边框线条的厚度（上/下为高度，左/右为宽度）
/// @param inset     边框线距离起止边的内边距（等距缩进）
///
/// @note 该方法用于根据位置手动设置边框的 frame，不依赖 Auto Layout
- (void)zhh_setBorderFrame:(UIView *)border position:(ZHHCustomBorderPosition)position width:(CGFloat)width inset:(CGFloat)inset;

@end

NS_ASSUME_NONNULL_END
