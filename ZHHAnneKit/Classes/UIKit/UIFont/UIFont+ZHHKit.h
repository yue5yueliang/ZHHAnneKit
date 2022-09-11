//
//  UIFont+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZHHKit)
/**
 * 根据屏幕适配文字大小 规则: 以6为基础, 设备小一号减一号字体，设备大一号加一号字体
 */
+ (UIFont*)zhh_systemFontOfSizeAdapter:(CGFloat)fontSize;

+ (UIFont *)zhh_fontWithName:(NSString *)fontName sizeAdapter:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
