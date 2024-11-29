//
//  UIView+ZHHCustomBorder.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 排除点类型
typedef NS_OPTIONS(NSInteger, ZHHExcludePoint) {
    ZHHExcludeNone = 0,           ///< 不排除任何点
    ZHHExcludeStartPoint = 1 << 0, ///< 排除起始点
    ZHHExcludeEndPoint = 1 << 1   ///< 排除终点
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
/// @param borderWidth 边框宽度
- (void)zhh_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;

/// 添加左侧边框
/// @param color 边框颜色
/// @param borderWidth 边框宽度
- (void)zhh_addLeftBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;

/// 添加底部边框
/// @param color 边框颜色
/// @param borderWidth 边框宽度
- (void)zhh_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;

/// 添加右侧边框
/// @param color 边框颜色
/// @param borderWidth 边框宽度
- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;

/// 添加边框的布局约束
/// @param border 边框视图
/// @param position 边框 位置，用于区分方向
/// @param width 边框宽度
/// @param startPoint 边框起点偏移量
/// @param endPoint 边框终点偏移量
- (void)zhh_addConstraintsForBorder:(UIView *)border withTag:(ZHHCustomBorderPosition)position width:(CGFloat)width startPoint:(CGFloat)startPoint endPoint:(CGFloat)endPoint;

@end

NS_ASSUME_NONNULL_END
