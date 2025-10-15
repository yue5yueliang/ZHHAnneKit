//
//  UIBarButtonItem+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/8.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIBarButtonItem+ZHHUtilities.h"
#import "UIColor+ZHHUtilities.h"
#import "UIView+ZHHFrame.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (ZHHUtilities)

#pragma mark - Block 关联处理

/// 触发 block 回调
- (void)zhh_performActionBlock {
    if (self.zhh_actionBlock) {
        self.zhh_actionBlock();
    }
}

/// 获取 block
- (ZHHBarButtonActionBlock)zhh_actionBlock {
    return objc_getAssociatedObject(self, @selector(zhh_actionBlock));
}

/// 设置 block 并绑定 target/action
- (void)setZhh_actionBlock:(ZHHBarButtonActionBlock)actionBlock {
    if (actionBlock != self.zhh_actionBlock) {
        objc_setAssociatedObject(self, @selector(zhh_actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setTarget:self];
        [self setAction:@selector(zhh_performActionBlock)];
    }
}

#pragma mark - 创建带图片按钮项

/// 创建普通状态 & 可选高亮状态的 UIBarButtonItem
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName
                             highImageName:(NSString *)highImageName
                                    target:(id)target
                                    action:(SEL)action {
    if (!imageName) return nil;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:imageName];
    [button setImage:normalImage forState:UIControlStateNormal];

    if (highImageName) {
        UIImage *highlightedImage = [UIImage imageNamed:highImageName];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }

    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/// 创建普通图片的 UIBarButtonItem（无高亮）
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action {
    return [self zhh_itemWithImageName:imageName highImageName:nil target:target action:action];
}

#pragma mark - 系统风格按钮项（文字/图片）

/// 创建系统文字或图片类型 UIBarButtonItem
+ (UIBarButtonItem *)zhh_systemItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                                    textType:(BOOL)textType {

    if (textType) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];

        UIColor *color = titleColor ?: [UIColor zhh_colorWithHex:0x181818];
        UIFont *font = [UIFont systemFontOfSize:15.f];
        NSDictionary *normalAttrs = @{ NSForegroundColorAttributeName: color, NSFontAttributeName: font };
        NSDictionary *disabledAttrs = @{ NSForegroundColorAttributeName: [color colorWithAlphaComponent:0.5], NSFontAttributeName: font };

        [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [item setTitleTextAttributes:disabledAttrs forState:UIControlStateHighlighted];
        [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];

        return item;
    } else {
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:selector];
    }
}

#pragma mark - 自定义按钮项

/// 创建带自定义标题/图片的 UIBarButtonItem
+ (UIBarButtonItem *)zhh_customItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment {
    
    UIButton *button = [[UIButton alloc] init];
    button.contentHorizontalAlignment = alignment;

    // 设置标题
    if (title.length > 0) {
        UIColor *color = titleColor ?: UIColor.whiteColor;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:[color colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [button setTitleColor:[color colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    }

    // 设置图片
    if (imageName.length > 0) {
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:image forState:UIControlStateNormal];
    }

    // 调整尺寸（最小点击范围 44x44）
    [button sizeToFit];
    if (button.bounds.size.width < 44) {
        button.zhh_size = CGSizeMake(44, 44);
    }

    if (target && selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 返回按钮项

/// 创建返回样式的 UIBarButtonItem（支持文字+图标）
+ (UIBarButtonItem *)zhh_backItemWithTitle:(NSString *)title
                                 imageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action {
    return [self zhh_customItemWithTitle:title
                              titleColor:nil
                               imageName:imageName
                                  target:target
                                selector:action
              contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}
@end
