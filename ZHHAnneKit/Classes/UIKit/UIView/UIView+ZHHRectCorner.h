//
//  UIView+ZHHRectCorner.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2025/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 圆角方向组合（支持多个方向同时使用）
typedef NS_OPTIONS(NSUInteger, ZHHRectCornerMask) {
    ZHHRectCornerMaskNone         = 0,        ///< 无圆角
    ZHHRectCornerMaskTopLeft      = 1 << 0,   ///< 左上角
    ZHHRectCornerMaskTopRight     = 1 << 1,   ///< 右上角
    ZHHRectCornerMaskBottomLeft   = 1 << 2,   ///< 左下角
    ZHHRectCornerMaskBottomRight  = 1 << 3,   ///< 右下角
    ZHHRectCornerMaskAllCorners   = ZHHRectCornerMaskTopLeft | ZHHRectCornerMaskTopRight | ZHHRectCornerMaskBottomLeft | ZHHRectCornerMaskBottomRight ///< 所有圆角
};

/// 渐变方向
typedef NS_ENUM(NSInteger, ZHHGradientDirection) {
    ZHHGradientDirectionHorizontal = 1, ///< 横向渐变（左 → 右）
    ZHHGradientDirectionVertical   = 2  ///< 纵向渐变（上 → 下）
};

/// 边框位置枚举（支持多个方向组合使用）
typedef NS_OPTIONS(NSUInteger, ZHHBorderPositionMask) {
    ZHHBorderPositionNone   = 0,        ///< 不显示任何边框
    ZHHBorderPositionTop    = 1 << 0,   ///< 顶部边框
    ZHHBorderPositionLeft   = 1 << 1,   ///< 左侧边框
    ZHHBorderPositionBottom = 1 << 2,   ///< 底部边框
    ZHHBorderPositionRight  = 1 << 3,   ///< 右侧边框
    ZHHBorderPositionAll    = ZHHBorderPositionTop | ZHHBorderPositionLeft | ZHHBorderPositionBottom | ZHHBorderPositionRight ///< 所有边框
};

@interface UIView (ZHHRectCorner)

#pragma mark - 圆角样式

/// 圆角方向（可组合使用，参考 ZHHRectCornerMask，默认全部圆角）
@property (nonatomic, assign) ZHHRectCornerMask zhh_cornersMask;

/// 圆角半径（当设置为 circle 时自动取最小边一半）
@property (nonatomic, assign) CGFloat zhh_cornerRadius;

#pragma mark - 边框样式

/// 边框线条宽度（默认 0，无边框）
@property (nonatomic, assign) CGFloat zhh_borderWidth;

/// 边框颜色（默认 nil，无颜色）
@property (nonatomic, strong, nullable) UIColor *zhh_borderColor;

/// 需要显示的边框方向（可多选组合，默认 ZHHBorderPositionAll）
@property (nonatomic, assign) ZHHBorderPositionMask zhh_bordersMask;

#pragma mark - 阴影样式

/// 阴影颜色（默认 nil，表示不显示阴影）
@property (nonatomic, strong, nullable) UIColor *zhh_shadowColor;

/// 阴影模糊半径（默认 1，数值越大越模糊）
@property (nonatomic, assign) CGFloat zhh_shadowRadius;

/// 阴影透明度（默认 1，0 为透明，1 为不透明）
@property (nonatomic, assign) CGFloat zhh_shadowOpacity;

/// 阴影偏移（默认 CGSizeZero）
@property (nonatomic, assign) CGSize zhh_shadowOffset;

#pragma mark - 渐变样式

/// 渐变方向（水平 or 垂直，默认垂直）
@property (nonatomic, assign) ZHHGradientDirection zhh_gradientDirection;

/// 渐变颜色数组（支持多色渐变，最少 2 个颜色，优先级高于主题色）
@property (nonatomic, strong, nullable) NSArray<UIColor *> *zhh_gradientColors;

/// 渐变位置数组（每个值为 0~1，对应颜色分布，数量与颜色数组相等，否则无效）
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *zhh_gradientLocations;

@end

NS_ASSUME_NONNULL_END
