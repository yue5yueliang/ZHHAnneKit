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
/// @param position 图文混排样式
/// @param spacing 图文间距
- (void)zhh_buttonImagePosition:(ZHHUIButtonImagePosition)position spacing:(CGFloat)spacing {
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];

    // 获取图片和文字的尺寸
    CGSize imageSize = self.imageView.image.size;
    UIFont *font = self.titleLabel.font;
    NSString *text = self.titleLabel.text ?: @"";
    CGSize labelSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: font}
                                           context:nil].size;

    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    CGFloat labelWidth = ceil(labelSize.width);
    CGFloat labelHeight = ceil(labelSize.height);

    // 重置边距
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = UIEdgeInsetsZero;

    switch (position) {
        case ZHHUIButtonImagePositionLeft: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2, 0, spacing / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, -spacing / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, spacing / 2);
            break;
        }
        case ZHHUIButtonImagePositionRight: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing / 2, 0, -(labelWidth + spacing / 2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing / 2), 0, imageWidth + spacing / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, spacing / 2);
            break;
        }
        case ZHHUIButtonImagePositionTop: {
            self.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight / 2 - spacing / 2, labelWidth / 2, labelHeight / 2 + spacing / 2, -labelWidth / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight / 2 + spacing / 2, -imageWidth / 2, -imageHeight / 2 - spacing / 2, imageWidth / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(labelHeight / 2 + spacing / 2, -spacing / 2, imageHeight / 2 + spacing / 2, -spacing / 2);
            break;
        }
        case ZHHUIButtonImagePositionBottom: {
            self.imageEdgeInsets = UIEdgeInsetsMake(labelHeight / 2 + spacing / 2, labelWidth / 2, -labelHeight / 2 - spacing / 2, -labelWidth / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(-imageHeight / 2 - spacing / 2, -imageWidth / 2, imageHeight / 2 + spacing / 2, imageWidth / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageHeight / 2 + spacing / 2, -spacing / 2, labelHeight / 2 + spacing / 2, -spacing / 2);
            break;
        }
        default:
            break;
    }

    [self setNeedsLayout];
}

#pragma mark - Associated Properties

/// 获取图文布局样式
- (ZHHUIButtonImagePosition)zhh_position {
    return [objc_getAssociatedObject(self, @selector(zhh_position)) integerValue];
}

/// 设置图文布局样式，并重新布局
- (void)setZhh_position:(ZHHUIButtonImagePosition)zhh_position {
    objc_setAssociatedObject(self, @selector(zhh_position), @(zhh_position), OBJC_ASSOCIATION_ASSIGN);
    [self zhh_buttonImagePosition:zhh_position spacing:self.zhh_spacing];
}

/// 获取图文间距
- (CGFloat)zhh_spacing {
    return [objc_getAssociatedObject(self, @selector(zhh_spacing)) floatValue];
}

/// 设置图文间距，并重新布局
- (void)setZhh_spacing:(CGFloat)zhh_spacing {
    objc_setAssociatedObject(self, @selector(zhh_spacing), @(zhh_spacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_buttonImagePosition:self.zhh_position spacing:zhh_spacing];
}

@end
