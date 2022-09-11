//
//  UIFont+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIFont+ZHHKit.h"

@implementation UIFont (ZHHKit)
/**
 *  根据不同的设置返回不同的字体
 */
+ (CGFloat)zhh_fontToSize:(CGFloat)fontSize{
    float widthR = [UIScreen mainScreen].bounds.size.width/375.0;
    float tempFontSize = fontSize;
    widthR > 1 ? (tempFontSize+=1) : (tempFontSize-=1);
    return tempFontSize;
}

+ (UIFont*)zhh_systemFontOfSizeAdapter:(CGFloat)fontSize{
    return [UIFont systemFontOfSize:[UIFont zhh_fontToSize:fontSize]];
}

+ (UIFont*)zhh_fontWithName:(NSString *)fontName sizeAdapter:(CGFloat)fontSize{
    return [UIFont fontWithName:fontName size:[UIFont zhh_fontToSize:fontSize]];
}
@end
