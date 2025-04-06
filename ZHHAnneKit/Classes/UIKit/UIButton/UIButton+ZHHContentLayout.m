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
/// @param postion 图文混排样式
/// @param spacing 图文间距
- (void)zhh_buttonImagePosition:(ZHHUIButtonImagePosition)postion spacing:(CGFloat)spacing {
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    switch (postion) {
        case ZHHUIButtonImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
        case ZHHUIButtonImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
        case ZHHUIButtonImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
        case ZHHUIButtonImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        default:
            break;
    }

    // 触发重新布局
    [self setNeedsLayout];
}

#pragma mark - Associated Properties

/// 获取图文布局样式
- (ZHHUIButtonImagePosition)zhh_postion {
    return [objc_getAssociatedObject(self, @selector(zhh_postion)) integerValue];
}

/// 设置图文布局样式，并重新布局
- (void)setZhh_postion:(ZHHUIButtonImagePosition)zhh_postion {
    objc_setAssociatedObject(self, @selector(zhh_postion), @(zhh_postion), OBJC_ASSOCIATION_ASSIGN);
    [self zhh_buttonImagePosition:zhh_postion spacing:self.zhh_spacing];
}

/// 获取图文间距
- (CGFloat)zhh_spacing {
    return [objc_getAssociatedObject(self, @selector(zhh_spacing)) floatValue];
}

/// 设置图文间距，并重新布局
- (void)setZhh_spacing:(CGFloat)zhh_spacing {
    objc_setAssociatedObject(self, @selector(zhh_spacing), @(zhh_spacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_buttonImagePosition:self.zhh_postion spacing:zhh_spacing];
}

@end
