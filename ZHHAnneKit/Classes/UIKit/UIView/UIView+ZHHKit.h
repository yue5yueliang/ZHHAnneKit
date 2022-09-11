//
//  UIView+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHKit)
/** 生成一个UIView */
+ (instancetype)zhh_viewWithColor:(UIColor *_Nonnull)color;
/**
 *  设置当前view的边界周边
 *
 *  @param color  边界的颜色
 *  @param radius 边界的拐角半径
 *  @param width  边界的宽
 */
- (void)zhh_createBordersWithColor:(UIColor * _Nonnull)color radius:(CGFloat)radius width:(CGFloat)width;
/// 移除当前view的边框
- (void)zhh_removeBorders;
/// 添加阴影效果
- (void)zhh_addShadowToWithColor:(UIColor *_Nonnull)color;
/**
 *  设置当前view的拐角半径
 *
 *  @param radius 半径值
 */
- (void)zhh_setCornerRadius:(CGFloat)radius;
/**
 *  设置View任意角度为圆角
 *  @param corners 设置的角，左上、左下、右上、右下，可以组合
 *  如左下和右上 (UIRectCornerBottomLeft | UIRectCornerTopRight)
 *  @param radius 圆角的半径
 */
- (void)zhh_setCornerRadiusWithRectCorners:(UIRectCorner)corners radius:(CGFloat)radius;
/// 设置View的背景图片
- (void)zhh_setViewBackgroundImage:(UIImage *_Nonnull)image;
/**
 *  指定圆角渐变色 @[
 *  (__bridge id)[UIColor colorWithRed:253/255.0 green:83/255.0 blue:102/255.0 alpha:1.0].CGColor,
 *  (__bridge id)[UIColor colorWithRed:209/255.0 green:35/255.0 blue:150/255.0 alpha:1.0].CGColor
 *  ];
 */
- (void)zhh_setGradientLayerWithRoundingCorners:(UIRectCorner)corners
                                  byCornerRadii:(CGSize)cornerRadii andColors:(NSArray *_Nonnull)colors
                                     startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                      locations:(NSArray<NSNumber *>*_Nonnull)locations;
@end

IB_DESIGNABLE
@interface UIView (IBExtension)

/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/// 脚半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end

typedef void (^ZHHClickActionBlock)(void);
@interface UIView (Click)<UIGestureRecognizerDelegate>
/*!
 @method
 @abstract 针对label或view的单击事件
 @param block 代码块
 */
- (void)zhh_onClickAction:(ZHHClickActionBlock)block;
@end


NS_ASSUME_NONNULL_END
