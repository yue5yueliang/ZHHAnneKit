//
//  UIButton+ZHHContentLayout.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/11.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHContentLayout.h"
#import <objc/runtime.h>

@implementation UIButton (ZHHContentLayout)

/// 设置按钮的图文混排布局
/// @param layoutStyle 图文混排样式
/// @param spacing 图文间距
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle spacing:(CGFloat)spacing {
    // 设置 imageView 的内容模式为适配模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    // 获取图片和文字的实际尺寸
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGSize labelSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGFloat labelWidth = labelSize.width;
    CGFloat labelHeight = labelSize.height;

    // 定义默认的图片和文字内边距
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;

    // 根据布局样式设置图片和文字的偏移量
    switch (layoutStyle) {
        case ZHHButtonContentLayoutStyleNone:
        case ZHHButtonContentLayoutStyleCenterImageLeft:
            // 图片在左，文字在右，居中对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2, 0, spacing / 2);
            titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, -spacing / 2);
            break;

        case ZHHButtonContentLayoutStyleCenterImageRight:
            // 图片在右，文字在左，居中对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing / 2, 0, -(labelWidth + spacing / 2));
            titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing / 2), 0, imageWidth + spacing / 2);
            break;

        case ZHHButtonContentLayoutStyleCenterImageTop:
            // 图片在上，文字在下，居中对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight / 2 - spacing / 2, 0, labelHeight / 2 + spacing / 2, -labelWidth);
            titleEdgeInsets = UIEdgeInsetsMake(imageHeight / 2 + spacing / 2, -imageWidth, -imageHeight / 2 - spacing / 2, 0);
            break;

        case ZHHButtonContentLayoutStyleCenterImageBottom:
            // 图片在下，文字在上，居中对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            imageEdgeInsets = UIEdgeInsetsMake(labelHeight / 2 + spacing / 2, 0, -labelHeight / 2 - spacing / 2, -labelWidth);
            titleEdgeInsets = UIEdgeInsetsMake(-imageHeight / 2 - spacing / 2, -imageWidth, imageHeight / 2 + spacing / 2, 0);
            break;

        case ZHHButtonContentLayoutStyleLeftImageLeft:
            // 图片在左，文字在右，整体左对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, -spacing);
            break;

        case ZHHButtonContentLayoutStyleLeftImageRight:
            // 图片在右，文字在左，整体左对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing, 0, -(labelWidth + spacing));
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth + spacing);
            break;

        case ZHHButtonContentLayoutStyleRightImageLeft:
            // 图片在左，文字在右，整体右对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;

        case ZHHButtonContentLayoutStyleRightImageRight:
            // 图片在右，文字在左，整体右对齐
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -labelWidth);
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageWidth + spacing);
            break;

        default:
            break;
    }

    // 设置图片和文字的内边距
    self.imageEdgeInsets = imageEdgeInsets;
    self.titleEdgeInsets = titleEdgeInsets;

    // 触发重新布局
    [self setNeedsLayout];
}

#pragma mark - Associated Properties

/// 获取图文布局样式
- (ZHHButtonContentLayoutStyle)zhh_layoutType {
    return [objc_getAssociatedObject(self, @selector(zhh_layoutType)) integerValue];
}

/// 设置图文布局样式，并重新布局
- (void)setZhh_layoutType:(ZHHButtonContentLayoutStyle)zhh_layoutType {
    objc_setAssociatedObject(self, @selector(zhh_layoutType), @(zhh_layoutType), OBJC_ASSOCIATION_ASSIGN);
    [self zhh_contentLayout:zhh_layoutType spacing:self.zhh_spacing];
}

/// 获取图文间距
- (CGFloat)zhh_spacing {
    return [objc_getAssociatedObject(self, @selector(zhh_spacing)) floatValue];
}

/// 设置图文间距，并重新布局
- (void)setZhh_spacing:(CGFloat)zhh_spacing {
    objc_setAssociatedObject(self, @selector(zhh_spacing), @(zhh_spacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_contentLayout:self.zhh_layoutType spacing:zhh_spacing];
}

@end
