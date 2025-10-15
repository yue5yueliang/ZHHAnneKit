//
//  UIView+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHUtilities.h"

@implementation UIView (ZHHUtilities)
/**
 * @brief 创建一个指定背景颜色的 UIView 实例。
 *
 * @param color UIView 的背景颜色，不能为空。
 * @return 创建并设置了背景颜色的 UIView 实例。
 */
+ (instancetype)zhh_viewWithColor:(UIColor *_Nonnull)color {
    // 检查 color 是否为空，防止意外传入 nil
    NSParameterAssert(color);
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color; // 设置背景颜色
    return view;
}

/**
 * @brief 为视图添加圆角和边框设置。
 *
 * @param color 边框颜色，不能为空。
 * @param radius 圆角半径。
 * @param width 边框宽度。
 */
- (void)zhh_createBordersWithColor:(UIColor * _Nonnull)color radius:(CGFloat)radius width:(CGFloat)width {
    NSParameterAssert(color); // 确保传入的颜色不为空
    // 设置边框宽度
    self.layer.borderWidth = width;
    // 设置圆角半径
    self.layer.cornerRadius = radius;
    // 禁用光栅化（可根据需求调整）
    self.layer.shouldRasterize = NO;
    // 如果启用光栅化，可设置比例因子
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    // 为边框启用抗锯齿
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    // 剪切多余内容
    self.clipsToBounds = YES;
    // 确保子图层遵守边界
    self.layer.masksToBounds = YES;
    // 设置边框颜色
    self.layer.borderColor = color.CGColor;
}

/**
 * @brief 移除视图的边框和圆角设置。
 */
- (void)zhh_removeBorders{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = nil;
}

/**
 * @brief 为视图添加阴影效果。
 *
 * @param color 阴影的颜色。
 */
- (void)zhh_shadowWithColor:(UIColor * _Nonnull)color {
    // 调用带参数的主方法，使用默认配置
    [self zhh_shadowWithColor:color offset:CGSizeMake(0, 2) opacity:0.5 radius:10 cornerRadius:10];
}

/**
 * @brief 使用自定义属性为视图绘制阴影。
 *
 * @param color        阴影的颜色。
 * @param offset       阴影的偏移量（默认值为 CGSizeZero 表示无偏移）。
 * @param opacity      阴影的不透明度（范围 0.0~1.0）。
 * @param radius       阴影的模糊半径。
 * @param cornerRadius 圆角半径，默认为 0。
 */
- (void)zhh_shadowWithColor:(UIColor * _Nonnull)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius {
    // 禁用子视图裁剪以允许阴影显示
    self.clipsToBounds = NO;
    // 设置阴影属性
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    // 可选地设置圆角
    self.layer.cornerRadius = cornerRadius;
}

/**
 * @brief 设置视图的圆角半径。
 * @param radius 圆角的半径值。
 */
- (void)zhh_cornerRadius:(CGFloat)radius {
    // 设置圆角半径
    self.layer.cornerRadius = radius;
    // 启用子视图裁剪，以确保圆角效果
    self.layer.masksToBounds = YES;
}

/**
 * @brief 设置视图的圆角半径、边框宽度和边框颜色。
 *
 * @param radius 圆角半径
 * @param borderWidth 边框宽度
 * @param color 边框颜色
 */
- (void)zhh_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth color:(UIColor *)color {
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

/**
 * @brief 为指定的角设置圆角半径。
 * @param corners 指定需要圆角的角，例如顶部两个角或底部两个角。
 * @param radius 圆角的半径值。
 */
- (void)zhh_cornerRadiusWithRectCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    
    // 将 UIRectCorner 转换为 CACornerMask
    CACornerMask maskedCorners = 0;
    if (corners & UIRectCornerTopLeft) maskedCorners |= kCALayerMinXMinYCorner;
    if (corners & UIRectCornerTopRight) maskedCorners |= kCALayerMaxXMinYCorner;
    if (corners & UIRectCornerBottomLeft) maskedCorners |= kCALayerMinXMaxYCorner;
    if (corners & UIRectCornerBottomRight) maskedCorners |= kCALayerMaxXMaxYCorner;
    
    self.layer.maskedCorners = maskedCorners;
}

/**
 * @brief 设置视图的背景图像。
 * @param image 要设置为背景的图片。
 */
- (void)zhh_viewBackgroundImage:(UIImage *_Nonnull)image contentsGravity:(CALayerContentsGravity _Nullable)contentsGravity{
    // 使用 layer.contents 设置背景图像更高效
    self.layer.contents = (id)image.CGImage;
    self.layer.contentsGravity = contentsGravity ?: kCAGravityResizeAspectFill; // 默认值
}

/// 添加模糊效果视图
/// @param style 模糊效果的样式，使用 `UIBlurEffectStyle` 枚举类型，例如 `UIBlurEffectStyleLight`, `UIBlurEffectStyleDark` 等
- (void)zhh_addBlurEffectWithStyle:(UIBlurEffectStyle)style {
    // 创建模糊效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.bounds;
    
    // 将模糊视图添加到视图的最底层
    [self insertSubview:effectView atIndex:0];
}

/*
 * 从视图中移除并应用淡入效果
 *
 * @param duration 淡入动画的持续时间。
 */
- (void)zhh_removeFromSuperviewWithFadeDuration:(NSTimeInterval)duration {
    // 使用现代的动画 API
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
 * 向父视图添加子视图，并应用指定的过渡动画
 *
 * @param subview 要添加的子视图。
 * @param transition 视图过渡动画类型。
 * @param duration 动画持续时间。
 */
- (void)zhh_addSubview:(UIView *)subview withTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration {
    // 使用新的过渡动画 API
    UIViewAnimationOptions options;
    switch (transition) {
        case UIViewAnimationTransitionFlipFromLeft:
            options = UIViewAnimationOptionTransitionFlipFromLeft;
            break;
        case UIViewAnimationTransitionFlipFromRight:
            options = UIViewAnimationOptionTransitionFlipFromRight;
            break;
        case UIViewAnimationTransitionCurlUp:
            options = UIViewAnimationOptionTransitionCurlUp;
            break;
        case UIViewAnimationTransitionCurlDown:
            options = UIViewAnimationOptionTransitionCurlDown;
            break;
        case UIViewAnimationTransitionNone:
        default:
            options = UIViewAnimationOptionTransitionNone;
            break;
    }

    [UIView transitionWithView:self duration:duration options:options animations:^{
        [self addSubview:subview];
    } completion:nil];
}

/*
 * 从父视图中移除视图，并应用指定的过渡动画
 *
 * @param transition 视图过渡动画类型。
 * @param duration 动画持续时间。
 */
- (void)zhh_removeFromSuperviewWithTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration {
    // 使用新的过渡动画 API
    UIViewAnimationOptions options;
    switch (transition) {
        case UIViewAnimationTransitionFlipFromLeft:
            options = UIViewAnimationOptionTransitionFlipFromLeft;
            break;
        case UIViewAnimationTransitionFlipFromRight:
            options = UIViewAnimationOptionTransitionFlipFromRight;
            break;
        case UIViewAnimationTransitionCurlUp:
            options = UIViewAnimationOptionTransitionCurlUp;
            break;
        case UIViewAnimationTransitionCurlDown:
            options = UIViewAnimationOptionTransitionCurlDown;
            break;
        case UIViewAnimationTransitionNone:
        default:
            options = UIViewAnimationOptionTransitionNone;
            break;
    }

    [UIView transitionWithView:self.superview duration:duration options:options animations:^{
        [self removeFromSuperview];
    } completion:nil];
}

/**
 * 按给定角度旋转视图
 */
- (void)zhh_rotateByAngle:(CGFloat)angle duration:(NSTimeInterval)duration autoreverse:(BOOL)autoreverse repeatCount:(CGFloat)repeatCount timingFunction:(CAMediaTimingFunction * _Nullable)timingFunction {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = @(M_PI * angle / 180.0); // 角度转换为弧度
    rotationAnimation.duration = duration > 0 ? duration : 0.5; // 默认值为 0.5 秒
    rotationAnimation.autoreverses = autoreverse;
    rotationAnimation.repeatCount = repeatCount >= 0 ? repeatCount : 0; // 默认为 0，不重复
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.timingFunction = timingFunction ?: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 默认节奏
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/**
 * 将视图移动到指定点
 */
- (void)zhh_moveToPoint:(CGPoint)newPoint duration:(NSTimeInterval)duration autoreverse:(BOOL)autoreverse repeatCount:(CGFloat)repeatCount timingFunction:(CAMediaTimingFunction * _Nullable)timingFunction {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:newPoint];
    moveAnimation.duration = duration > 0 ? duration : 0.5; // 默认值为 0.5 秒
    moveAnimation.autoreverses = autoreverse;
    moveAnimation.repeatCount = repeatCount >= 0 ? repeatCount : 0; // 默认为 0，不重复
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = timingFunction ?: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 默认节奏
    [self.layer addAnimation:moveAnimation forKey:@"positionAnimation"];
}

- (void)zhh_dashedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth spaceArray:(NSArray<NSNumber *> *)spaceAry {
    // 创建 CAShapeLayer 用于绘制虚线
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    // 设置边框的 bounds 和位置
    borderLayer.bounds = self.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 设置边框的路径
    if (self.layer.cornerRadius > 0) {
        // 如果有圆角，则绘制带圆角的矩形路径
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    } else {
        // 没有圆角，绘制矩形路径
        borderLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    
    // 设置虚线样式
    borderLayer.lineWidth = lineWidth / [UIScreen mainScreen].scale;  // 根据屏幕缩放因子调整线宽
    borderLayer.lineDashPattern = spaceAry;  // 设置虚线间隔
    
    // 设置边框颜色和填充色
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    
    // 添加到视图的层上
    [self.layer addSublayer:borderLayer];
}

// 画直线
- (void)zhh_drawLineWithPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint lineColor:(UIColor *)color lineWidth:(CGFloat)width{
    // 参数验证
    if (width <= 0) {
        NSLog(@"ZHHAnneKit 警告: 线条宽度必须大于0");
        return;
    }
    
    // 创建CAShapeLayer来绘制线条
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 设置默认颜色
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    if (color) {
        shapeLayer.strokeColor = color.CGColor; // 如果传入了颜色，则使用传入的颜色
    }
    
    // 设置填充颜色为透明
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    // 创建一个UIBezierPath来画线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:fPoint]; // 起始点
    [path addLineToPoint:tPoint]; // 结束点
    shapeLayer.path = path.CGPath;
    
    // 设置线宽
    shapeLayer.lineWidth = width;
    // 设置线条样式
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    // 添加到视图的layer中进行渲染
    [self.layer addSublayer:shapeLayer];
}

- (void)zhh_drawPentagramWithCenter:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color rate:(CGFloat)rate {
    // 参数验证
    if (radius <= 0) {
        NSLog(@"ZHHAnneKit 警告: 半径必须大于0");
        return;
    }
    
    // 限制 rate 的范围
    if (rate <= 0) rate = 1.0;
    if (rate > 1.5) rate = 1.5;
    
    // 创建一个 CAShapeLayer 用来绘制形状
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 设置边框颜色为透明，填充颜色为橙色
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    
    // 如果提供了颜色，则使用传入的颜色
    if (color) {
        shapeLayer.fillColor = color.CGColor;
    }
    
    // 创建路径（五角星形状）
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 五角星最上面的点
    CGPoint first = CGPointMake(center.x, center.y - radius);
    [path moveToPoint:first];
    
    // 计算每个点的角度（五角星的角度）
    CGFloat angle = 4 * M_PI / 5.0;  // 360度 / 5 (五角星的角度)
    
    // 循环绘制五角星的每个顶点
    for (int i = 1; i <= 5; i++) {
        // 计算每个顶点的位置
        CGFloat x = center.x - sinf(i * angle) * radius;
        CGFloat y = center.y - cosf(i * angle) * radius;
        
        // 计算控制点的位置，决定五角星的"尖角"形状
        CGFloat midx = center.x - sinf(i * angle - 2 * M_PI / 5.0) * radius * rate;
        CGFloat midy = center.y - cosf(i * angle - 2 * M_PI / 5.0) * radius * rate;
        
        // 绘制曲线连接点
        [path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:CGPointMake(midx, midy)];
    }
    
    shapeLayer.path = path.CGPath;
    
    // 设置线条宽度和线条连接方式
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    // 将形状添加到视图的图层中
    [self.layer addSublayer:shapeLayer];
}

@end
