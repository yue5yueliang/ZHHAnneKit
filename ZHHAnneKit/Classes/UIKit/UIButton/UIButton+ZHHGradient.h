//
//  UIButton+ZHHGradient.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/20.
//

#import <UIKit/UIKit.h>
#import "UIImage+ZHHGradient.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZHHGradient)
//[self.button3 zhh_gradientButtonWithColors:@[(id)RGB(253, 175, 55),(id)RGB(91, 7, 7)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromTopToBottom size:CGSizeMake(300, 44)];
/**
 *  根据给定的颜色，设置按钮的颜色
 *  @param colors       渐变颜色的数组
 *  @param percents   渐变颜色的占比数组
 *  @param type             渐变色的类型
 *  @param size         这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
 */
- (UIButton *)zhh_buttonGradientWithColors:(NSArray *)colors
                                  percents:(NSArray *)percents
                                      type:(ZHHGradientType)type
                                      size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
