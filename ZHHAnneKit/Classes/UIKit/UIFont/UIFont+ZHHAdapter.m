//
//  UIFont+ZHHAdapter.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIFont+ZHHAdapter.h"

@implementation UIFont (ZHAdapter)
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

+ (UIFont*)zhh_fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize{
    return [UIFont fontWithName:fontName size:[UIFont zhh_fontToSize:fontSize]];
}
@end
