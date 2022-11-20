//
//  UIButton+ZHHGradient.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/20.
//

#import "UIButton+ZHHGradient.h"

@implementation UIButton (ZHHGradient)
- (UIButton *)zhh_buttonGradientWithColors:(NSArray *)colors
                                  percents:(NSArray *)percents
                                      type:(ZHHGradientType)type
                                      size:(CGSize)size{
    UIImage *image = [[UIImage alloc] zhh_imageGradientWithColors:colors percents:percents type:type size:size];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    
    return self;
}
@end
