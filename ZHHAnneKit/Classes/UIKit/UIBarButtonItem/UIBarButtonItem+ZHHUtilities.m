//
//  UIBarButtonItem+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIBarButtonItem+ZHHUtilities.h"
#import <ZHHAnneKit/UIColor+ZHHUtilities.h>
#import <ZHHAnneKit/UIView+ZHHFrame.h>
#import <objc/runtime.h>

@implementation UIBarButtonItem (ZHHUtilities)

// 执行关联的 block
- (void)zhh_performActionBlock {
    if (self.zhh_actionBlock) {
        self.zhh_actionBlock();
    }
}

// 动态获取关联的 block
- (ZHHBarButtonActionBlock)zhh_actionBlock {
    return objc_getAssociatedObject(self, @selector(zhh_actionBlock));
}

// 动态设置关联的 block
- (void)setZhh_actionBlock:(ZHHBarButtonActionBlock)actionBlock {
    if (actionBlock != self.zhh_actionBlock) {
        // 设置关联对象
        objc_setAssociatedObject(self, @selector(zhh_actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

        // 配置 target 和 action
        [self setTarget:self];
        [self setAction:@selector(zhh_performActionBlock)];
    }
}

+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *_Nullable)imageName highImageName:(NSString *_Nullable)highImageName target:(id)target action:(SEL)action {
    // 防御性编程：检查 imageName 是否为空
    if (imageName == nil) {
        return nil;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    // 设置按钮图片
    UIImage *normalImage = [UIImage imageNamed:imageName];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    if (highImageName) {
        UIImage *highlightedImage = [UIImage imageNamed:highImageName];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    // 根据图片大小调整按钮尺寸，确保内容适配
    CGSize imageSize = normalImage.size;
    button.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    button.frame = CGRectMake(0, 0, 44, 44);
    
    // 添加事件监听
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 创建 UIBarButtonItem
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [UIBarButtonItem zhh_itemWithImageName:imageName highImageName:nil target:target action:action];
}

+ (UIBarButtonItem *)zhh_systemItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName target:(id)target selector:(SEL)selector textType:(BOOL)textType {
    
    UIBarButtonItem *item;
    if (textType) {
        // 创建文字类型的 UIBarButtonItem
        item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
        
        // 设置默认文字颜色和字体
        UIColor *defaultTitleColor = titleColor ?: [UIColor zhh_colorWithHex:0x181818];
        UIFont *defaultFont = [UIFont systemFontOfSize:15.f];
        
        // 普通状态文字属性
        NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
        normalAttributes[NSForegroundColorAttributeName] = defaultTitleColor;
        normalAttributes[NSFontAttributeName] = defaultFont;
        [item setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        
        // 高亮状态文字属性
        NSMutableDictionary *highlightedAttributes = [normalAttributes mutableCopy];
        highlightedAttributes[NSForegroundColorAttributeName] = [defaultTitleColor colorWithAlphaComponent:0.5f];
        [item setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
        
        // 禁用状态文字属性
        NSMutableDictionary *disabledAttributes = [normalAttributes mutableCopy];
        disabledAttributes[NSForegroundColorAttributeName] = [defaultTitleColor colorWithAlphaComponent:0.5f];
        [item setTitleTextAttributes:disabledAttributes forState:UIControlStateDisabled];
        
    } else {
        // 创建图片类型的 UIBarButtonItem
        UIImage *originalImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item = [[UIBarButtonItem alloc] initWithImage:originalImage style:UIBarButtonItemStylePlain target:target action:selector];
    }
    
    return item;
}

+ (UIBarButtonItem *)zhh_customItemWithTitle:(NSString *_Nullable)title
                                  titleColor:(UIColor *_Nullable)titleColor
                                   imageName:(NSString *_Nullable)imageName
                                      target:(id _Nullable)target
                                    selector:(SEL _Nullable)selector
                  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment {
    // 创建 UIButton
    UIButton *button = [[UIButton alloc] init];
    
    // 设置默认的标题颜色（白色）和字体
    UIColor *defaultTitleColor = titleColor ?: [UIColor whiteColor];
    UIFont *defaultFont = [UIFont systemFontOfSize:15.f];
    
    // 设置标题
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:defaultFont];
        [button setTitleColor:defaultTitleColor forState:UIControlStateNormal];
        [button setTitleColor:[defaultTitleColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        [button setTitleColor:[defaultTitleColor colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
    }
    
    // 设置图片
    if (imageName.length > 0) {
        UIImage *originalImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:originalImage forState:UIControlStateNormal];
    }
    
    // 调整按钮尺寸
    [button sizeToFit];
    if (button.bounds.size.width < 44) {
        button.zhh_size = CGSizeMake(44, 44); // 设置最小点击区域
    }
    
    // 设置内容水平对齐方式
    button.contentHorizontalAlignment = contentHorizontalAlignment;
    
    // 添加点击事件
    if (target && selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 返回自定义的 UIBarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/// 返回按钮 带箭头的
+ (UIBarButtonItem *)zhh_backItemWithTitle:(NSString *_Nullable)title imageName:(NSString *_Nullable)imageName target:(id _Nullable)target action:(SEL _Nullable)action {
    return [self zhh_customItemWithTitle:title titleColor:nil imageName:imageName target:target selector:action contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}
@end
