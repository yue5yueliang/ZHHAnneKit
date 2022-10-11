//
//  UIView+ZHHRectCorner.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, ZHHBorderOrientationType) {
    ZHHBorderOrientationTypeUnknown = 1 << 0,/// unknown edge
    ZHHBorderOrientationTypeTop     = 1 << 1,/// top
    ZHHBorderOrientationTypeBottom  = 1 << 2,/// bottom
    ZHHBorderOrientationTypeLeft    = 1 << 3,/// left
    ZHHBorderOrientationTypeRight   = 1 << 4,/// right
};

@interface UIView (ZHHRectCorner)

#pragma mark - 高级圆角和边框扩展

/// 圆角半径，默认为5px
@property (nonatomic, assign) CGFloat zhh_radius;
/// 圆角方向
@property (nonatomic, assign) UIRectCorner zhh_rectCorner;

/// 边框颜色，默认为黑色
@property (nonatomic, strong) UIColor *zhh_borderColor;
/// 边框宽度，默认为1px
@property (nonatomic, assign) CGFloat zhh_borderWidth;
/// 边界位置，必需参数
@property (nonatomic, assign) ZHHBorderOrientationType zhh_borderOrientation;

/// 虚线边框
/// @param lineColor line color
/// @param lineWidth line width
/// @param spaceAry array of intervals between lines
- (void)zhh_dashedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth spaceArray:(NSArray<NSNumber*>*)spaceAry;

#pragma mark - Gradient related

/// Gradient layer
/// @param colors gradient color array
/// @param frame The size of the gradient
/// @param locations The dividing point of the gradient color
/// @param startPoint start coordinates, the range is between (0,0) and (1,1), such as (0,0)(1,0) represents the horizontal gradient, (0,0)(0,1) ) Represents a vertical gradient
/// @param endPoint end coordinates
/// @return Return to the gradient layer
- (CAGradientLayer *)zhh_gradientLayerWithColors:(NSArray *)colors frame:(CGRect)frame locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/// 生成渐变背景色
/// @param colors gradient color array
/// @param locations The dividing point of the gradient color
/// @param startPoint start coordinates
/// @param endPoint end coordinates
- (void)zhh_gradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

#pragma mark - Specify graphics

/// 划条直线。
- (void)zhh_drawLineWithPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint lineColor:(UIColor *)color lineWidth:(CGFloat)width;

/// 画一条虚线
- (void)zhh_drawDashLineWithPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint lineColor:(UIColor *)color lineWidth:(CGFloat)width lineSpace:(CGFloat)space lineType:(NSInteger)type;

/// 画一个五角星
- (void)zhh_drawPentagramWithCenter:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color rate:(CGFloat)rate;

/// 根据宽度和高度绘制一个六边形
- (void)zhh_drawSexangleWithWidth:(CGFloat)width lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)color fillColor:(UIColor *)fcolor;

/// 根据宽度和高度绘制一个八角形
- (void)zhh_drawOctagonWithWidth:(CGFloat)width height:(CGFloat)height lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)color fillColor:(UIColor *)fcolor px:(CGFloat)px py:(CGFloat)py;

@end

NS_ASSUME_NONNULL_END
