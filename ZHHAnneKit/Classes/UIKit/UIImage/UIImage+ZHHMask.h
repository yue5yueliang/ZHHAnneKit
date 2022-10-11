//
//  UIImage+ZHHMask.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHImageWaterType) {
    ZHHImageWaterTypeTopLeft = 0,
    ZHHImageWaterTypeTopRight,
    ZHHImageWaterTypeBottomLeft,
    ZHHImageWaterTypeBottomRight,
    ZHHImageWaterTypeCenter,
};


@interface UIImage (ZHHMask)

/// 文字水印
/// @param text text content
/// @param direction Watermark position
/// @param color text color
/// @param font text font
/// @param margin display position
/// @return returns the watermarked picture
- (UIImage *)zhh_waterText:(NSString *)text
                direction:(ZHHImageWaterType)direction
                textColor:(UIColor *)color
                     font:(UIFont *)font
                   margin:(CGPoint)margin;

/// 图片水印
/// @param image watermark image
/// @param direction Watermark position
/// @param size watermark size
/// @param margin watermark position
/// @return returns the watermarked picture
- (UIImage *)zhh_waterImage:(UIImage *)image
                 direction:(ZHHImageWaterType)direction
                 waterSize:(CGSize)size
                    margin:(CGPoint)margin;

/// 向图片添加水印
/// @param mark watermark image
/// @param rect watermark position
/// @return returns the watermarked picture
- (UIImage *)zhh_waterMark:(UIImage *)mark InRect:(CGRect)rect;

/// 蒙版图片处理
/// @param maskImage mask image
- (UIImage *)zhh_maskImage:(UIImage *)maskImage;
@end

NS_ASSUME_NONNULL_END
