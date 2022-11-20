//
//  UIImage+ZHHGradient.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHGradientType) {
    ZHHGradientFromTopToBottom = 1,            //从上到下
    ZHHGradientFromLeftToRight,                //从左到右
    ZHHGradientFromLeftTopToRightBottom,       //从上到下
    ZHHGradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (ZHHGradient)
/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param colors       渐变颜色的数组
 *  @param percents  渐变颜色的占比数组
 *  @param type           渐变色的类型
 *  @param size           要生成的图片的大小
 */
- (UIImage *)zhh_imageGradientWithColors:(NSArray *)colors
                                percents:(NSArray *)percents
                                    type:(ZHHGradientType)type
                                    size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
