//
//  UIView+RectCorner.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIView+RectCorner.h"
#import <objc/runtime.h>

@implementation UIView (RectCorner)
#pragma mark - 进阶版圆角和边框扩展
- (CGFloat)zhh_radius{
    return [objc_getAssociatedObject(self, @selector(zhh_radius)) floatValue];
}
- (void)setZhh_radius:(CGFloat)zhh_radius{
    CGFloat r = [objc_getAssociatedObject(self, @selector(zhh_radius)) floatValue];
    if (r != zhh_radius) {
        objc_setAssociatedObject(self, @selector(zhh_radius), @(zhh_radius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self zhh_setRoundWithRadius:zhh_radius rectCorner:self.zhh_rectCorner];
    }
}
- (UIRectCorner)zhh_rectCorner{
    return (UIRectCorner)objc_getAssociatedObject(self, @selector(zhh_rectCorner));
}
- (void)setZhh_rectCorner:(UIRectCorner)zhh_rectCorner{
    objc_setAssociatedObject(self, @selector(zhh_rectCorner), @(zhh_rectCorner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_setRoundWithRadius:self.zhh_radius rectCorner:zhh_rectCorner];
}
/// 设置圆角
- (void)zhh_setRoundWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)corner{
    if (radius == 0) radius = 5;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - 边框相关
- (UIColor *)zhh_borderColor{
    return objc_getAssociatedObject(self, @selector(zhh_borderColor));
}
- (void)setZhh_borderColor:(UIColor *)zhh_borderColor{
    objc_setAssociatedObject(self, @selector(zhh_borderColor), zhh_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_setBorderWithWidth:self.zhh_borderWidth borderColor:zhh_borderColor borderOrientation:self.zhh_borderOrientation];
}
- (CGFloat)zhh_borderWidth{
    return [objc_getAssociatedObject(self, @selector(zhh_borderWidth)) floatValue];
}
- (void)setZhh_borderWidth:(CGFloat)zhh_borderWidth{
    objc_setAssociatedObject(self, @selector(zhh_borderWidth), @(zhh_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_setBorderWithWidth:zhh_borderWidth borderColor:self.zhh_borderColor borderOrientation:self.zhh_borderOrientation];
}
- (ZHHBorderOrientationType)zhh_borderOrientation{
    return (ZHHBorderOrientationType)objc_getAssociatedObject(self, @selector(zhh_borderOrientation));
}
- (void)setZhh_borderOrientation:(ZHHBorderOrientationType)zhh_borderOrientation{
    objc_setAssociatedObject(self, @selector(zhh_borderOrientation), @(zhh_borderOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_setBorderWithWidth:self.zhh_borderWidth borderColor:self.zhh_borderColor borderOrientation:zhh_borderOrientation];
}
/// 设置边框
- (void)zhh_setBorderWithWidth:(CGFloat)width borderColor:(UIColor *)color borderOrientation:(ZHHBorderOrientationType)orientation{
    if (orientation == UIRectEdgeNone) return;
    if (width == 0) width = 1.;
    if (color == nil) color = UIColor.blackColor;
    if (orientation == 1 || (orientation & ZHHBorderOrientationTypeTop)) {
        [self zhh_setTag:520001 borderColor:color rect:CGRectMake(0, 0, self.frame.size.width, width)];
    }
    if (orientation == 2 || (orientation & ZHHBorderOrientationTypeBottom)) {
        [self zhh_setTag:520002 borderColor:color rect:CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width)];
    }
    if (orientation == 3 || (orientation & ZHHBorderOrientationTypeLeft)) {
        [self zhh_setTag:520003 borderColor:color rect:CGRectMake(0, 0, width, self.frame.size.height)];
    }
    if (orientation == 4 || (orientation & ZHHBorderOrientationTypeRight)) {
        [self zhh_setTag:520004 borderColor:color rect:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height)];
    }
}
static char kCALayerTagKey;
- (void)zhh_setTag:(NSInteger)tag borderColor:(UIColor *)color rect:(CGRect)rect{
    __block BOOL boo = NO;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * obj, NSUInteger idx, BOOL * stop) {
        if ([objc_getAssociatedObject(obj, &kCALayerTagKey) intValue] == tag) {
            boo = YES;
            obj.frame = rect;
            obj.backgroundColor = color.CGColor;
            *stop = YES;
        }
    }];
    if (boo == NO) {
        CALayer *layer = [CALayer layer];
        objc_setAssociatedObject(layer, &kCALayerTagKey, @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        layer.frame = rect;
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}
#pragma mark - 渐变相关

- (CAGradientLayer *)zhh_gradientLayerWithColors:(NSArray *)colors
                                          frame:(CGRect)frm
                                      locations:(NSArray *)locations
                                     startPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil || [colors isKindOfClass:[NSNull class]] || colors.count == 0){
        return nil;
    }
    if (locations == nil || [locations isKindOfClass:[NSNull class]] || locations.count == 0){
        return nil;
    }
    NSMutableArray *colorsTemp = [NSMutableArray new];
    for (UIColor *color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsTemp addObject:(__bridge id)color.CGColor];
        }
    }
    gradientLayer.colors = colorsTemp;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame =  frm;
    return gradientLayer;
}

- (void)zhh_gradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *layer = [self zhh_gradientLayerWithColors:colors frame:self.bounds locations:locations startPoint:startPoint endPoint:endPoint];
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)zhh_dashedLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth spaceArray:(NSArray<NSNumber*>*)spaceAry {
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    if (self.layer.cornerRadius > 0) {
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds
                                                      cornerRadius:self.layer.cornerRadius].CGPath;
    } else {
        borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    }
    borderLayer.lineWidth = lineWidth / [UIScreen mainScreen].scale;
    borderLayer.lineDashPattern = spaceAry;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer addSublayer:borderLayer];
}

#pragma mark - 指定图形
// 画直线
- (void)zhh_drawLineWithPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint lineColor:(UIColor *)color lineWidth:(CGFloat)width{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    if (color) shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:fPoint];
        [path addLineToPoint:tPoint];
        path.CGPath;
    });
    shapeLayer.lineWidth = width;
    [self.layer addSublayer:shapeLayer];
}

// 画虚线
- (void)zhh_drawDashLineWithPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint lineColor:(UIColor *)color lineWidth:(CGFloat)width lineSpace:(CGFloat)space lineType:(NSInteger)type{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    if (color) shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:fPoint];
        [path addLineToPoint:tPoint];
        path.CGPath;
    });
    //第一格虚线缩进多少 - the degree of indent of the first cell
    //shapeLayer.lineDashPhase = 4;
    shapeLayer.lineWidth = width;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.lineDashPattern = @[@(width),@(space)];
    if (type == 1) {
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineDashPattern = @[@(width),@(space+width)];
    }
    [self.layer addSublayer:shapeLayer];
}

- (void)zhh_drawPentagramWithCenter:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color rate:(CGFloat)rate{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    if (color) {
        shapeLayer.fillColor = color.CGColor;
    }
    shapeLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        //五角星最上面的点
        CGPoint first  = CGPointMake(center.x, center.y-radius);
        [path moveToPoint:first];
        //点与点之间点夹角为2*M_PI/5.0,要隔一个点才连线
        CGFloat angle = 4 * M_PI / 5.0;
        if (rate > 1.5) rate = 1.5;
        for (int i= 1; i <= 5; i++) {
            CGFloat x = center.x - sinf(i*angle)*radius;
            CGFloat y = center.y - cosf(i*angle)*radius;
            CGFloat midx = center.x - sinf(i*angle-2*M_PI/5.0)*radius*rate;
            CGFloat midy = center.y - cosf(i*angle-2*M_PI/5.0)*radius*rate;
            [path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:CGPointMake(midx, midy)];
        }
        path.CGPath;
    });
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:shapeLayer];
}

// 画正六边形
- (void)zhh_drawSexangleWithWidth:(CGFloat)width lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)color fillColor:(UIColor *)fcolor{
    //在绘制layer之前先把之前添加的layer移除掉，如果不这么做，你就会发现设置多次image 之后，本view的layer上就会有多个子layer，
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * obj, NSUInteger idx, BOOL * stop) {
        [obj removeFromSuperlayer];
    }];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self getSexangleCGPath:width];
    shapeLayer.strokeColor = color == nil ? [UIColor lightGrayColor].CGColor : color.CGColor;
    shapeLayer.fillColor =  fcolor == nil ? [UIColor clearColor].CGColor : fcolor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:shapeLayer];
}

// 根据宽高画八边形   px:放大px点个坐标  py:放大py点个坐标
- (void)zhh_drawOctagonWithWidth:(CGFloat)width height:(CGFloat)height lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)color fillColor:(UIColor *)fcolor px:(CGFloat)px py:(CGFloat)py{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self getOctagonCGPath:width Height:height Px:px Py:py];
    shapeLayer.strokeColor = color == nil ? [UIColor lightGrayColor].CGColor : color.CGColor;
    shapeLayer.fillColor = fcolor == nil ? [UIColor clearColor].CGColor : fcolor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:shapeLayer];
}
#pragma mark - 贝塞尔曲线算出路径坐标
/** 计算菱形的UIBezierPath*/
- (CGPathRef)getSexangleCGPath:(CGFloat)w {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake((sin(M_1_PI/180*60))*(w/2), (w/4))];
    [path addLineToPoint:CGPointMake((w/2), 0)];
    [path addLineToPoint:CGPointMake(w- ((sin(M_1_PI/180*60))*(w/2)), (w/4))];
    [path addLineToPoint:CGPointMake(w- ((sin(M_1_PI/180*60))*(w/2)), (w/2)+(w/4))];
    [path addLineToPoint:CGPointMake((w/2), w)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI/180*60))*(w/2), (w/2)+(w/4))];
    [path closePath];
    return path.CGPath;
}
// 八边形坐标
- (CGPathRef)getOctagonCGPath:(CGFloat)w Height:(CGFloat)h Px:(CGFloat)px Py:(CGFloat)py{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat t = h/(2+sqrt(2));
    CGFloat m = w - 2*t;
    CGFloat r = sqrt(2)*t;
    // 未完成算偏移的坐标
    [path moveToPoint:CGPointMake(t-px,0-py)];
    [path addLineToPoint:CGPointMake(t+m+px,0-py)];
    [path addLineToPoint:CGPointMake(w+px,t)];
    [path addLineToPoint:CGPointMake(w+px,t+r)];
    [path addLineToPoint:CGPointMake(m+t+px,h+py)];
    [path addLineToPoint:CGPointMake(t-px,h+py)];
    [path addLineToPoint:CGPointMake(0-px,t+r)];
    [path addLineToPoint:CGPointMake(0-px,t)];
    
    [path closePath];  // 闭合
    return path.CGPath;
}
@end
