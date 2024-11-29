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
/// @param padding 图文间距
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle padding:(CGFloat)padding {
    [self zhh_contentLayout:layoutStyle padding:padding periphery:5];
}

/// 设置按钮的图文混排布局
/// @param layoutStyle 图文混排样式
/// @param padding 图文间距
/// @param periphery 图文边界间距
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle padding:(CGFloat)padding periphery:(CGFloat)periphery {
    // 设置 imageView 的内容模式为适配模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    // 获取图片和文字的实际尺寸
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;

    // 定义默认的图片和文字内边距
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;

    // 根据布局样式设置图片和文字的偏移量
    switch (layoutStyle) {
        case ZHHButtonContentLayoutStyleNormal:
            // 图片在左，文字在右，居中对齐
            titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, 0);
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, padding);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;

        case ZHHButtonContentLayoutStyleCenterImageRight:
            // 图片在右，文字在左，居中对齐
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - padding, 0, imageWidth);
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + padding, 0, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;

        case ZHHButtonContentLayoutStyleCenterImageTop:
            // 图片在上，文字在下，居中对齐
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight - padding, 0);
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - padding, 0, 0, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;

        case ZHHButtonContentLayoutStyleCenterImageBottom:
            // 图片在下，文字在上，居中对齐
            titleEdgeInsets = UIEdgeInsetsMake(-imageHeight - padding, -imageWidth, 0, 0);
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - padding, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;

        case ZHHButtonContentLayoutStyleLeftImageLeft:
            // 图片在左，文字在右，整体左对齐
            titleEdgeInsets = UIEdgeInsetsMake(0, padding + periphery, 0, 0);
            imageEdgeInsets = UIEdgeInsetsMake(0, periphery, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;

        case ZHHButtonContentLayoutStyleLeftImageRight:
            // 图片在右，文字在左，整体左对齐
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth + periphery, 0, 0);
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + padding + periphery, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;

        case ZHHButtonContentLayoutStyleRightImageLeft:
            // 图片在左，文字在右，整体右对齐
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, padding + periphery);
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, periphery);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;

        case ZHHButtonContentLayoutStyleRightImageRight:
            // 图片在右，文字在左，整体右对齐
            titleEdgeInsets = UIEdgeInsetsMake(0, -self.frame.size.width / 2, 0, imageWidth + padding + periphery);
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -labelWidth + periphery);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;

        default:
            break;
    }

    // 设置图片和文字的内边距
    self.imageEdgeInsets = imageEdgeInsets;
    self.titleEdgeInsets = titleEdgeInsets;

    // 触发重新布局
    [self setNeedsDisplay];
}

#pragma mark - Associated Properties

/// 获取图文布局样式
- (ZHHButtonContentLayoutStyle)zhh_layoutType {
    return [objc_getAssociatedObject(self, @selector(zhh_layoutType)) integerValue];
}

/// 设置图文布局样式，并重新布局
- (void)setZhh_layoutType:(ZHHButtonContentLayoutStyle)zhh_layoutType {
    objc_setAssociatedObject(self, @selector(zhh_layoutType), @(zhh_layoutType), OBJC_ASSOCIATION_ASSIGN);
    [self zhh_contentLayout:zhh_layoutType padding:self.zhh_padding periphery:self.zhh_periphery];
}

/// 获取图文间距
- (CGFloat)zhh_padding {
    return [objc_getAssociatedObject(self, @selector(zhh_padding)) floatValue];
}

/// 设置图文间距，并重新布局
- (void)setZhh_padding:(CGFloat)zhh_padding {
    objc_setAssociatedObject(self, @selector(zhh_padding), @(zhh_padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_contentLayout:self.zhh_layoutType padding:zhh_padding periphery:self.zhh_periphery];
}

/// 获取图文边界间距
- (CGFloat)zhh_periphery {
    return [objc_getAssociatedObject(self, @selector(zhh_periphery)) floatValue];
}

/// 设置图文边界间距，并重新布局
- (void)setZhh_periphery:(CGFloat)zhh_periphery {
    objc_setAssociatedObject(self, @selector(zhh_periphery), @(zhh_periphery), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_contentLayout:self.zhh_layoutType padding:self.zhh_padding periphery:zhh_periphery];
}
@end
