//
//  UINavigationBar+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UINavigationBar+ZHHUtilities.h"
#import <objc/runtime.h>

static char zhh_enableScrollEdgeAppearanceKey;
static char zhh_translucentKey;
static char zhh_transparentKey;
static char zhh_hideBottomLineKey;
static char zhh_titleFontKey;
static char zhh_titleColorKey;
static char zhh_backgroundColorKey;
static char zhh_tintColorKey;


@implementation UINavigationBar (ZHHUtilities)

// 根据阴影类型应用预设阴影效果
- (void)zhh_navigationBarShadowWithType:(ZHHNavigationBarShadowType)shadowType {
    switch (shadowType) {
        case ZHHNavigationBarShadowTypeLight:
            // 轻微阴影：偏移 2，透明度 0.25，半径 4.0
            [self zhh_navigationBarCustomShadowOffset:2 shadowOpacity:0.25 shadowRadius:4.0];
            break;
            
        case ZHHNavigationBarShadowTypeMedium:
            // 强烈阴影：偏移 4，透明度 0.3，半径 6.0
            [self zhh_navigationBarCustomShadowOffset:4 shadowOpacity:0.3 shadowRadius:6.0];
            break;
            
        case ZHHNavigationBarShadowTypeHeavy:
            // 自定义阴影：偏移 5，透明度 0.35，半径 8.0
            [self zhh_navigationBarCustomShadowOffset:5 shadowOpacity:0.35 shadowRadius:8.0];
            break;
            
        default:
            break;
    }
}

// 轻微阴影效果的具体实现，使用默认值调用通用设置方法
- (void)zhh_navigationBarCustomShadowOffset:(CGFloat)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius {
    // 调用更加通用的设置阴影的函数，传递默认的阴影颜色
    [self zhh_navigationBarCustomShadowColor:[UIColor.blackColor colorWithAlphaComponent:0.2] shadowOffset:shadowOffset shadowOpacity:shadowOpacity shadowRadius:shadowRadius];
}

// 开发者自定义阴影设置
- (void)zhh_navigationBarCustomShadowColor:(UIColor *)shadowColor shadowOffset:(CGFloat)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius {
    // 设置阴影颜色
    self.layer.shadowColor = shadowColor.CGColor;
    // 设置阴影偏移量
    self.layer.shadowOffset = CGSizeMake(0, shadowOffset); // 向下偏移
    // 设置阴影透明度
    self.layer.shadowOpacity = shadowOpacity; // 阴影透明度
    // 设置阴影的模糊半径
    self.layer.shadowRadius = shadowRadius; // 半径
    // 设置阴影路径，优化性能
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

// 较强的底部阴影效果
- (void)zhh_applyStrongShadow {
    self.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.4].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4); // 向下偏移 4px
    self.layer.shadowOpacity = 0.3; // 阴影透明度 0.3
    self.layer.shadowRadius = 6.0; // 半径 6px
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

// 自定义品牌色阴影效果
- (void)zhh_applyCustomShadow {
    self.layer.shadowColor = [UIColor colorWithRed:0.12 green:0.34 blue:0.56 alpha:0.3].CGColor; // 使用品牌色
    self.layer.shadowOffset = CGSizeMake(0, 5); // 向下偏移 5px
    self.layer.shadowOpacity = 0.35; // 阴影透明度 0.35
    self.layer.shadowRadius = 8.0; // 半径 8px
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

// 重置导航栏的默认配置
- (void)zhh_resetConfiguration {
    // 设置默认值
    self.zhh_enableScrollEdgeAppearance = YES; // 导航栏是否启用滚动边缘外观，默认为 YES
    self.zhh_translucent = YES; // 是否半透明，默认为 YES
    self.zhh_transparent = NO; // 是否完全透明，默认为 NO
    self.zhh_hideBottomLine = NO; // 是否隐藏底部线条，默认为 NO
    self.zhh_titleFont = [UIFont boldSystemFontOfSize:18.f]; // 设置标题字体，默认为 18 号加粗字体
    self.zhh_titleColor = [UIColor blackColor]; // 设置标题字体颜色，默认为黑色
    self.zhh_backgroundColor = UIColor.clearColor; // 设置导航栏背景色，默认为透明
    self.zhh_tintColor = [UIColor blueColor]; // 设置导航栏按钮的主题色，默认为蓝色
    
    // 调用配置方法应用默认配置
    [self zhh_configuration];
}

// 通过回调配置导航栏
- (void)zhh_configureWithBlock:(void (^)(UINavigationBar *bar))configurationBlock {
    // 在配置前先重置为默认值
    [self zhh_resetConfiguration];
    
    // 如果回调不为空，则执行回调，允许自定义配置
    if (configurationBlock) {
        configurationBlock(self);
    }
    
    // 配置完成后调用更新方法，应用新的配置
    [self zhh_configuration];
}

// 应用导航栏的配置
- (void)zhh_configuration {
    // 创建标题的文本属性字典
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    
    // 如果标题字体存在，则添加到字典中
    if (self.zhh_titleFont) {
        titleTextAttributes[NSFontAttributeName] = self.zhh_titleFont;
    }
    
    // 如果标题字体颜色存在，则添加到字典中
    if (self.zhh_titleColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = self.zhh_titleColor;
    }
    
    // 设置导航栏的半透明属性
    self.translucent = self.zhh_translucent;
    // 设置导航栏的背景颜色
    self.barTintColor = self.zhh_backgroundColor;
    // 设置导航栏标题的属性
    self.titleTextAttributes = titleTextAttributes;
    // 如果 iOS 13 或更高版本，使用新的 `UINavigationBarAppearance` 进行配置
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        // 如果设置了全透明，配置透明背景
        if (self.zhh_transparent) {
            [appearance configureWithTransparentBackground];
        } else {
            // 否则配置为默认背景
            [appearance configureWithDefaultBackground];
        }
        
        // 设置导航栏的背景色和标题属性
        appearance.backgroundColor = self.zhh_backgroundColor;
        appearance.titleTextAttributes = titleTextAttributes;
        
        // 如果需要隐藏底部线条，设置阴影为透明
        if (self.zhh_hideBottomLine) {
            appearance.shadowImage = [UIImage new];
            appearance.shadowColor = [UIColor clearColor];
        }
        
        // 应用标准外观
        self.standardAppearance = appearance;
        // 如果启用了滚动边缘外观，设置滚动边缘外观
        self.scrollEdgeAppearance = self.zhh_enableScrollEdgeAppearance ? appearance : nil;
    }
}

#pragma mark - Getters | Setters

- (void)setZhh_enableScrollEdgeAppearance:(BOOL)zhh_enableScrollEdgeAppearance {
    objc_setAssociatedObject(self, &zhh_enableScrollEdgeAppearanceKey, @(zhh_enableScrollEdgeAppearance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhh_enableScrollEdgeAppearance {
    return [objc_getAssociatedObject(self, &zhh_enableScrollEdgeAppearanceKey) boolValue];
}

- (void)setZhh_translucent:(BOOL)zhh_translucent {
    objc_setAssociatedObject(self, &zhh_translucentKey, @(zhh_translucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhh_translucent {
    return [objc_getAssociatedObject(self, &zhh_translucentKey) boolValue];
}

- (void)setZhh_transparent:(BOOL)zhh_transparent {
    objc_setAssociatedObject(self, &zhh_transparentKey, @(zhh_transparent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhh_transparent {
    return [objc_getAssociatedObject(self, &zhh_transparentKey) boolValue];
}

- (void)setZhh_hideBottomLine:(BOOL)zhh_hideBottomLine {
    objc_setAssociatedObject(self, &zhh_hideBottomLineKey, @(zhh_hideBottomLine), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhh_hideBottomLine {
    return [objc_getAssociatedObject(self, &zhh_hideBottomLineKey) boolValue];
}

- (void)setZhh_titleFont:(UIFont *)zhh_titleFont {
    objc_setAssociatedObject(self, &zhh_titleFontKey, zhh_titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)zhh_titleFont {
    return objc_getAssociatedObject(self, &zhh_titleFontKey);
}

- (void)setZhh_titleColor:(UIColor *)zhh_titleColor {
    objc_setAssociatedObject(self, &zhh_titleColorKey, zhh_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zhh_titleColor {
    return objc_getAssociatedObject(self, &zhh_titleColorKey);
}

- (void)setZhh_backgroundColor:(UIColor *)zhh_backgroundColor {
    objc_setAssociatedObject(self, &zhh_backgroundColorKey, zhh_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zhh_backgroundColor {
    return objc_getAssociatedObject(self, &zhh_backgroundColorKey);
}

- (void)setZhh_tintColor:(UIColor *)zhh_tintColor {
    objc_setAssociatedObject(self, &zhh_tintColorKey, zhh_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zhh_tintColor {
    return objc_getAssociatedObject(self, &zhh_tintColorKey);
}
@end
