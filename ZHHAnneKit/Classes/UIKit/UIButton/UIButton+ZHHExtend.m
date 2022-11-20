//
//  UIButton+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHExtend.h"
#import <objc/runtime.h>

static char * const ZHHIdentifier = "zhh_identifier";

@implementation UIButton (ZHHExtend)

- (NSObject *)zhh_identifier {
    return objc_getAssociatedObject(self, &ZHHIdentifier);
}

- (void)setZhh_identifier:(NSString *)zhh_identifier{
    objc_setAssociatedObject(self, &ZHHIdentifier, zhh_identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark --- 创建默认按钮--有标题、字体、颜色
+ (instancetype)zhh_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

@end
