//
//  UIView+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHUtilities)
/**
 * @brief 创建一个指定背景颜色的 UIView 实例。
 *
 * @param color UIView 的背景颜色，不能为空。
 * @return 创建并设置了背景颜色的 UIView 实例。
 */
+ (instancetype)zhh_viewWithColor:(UIColor *_Nonnull)color;
/**
 * @brief 为视图添加圆角和边框设置。
 *
 * @param color 边框颜色，不能为空。
 * @param radius 圆角半径。
 * @param width 边框宽度。
 */
- (void)zhh_createBordersWithColor:(UIColor * _Nonnull)color radius:(CGFloat)radius width:(CGFloat)width ;
/**
 * @brief 移除视图的边框和圆角设置。
 */
- (void)zhh_removeBorders;
/**
 * @brief 为视图添加默认的阴影效果。
 *
 * 默认值：
 * - 阴影颜色：传入的 `color`
 * - 阴影偏移量：`CGSizeMake(0, 2)`
 * - 阴影透明度：`0.5`
 * - 模糊半径：`10`
 * - 圆角半径：`10`
 *
 * @param color 阴影的颜色（必填）。
 */
- (void)zhh_shadowWithColor:(UIColor * _Nonnull)color;

/**
 * @brief 使用自定义属性为视图绘制阴影。
 *
 * 默认值：
 * - 阴影偏移量：`CGSizeZero`（无偏移）。
 * - 阴影透明度：`1.0`（完全不透明）。
 * - 模糊半径：`0`（无模糊效果）。
 * - 圆角半径：`0`（无圆角）。
 *
 * @param color        阴影的颜色（必填）。
 * @param offset       阴影的偏移量（默认值为 `CGSizeZero`）。
 * @param opacity      阴影的不透明度（范围 `0.0~1.0`，默认值为 `1.0`）。
 * @param radius       阴影的模糊半径（默认值为 `0`）。
 * @param cornerRadius 圆角半径（默认值为 `0`）。
 */
- (void)zhh_shadowWithColor:(UIColor * _Nonnull)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius;
/**
 * @brief 设置视图的圆角半径。
 * @param radius 圆角的半径值。
 */
- (void)zhh_cornerRadius:(CGFloat)radius;
/**
 * @brief 设置视图的圆角半径、边框宽度和边框颜色。
 *
 * @param radius 圆角半径
 * @param borderWidth 边框宽度
 * @param color 边框颜色
 */
- (void)zhh_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth color:(UIColor * _Nullable)color;
/**
 * @brief 为指定的角设置圆角半径。
 * @param corners 指定需要圆角的角，例如顶部两个角或底部两个角。
 * @param radius 圆角的半径值。
 */
- (void)zhh_cornerRadiusWithRectCorners:(UIRectCorner)corners radius:(CGFloat)radius;
/**
 * @brief 设置视图的背景图像。
 * @param image 要设置为背景的图片。
 * @param contentsGravity 图像填充模式（可选），默认为 kCAGravityResizeAspectFill。
 */
- (void)zhh_viewBackgroundImage:(UIImage *_Nonnull)image contentsGravity:(CALayerContentsGravity _Nullable)contentsGravity;

/// 添加模糊效果视图
/// @param style 模糊效果的样式，使用 `UIBlurEffectStyle` 枚举类型，例如 `UIBlurEffectStyleLight`, `UIBlurEffectStyleDark` 等
- (void)zhh_addBlurEffectWithStyle:(UIBlurEffectStyle)style;

/*
 * 从视图中移除并应用淡入效果
 *
 * @param duration 淡入动画的持续时间。
 */
- (void)zhh_removeFromSuperviewWithFadeDuration:(NSTimeInterval)duration;
/*
 * 向父视图添加子视图，并应用指定的过渡动画
 *
 * @param subview 要添加的子视图。
 * @param transition 视图过渡动画类型。
 * @param duration 动画持续时间。
 */
- (void)zhh_addSubview:(UIView *)subview withTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration;
/*
 * 从父视图中移除视图，并应用指定的过渡动画
 *
 * @param transition 视图过渡动画类型。
 * @param duration 动画持续时间。
 */
- (void)zhh_removeFromSuperviewWithTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration;

/**
 * @brief 按给定角度旋转视图。
 * @param angle 旋转的角度（以度为单位，例如 90 表示顺时针旋转 90°）。
 * @param duration 动画的持续时间（默认值为 0.5 秒）。
 * @param autoreverse 是否在动画结束时自动反向播放（默认值为 NO）。
 * @param repeatCount 动画的重复次数（默认值为 0 表示不重复）。
 * @param timingFunction 动画的节奏控制函数，默认为 `kCAMediaTimingFunctionEaseInEaseOut`。
 */
- (void)zhh_rotateByAngle:(CGFloat)angle duration:(NSTimeInterval)duration autoreverse:(BOOL)autoreverse repeatCount:(CGFloat)repeatCount timingFunction:(CAMediaTimingFunction * _Nullable)timingFunction;

/**
 * @brief 将视图移动到指定点。
 * @param newPoint 视图将移动到的新位置。
 * @param duration 动画的持续时间（默认值为 0.5 秒）。
 * @param autoreverse 是否在动画结束时自动反向播放（默认值为 NO）。
 * @param repeatCount 动画的重复次数（默认值为 0 表示不重复）。
 * @param timingFunction 动画的节奏控制函数，默认为 `kCAMediaTimingFunctionEaseInEaseOut`。
 */
- (void)zhh_moveToPoint:(CGPoint)newPoint duration:(NSTimeInterval)duration autoreverse:(BOOL)autoreverse repeatCount:(CGFloat)repeatCount timingFunction:(CAMediaTimingFunction * _Nullable)timingFunction;
#pragma mark - 绘制虚线
/// 设置虚线边框
/// @param lineColor 虚线的颜色
/// @param lineWidth 虚线的宽度
/// @param spaceAry 虚线的间隔数组，每一项代表一个线段的长度和间隙的长度
/// 这段代码会为 myView 设置一个红色虚线边框，线宽为 2.0，虚线的长度为 6px，空隙为 4px。
/// [view zhh_dashedLineColor:UIColor.redColor lineWidth:2.0 spaceArray:@[@6, @4]];
- (void)zhh_dashedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth spaceArray:(NSArray<NSNumber *> *)spaceAry;
#pragma mark - 绘制直线
/// 在视图上绘制一条从 `fPoint` 到 `tPoint` 的直线
/// @param fPoint 直线的起始点
/// @param tPoint 直线的结束点
/// @param color 直线的颜色（可选）
/// @param width 直线的宽度
/// 在某个 UIView 上画一条从 (50, 100) 到 (200, 100) 的红色直线，线宽为 2.0
/// [self zhh_drawLineWithPoint:CGPointMake(50, 100) toPoint:CGPointMake(200, 100) lineColor:[UIColor redColor] lineWidth:2.0];
- (void)zhh_drawLineWithPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint lineColor:(UIColor *)color lineWidth:(CGFloat)width;
/// 绘制五角星
/// @param center 五角星的中心点
/// @param radius 五角星的半径
/// @param color 填充颜色
/// @param rate 控制五角星“尖角”的比例（值越大，尖角越短）
/// 在视图上绘制一个五角星，中心点在 (100, 100)，半径为 50，颜色为蓝色，rate 为 1.0（默认尖角长度）
/// [self zhh_drawPentagramWithCenter:CGPointMake(100, 100) radius:50 color:[UIColor blueColor] rate:1.0];
- (void)zhh_drawPentagramWithCenter:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color rate:(CGFloat)rate;
@end

NS_ASSUME_NONNULL_END
