//
//  UIView+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHExtend.h"
#import <objc/runtime.h>

@implementation UIView (ZHHExtend)
+ (instancetype)zhh_viewWithColor:(UIColor *_Nonnull)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)zhh_createBordersWithColor:(UIColor * _Nonnull)color radius:(CGFloat)radius width:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.shouldRasterize = NO;
    self.layer.rasterizationScale = 2;
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGColorRef cgColor = [color CGColor];
    self.layer.borderColor = cgColor;
    CGColorSpaceRelease(space);
}

- (void)zhh_removeBorders{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = nil;
}

/// 添加阴影效果
- (void)zhh_addShadowToWithColor:(UIColor *)color {
    self.layer.masksToBounds = NO;
    // 阴影颜色
    self.layer.shadowColor = color.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = CGSizeMake(0,2);
    // 阴影透明度，默认1.0
    self.layer.shadowOpacity = 0.5f;
    // 阴影半径，默认5
    self.layer.shadowRadius = 10;
    self.layer.cornerRadius = 10;
}

- (void)zhh_setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    [self.layer setMasksToBounds:YES];
}

- (void)zhh_setCornerRadiusWithRectCorners:(UIRectCorner)corners radius:(CGFloat)radius{
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corners;
#else
    if ((NO)) {
#endif
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (void)zhh_setViewBackgroundImage:(UIImage *_Nonnull)image{
//    self.layer.contents = (id)image.CGImage;
    UIGraphicsBeginImageContext(self.frame.size);
    [image drawInRect:self.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

- (void)zhh_setGradientLayerWithRoundingCorners:(UIRectCorner)corners
                                  byCornerRadii:(CGSize)cornerRadii andColors:(NSArray *_Nonnull)colors
                                     startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
                                      locations:(NSArray<NSNumber *>*_Nonnull)locations{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(-0.89, 0.5);
    gl.endPoint = CGPointMake(1.36, 0.5);
    gl.colors = colors;
    gl.locations = @[@(0), @(1.0f)];
    
    UIBezierPath*maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];//圆角大小
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = maskPath.CGPath;
    self.layer.mask = layer;
    self.layer.masksToBounds = YES;

    [self.layer insertSublayer:gl atIndex:0];
}
@end

@implementation UIView (IBExtension)

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

@end
