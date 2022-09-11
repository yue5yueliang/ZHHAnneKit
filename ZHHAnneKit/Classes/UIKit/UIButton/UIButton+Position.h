//
//  UIButton+Position.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ZHHKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Position)
@property (nonatomic, copy) NSString *zhh_userid;
- (void)zhh_setButtonImageWithUrl:(NSString *)imageURL;
@end

@interface UIButton (ImagePosition)

typedef NS_ENUM(NSInteger, kImagePosition) {
    /// 图片在左，文字在右，默认
    kImagePositionLeft = 0,
    /// 图片在右，文字在左
    kImagePositionRight = 1,
    /// 图片在上，文字在下
    kImagePositionTop = 2,
    /// 图片在下，文字在上
    kImagePositionBottom = 3,
};
/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)zhh_setButtonTitleWithImageEdgeInsets:(kImagePosition)postion spacing:(CGFloat)spacing;
@end

@interface UIButton (Gradient)
//[self.button3 gradientButtonWithSize:CGSizeMake(300, 44) colorArray:@[(id)RGB(253, 175, 55),(id)RGB(91, 7, 7)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromTopToBottom];
/**
 *  根据给定的颜色，设置按钮的颜色
 *  @param size         这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
 *  @param colorArr     渐变颜色的数组
 *  @param percentArr   渐变颜色的占比数组
 *  @param type         渐变色的类型
 */
- (UIButton *)zhh_gradientButtonWithSize:(CGSize)size colorArr:(NSArray *)colorArr percentArr:(NSArray *)percentArr gradientType:(ZHHGradientType)type;
@end


typedef void(^ZHHButtonBlock)(UIButton * kButton);
IB_DESIGNABLE
@interface UIButton (Block)
/// Add click event, default UIControlEventTouchUpInside
/// 添加点击事件，默认 UIControlEventTouchUpInside
- (void)zhh_addAction:(void(^)(UIButton * kButton))block;

/// Add event, does not support multiple enumeration forms
/// 添加事件，不支持多个枚举表单
- (void)zhh_addAction:(ZHHButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;


@end
NS_ASSUME_NONNULL_END
