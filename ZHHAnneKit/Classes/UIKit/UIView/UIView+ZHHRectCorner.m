//
//  UIView+ZHHRectCorner.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2025/4/20.
//

#import "UIView+ZHHRectCorner.h"
#import <objc/runtime.h>


@interface UIView ()
#pragma mark - 内部图层属性（无需手动赋值）

/// 阴影承载视图（仅在需要圆角+阴影共存时自动添加）
@property (nonatomic, strong, readonly, nullable) UIView *shadowView;

/// 渐变图层（内部维护，供渐变样式使用）
@property (nonatomic, strong, readonly, nullable) CAGradientLayer *gradientLayer;

/// 上一次视图 size（用于判断是否需要刷新布局）
@property (nonatomic, copy, readonly, nullable) NSString *lastSize;
@end


@implementation UIView (ZHHRectCorner)
+ (void)load {
    // 需要进行方法交换的方法列表
    NSArray *selectors = @[
        @"setHidden:", @"setAlpha:", @"layoutSubviews", @"removeFromSuperview", @"setFrame:"
    ];
    
    for (NSString *originalSelectorName in selectors) {
        NSString *swizzledSelectorName = [@"zhh_" stringByAppendingString:originalSelectorName];
        
        SEL originalSelector = NSSelectorFromString(originalSelectorName);
        SEL swizzledSelector = NSSelectorFromString(swizzledSelectorName);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        // 如果原方法不存在，添加 swizzled 方法的实现
        BOOL didAddMethod = class_addMethod(self,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            // 替换 swizzled 方法的实现为原方法
            class_replaceMethod(self,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            // 正常交换两个方法实现
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

#pragma mark - cornerMask

- (ZHHRectCornerMask)zhh_cornersMask {
    return [objc_getAssociatedObject(self, @selector(zhh_cornersMask)) unsignedIntegerValue];
}

- (void)setZhh_cornersMask:(ZHHRectCornerMask)zhh_cornersMask {
    objc_setAssociatedObject(self, @selector(zhh_cornersMask), @(zhh_cornersMask), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateCornerMask];
}

#pragma mark - cornerRadius

- (CGFloat)zhh_cornerRadius {
    return [objc_getAssociatedObject(self, @selector(zhh_cornerRadius)) floatValue];
}

- (void)setZhh_cornerRadius:(CGFloat)zhh_cornerRadius {
    objc_setAssociatedObject(self, @selector(zhh_cornerRadius), @(zhh_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateCornerMask];
}

#pragma mark - 更新圆角逻辑

/// 更新圆角遮罩及相关图层圆角设置
- (void)updateCornerMask {
    // 开启裁剪以保证圆角生效
    self.clipsToBounds = YES;

    // 设置圆角半径
    CGFloat radius = self.zhh_cornerRadius;
    self.layer.cornerRadius = radius;
    self.getStyleLayer.cornerRadius = radius;
    self.gradientLayer.cornerRadius = radius;

    // 获取圆角方向
    ZHHRectCornerMask mask = self.zhh_cornersMask ?: ZHHRectCornerMaskAllCorners;

    // 转换为系统枚举
    CACornerMask systemMask = 0;
    if (mask & ZHHRectCornerMaskTopLeft)     systemMask |= kCALayerMinXMinYCorner;
    if (mask & ZHHRectCornerMaskTopRight)    systemMask |= kCALayerMaxXMinYCorner;
    if (mask & ZHHRectCornerMaskBottomLeft)  systemMask |= kCALayerMinXMaxYCorner;
    if (mask & ZHHRectCornerMaskBottomRight) systemMask |= kCALayerMaxXMaxYCorner;
    
    // 应用圆角方向
    self.layer.maskedCorners = systemMask;
}

///上一次大小
- (NSString *)lastSize{
    return objc_getAssociatedObject(self, @selector(lastSize));
}

- (void)setLastSize:(NSString *)lastSize{
    objc_setAssociatedObject(self, @selector(lastSize), lastSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///边框宽度
- (CGFloat)zhh_borderWidth {
    return [objc_getAssociatedObject(self, @selector(zhh_borderWidth)) floatValue];
}

- (void)setZhh_borderWidth:(CGFloat)zhh_borderWidth {
    objc_setAssociatedObject(self, @selector(zhh_borderWidth), @(zhh_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.borderWidth = zhh_borderWidth;
}

///边框颜色
- (UIColor *)zhh_borderColor {
    return objc_getAssociatedObject(self, @selector(zhh_borderColor));
}

- (void)setZhh_borderColor:(UIColor *)zhh_borderColor {
    objc_setAssociatedObject(self, @selector(zhh_borderColor), zhh_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.borderColor = zhh_borderColor.CGColor;
}

- (ZHHBorderPositionMask)zhh_bordersMask {
    NSNumber *value = objc_getAssociatedObject(self, @selector(zhh_bordersMask));
    // 如果没有设置，返回默认值（所有边）
    return value ? value.unsignedIntegerValue : ZHHBorderPositionAll;
}

- (void)setZhh_bordersMask:(ZHHBorderPositionMask)zhh_bordersMask {
    objc_setAssociatedObject(self, @selector(zhh_bordersMask), @(zhh_bordersMask), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 清除所有边框
    [self removeAllBorders];
    
    // 根据 zhh_bordersMask 设置相应的边框
    if (zhh_bordersMask & ZHHBorderPositionTop) {
        [self addBorderAtPosition:ZHHBorderPositionTop];
    }
    if (zhh_bordersMask & ZHHBorderPositionLeft) {
        [self addBorderAtPosition:ZHHBorderPositionLeft];
    }
    if (zhh_bordersMask & ZHHBorderPositionBottom) {
        [self addBorderAtPosition:ZHHBorderPositionBottom];
    }
    if (zhh_bordersMask & ZHHBorderPositionRight) {
        [self addBorderAtPosition:ZHHBorderPositionRight];
    }
}

- (void)removeAllBorders {
    // 移除所有边框视图
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if ([subView isKindOfClass:[UIView class]]) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)addBorderAtPosition:(ZHHBorderPositionMask)position {
    // 这里可以根据位置创建边框，具体创建视图、设置颜色等
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = self.zhh_borderColor; // 可以根据需要设置不同颜色
    [self addSubview:borderView];
    
    self.layer.borderWidth = 0;
    
    // 添加 Auto Layout 约束或者手动设置 frame
    // 这里以自动布局为例
    borderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (position) {
        case ZHHBorderPositionTop:
            [NSLayoutConstraint activateConstraints:@[
                [borderView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [borderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [borderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [borderView.heightAnchor constraintEqualToConstant:self.zhh_borderWidth]
            ]];
            break;
        case ZHHBorderPositionLeft:
            [NSLayoutConstraint activateConstraints:@[
                [borderView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [borderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                [borderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [borderView.widthAnchor constraintEqualToConstant:self.zhh_borderWidth]
            ]];
            break;
        case ZHHBorderPositionBottom:
            [NSLayoutConstraint activateConstraints:@[
                [borderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                [borderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [borderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [borderView.heightAnchor constraintEqualToConstant:self.zhh_borderWidth]
            ]];
            break;
        case ZHHBorderPositionRight:
            [NSLayoutConstraint activateConstraints:@[
                [borderView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [borderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                [borderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [borderView.widthAnchor constraintEqualToConstant:self.zhh_borderWidth]
            ]];
            break;
        default:
            break;
    }
}

///阴影颜色
- (UIColor *)zhh_shadowColor {
    return objc_getAssociatedObject(self, @selector(zhh_shadowColor));
}

- (void)setZhh_shadowColor:(UIColor *)zhh_shadowColor {
    objc_setAssociatedObject(self, @selector(zhh_shadowColor), zhh_shadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.getStyleLayer.shadowColor = zhh_shadowColor.CGColor;
    self.getStyleLayer.shadowOpacity = 1;
}

- (CGFloat)zhh_shadowRadius {
    return [objc_getAssociatedObject(self, @selector(zhh_shadowRadius)) floatValue];
}

- (void)setZhh_shadowRadius:(CGFloat)zhh_shadowRadius {
    objc_setAssociatedObject(self, @selector(zhh_shadowRadius), @(zhh_shadowRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.getStyleLayer.shadowRadius = zhh_shadowRadius;
}

- (CGSize)zhh_shadowOffset {
    return [objc_getAssociatedObject(self, @selector(zhh_shadowOffset)) CGSizeValue];
}

- (void)setZhh_shadowOffset:(CGSize)zhh_shadowOffset {
    objc_setAssociatedObject(self, @selector(zhh_shadowOffset), [NSValue valueWithCGSize:zhh_shadowOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.getStyleLayer.shadowOffset = zhh_shadowOffset;
}

- (CGFloat)zhh_shadowOpacity {
    return [objc_getAssociatedObject(self, @selector(zhh_shadowOpacity)) floatValue];
}

- (void)setZhh_shadowOpacity:(CGFloat)zhh_shadowOpacity {
    objc_setAssociatedObject(self, @selector(zhh_shadowOpacity), @(zhh_shadowOpacity), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.getStyleLayer.shadowOpacity = zhh_shadowOpacity;
}

/// 获取用于设置阴影的图层（支持 clipsToBounds 与圆角共存）
/// @return 返回 shadowView.layer 或 self.layer
- (CALayer *)getStyleLayer {
    // 如果设置了阴影颜色，且视图裁剪了子视图（或是 UIImageView），使用 shadowView 承载阴影
    if (self.zhh_shadowColor && ([self isKindOfClass:[UIImageView class]] || self.clipsToBounds)) {
        if (!self.shadowView) {
            // 创建 shadowView
            UIView *shadowView = [[UIView alloc] init];
            shadowView.backgroundColor = self.backgroundColor;
            shadowView.userInteractionEnabled = NO;
            shadowView.translatesAutoresizingMaskIntoConstraints = NO;

            // 设置阴影样式（默认为 1）
            shadowView.layer.shadowColor = self.zhh_shadowColor.CGColor;
            shadowView.layer.shadowOpacity = self.layer.shadowOpacity ?: 1.0;
            shadowView.layer.shadowRadius = self.layer.shadowRadius ?: 1.0;
            shadowView.layer.shadowOffset = self.layer.shadowOffset;
            shadowView.layer.cornerRadius = self.zhh_cornerRadius;
            
            self.shadowView = shadowView;
            // 插入到视图下方
            if (self.superview) {
                [self.superview insertSubview:shadowView belowSubview:self];

                // 绑定 AutoLayout 约束，保持与主视图一致
                [NSLayoutConstraint activateConstraints:@[
                    [shadowView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                    [shadowView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                    [shadowView.topAnchor constraintEqualToAnchor:self.topAnchor],
                    [shadowView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
                ]];
            }
        }

        return self.shadowView.layer;
    }

    // 否则使用自身图层
    return self.layer;
}


// 阴影空视图，只在有圆角的时候使用
- (UIView *)shadowView{
    return objc_getAssociatedObject(self, @selector(shadowView));
}

- (void)setShadowView:(UIView *)shadowView{
    objc_setAssociatedObject(self, @selector(shadowView), shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///渐变风格
- (ZHHGradientDirection)zhh_gradientDirection {
    return [objc_getAssociatedObject(self, @selector(zhh_gradientDirection)) integerValue];
}

- (void)setZhh_gradientDirection:(ZHHGradientDirection)zhh_gradientDirection {
    objc_setAssociatedObject(self, @selector(zhh_gradientDirection), @(zhh_gradientDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.zhh_gradientDirection){
        [self drawingGradientLayer];
    }
}

- (NSArray<UIColor *> *)zhh_gradientColors {
    return objc_getAssociatedObject(self, @selector(zhh_gradientColors));
}

- (void)setZhh_gradientColors:(NSArray<UIColor *> *)zhh_gradientColors {
    objc_setAssociatedObject(self, @selector(zhh_gradientColors), zhh_gradientColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawingGradientLayer]; // 设置颜色后重新绘制渐变
}

- (NSArray<NSNumber *> *)zhh_gradientLocations {
    return objc_getAssociatedObject(self, @selector(zhh_gradientLocations));
}

- (void)setZhh_gradientLocations:(NSArray<NSNumber *> *)zhh_gradientLocations {
    objc_setAssociatedObject(self, @selector(zhh_gradientLocations), zhh_gradientLocations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawingGradientLayer]; // 设置位置后刷新渐变层
}

// 渐变图层绘制
- (void)drawingGradientLayer {
    NSArray<UIColor *> *colors = self.zhh_gradientColors;
    ZHHGradientDirection direction = self.zhh_gradientDirection;
    
    if (colors.count >= 2) { // 至少两个颜色才能做渐变
        if (!self.gradientLayer) {
            self.gradientLayer = [CAGradientLayer layer];
            [self.layer insertSublayer:self.gradientLayer below:self.layer];
        }
        
        self.gradientLayer.frame = self.bounds;
        
        // 转换颜色数组为CGColor数组
        NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
        for (UIColor *color in colors) {
            [cgColors addObject:(__bridge id)color.CGColor];
        }
        
        self.gradientLayer.colors = cgColors;
        
        // 渐变位置（optional）
        if (self.zhh_gradientLocations.count == colors.count) {
            self.gradientLayer.locations = self.zhh_gradientLocations;
        } else {
            self.gradientLayer.locations = nil; // 使用默认均匀分布
        }
        
        // 设置渐变方向
        if (direction == ZHHGradientDirectionHorizontal) {
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1.0, 0);
        } else {
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1.0);
        }
        
        // 设置圆角和边框
        self.gradientLayer.cornerRadius = self.zhh_cornerRadius;
        self.gradientLayer.maskedCorners = self.getStyleLayer.maskedCorners;
        self.backgroundColor = [UIColor clearColor];
    }
}

// 渐变空视图，只在有圆角的时候使用
- (CAGradientLayer *)gradientLayer {
    return objc_getAssociatedObject(self, @selector(gradientLayer));
}

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer{
    objc_setAssociatedObject(self, @selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Swizzling 方法实现：Frame / Alpha / Hidden / Layout / 移除

/// 替换 setFrame: 方法，用于更新布局相关状态
- (void)zhh_setFrame:(CGRect)frame {
    [self zhh_setFrame:frame];
    [self refreshLayout];
}

/// 替换 layoutSubviews 方法，用于动态调整样式图层位置
- (void)zhh_layoutSubviews {
    [self zhh_layoutSubviews];
    [self refreshLayout];
}

/// 替换 removeFromSuperview 方法，移除附加图层
- (void)zhh_removeFromSuperview {
    if (self.shadowView) {
        [self.shadowView removeFromSuperview];
    }
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
    [self zhh_removeFromSuperview];
}

/// 替换 setAlpha: 方法，统一更新附加图层的透明度
- (void)zhh_setAlpha:(CGFloat)alpha {
    [self zhh_setAlpha:alpha];

    if (self.shadowView) {
        self.shadowView.alpha = alpha;
    }
    if (self.gradientLayer) {
        self.gradientLayer.opacity = alpha;
    }
}

/// 替换 setHidden: 方法，统一更新附加图层的可见性
- (void)zhh_setHidden:(BOOL)hidden {
    [self zhh_setHidden:hidden];

    if (self.shadowView) {
        self.shadowView.hidden = hidden;
    }
    if (self.gradientLayer) {
        self.gradientLayer.hidden = hidden;
    }
}

#pragma mark - 私有方法：统一刷新附加图层的布局

/// 刷新附加图层的布局位置、大小、圆角半径、阴影路径等
- (void)refreshLayout {
    // 更新 shadowView 大小和位置
    if (self.shadowView.layer) {
        self.shadowView.frame = self.frame;
    }

    // 更新 gradientLayer 大小
    if (self.gradientLayer) {
        self.gradientLayer.frame = self.bounds;
    }

    // 如果没有指定圆角位置，则手动设置阴影路径，提升性能
    if (self.shadowView.layer) {//} && !self.roundTop && !self.roundBottom && !self.roundLeft && !self.roundRight) {

        self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.shadowView.bounds].CGPath;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }

    // 记录当前尺寸，供后续变化时判断是否需要更新样式
    self.lastSize = NSStringFromCGSize(self.frame.size);
}
@end
