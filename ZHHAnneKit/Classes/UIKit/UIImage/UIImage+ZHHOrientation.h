//
//  UIImage+ZHHOrientation.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHOrientation)
/**
 *  @brief  修正图片的方向
 *  @param srcImg 图片
 *  @return 修正方向后的图片
 */
+ (UIImage *)zhh_fixOrientation:(UIImage *)srcImg;
/**
 *  @brief  旋转图片
 *  @param degrees 角度
 *  @return 旋转后图片
 */
- (UIImage *)zhh_imageRotatedByDegrees:(CGFloat)degrees;
/**
 *  @brief  旋转图片
 *  @param radians 弧度
 *  @return 旋转后图片
 */
- (UIImage *)zhh_imageRotatedByRadians:(CGFloat)radians;
/**
 *  @brief  垂直翻转
 *  @return  翻转后的图片
 */
- (UIImage *)zhh_flipVertical;
/**
 *  @brief  水平翻转
 *  @return 翻转后的图片
 */
- (UIImage *)zhh_flipHorizontal;
/**
 *  @brief  角度转弧度
 *  @param degrees 角度
 *  @return 弧度
 */
+ (CGFloat)zhh_degreesToRadians:(CGFloat)degrees;
/**
 *  @brief  弧度转角度
 *  @param radians 弧度
 *  @return 角度
 */
+ (CGFloat)zhh_radiansToDegrees:(CGFloat)radians;
@end

NS_ASSUME_NONNULL_END
