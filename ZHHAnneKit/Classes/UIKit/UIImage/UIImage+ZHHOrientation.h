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
 *  @brief 修正图片方向
 *
 *  @discussion
 *  部分图片在加载时可能会因为拍摄设备或编辑软件的原因导致方向显示异常。
 *  此方法通过检测图片的 `imageOrientation` 属性，调整图片的方向，生成一张方向正确的图片。
 *
 *  @param srcImg 原始图片
 *  @return 修正方向后的图片
 */
+ (UIImage *)zhh_fixOrientation:(UIImage *)srcImg;

/// @brief 翻转图片
/// 该方法通过图形上下文实现图片的水平或垂直翻转。
/// @param isHorizontal 是否水平翻转。如果为 `YES`，执行水平翻转；否则为垂直翻转。
/// @return 翻转后的图片
- (UIImage *)zhh_flip:(BOOL)isHorizontal;

/// brief 垂直翻转图片
/// 通过调用通用翻转方法，将图片沿水平中线对称翻转。
/// @return 垂直翻转后的图片
- (UIImage *)zhh_flipVertical;

/// @brief 水平翻转图片
/// 通过调用通用翻转方法，将图片沿垂直中线对称翻转。
/// @return 水平翻转后的图片
- (UIImage *)zhh_flipHorizontal;

/// @brief 根据弧度旋转图片
/// @param radians 图片旋转的弧度值（以圆周角表示，弧度 = 度数 * π / 180）
/// @return 旋转后的图片
- (UIImage *)zhh_imageRotatedByRadians:(CGFloat)radians;
/// @brief 根据角度旋转图片
/// @param degrees 图片旋转的角度值（例如 90°、180° 等）
/// @return 旋转后的图片
- (UIImage *)zhh_imageRotatedByDegrees:(CGFloat)degrees;
@end

NS_ASSUME_NONNULL_END
