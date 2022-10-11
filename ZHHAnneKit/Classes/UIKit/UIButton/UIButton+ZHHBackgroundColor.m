//
//  UIButton+ZHHBackgroundColor.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHBackgroundColor.h"
#import "UIImage+ZHHColor.h"

@implementation UIButton (ZHHBackgroundColor)
/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)zhh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage zhh_imageWithColor:backgroundColor] forState:state];
}

@end
