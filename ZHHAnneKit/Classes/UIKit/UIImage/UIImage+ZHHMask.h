//
//  UIImage+ZHHMask.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义水印位置的枚举
typedef NS_ENUM(NSInteger, ZHHImageWaterType) {
    ZHHImageWaterTypeCenter,       // 水印位置：居中（默认）
    ZHHImageWaterTypeLeftTop,      // 水印位置：左上
    ZHHImageWaterTypeLeftBottom,   // 水印位置：左下
    ZHHImageWaterTypeRightTop,     // 水印位置：右上
    ZHHImageWaterTypeRightBottom   // 水印位置：右下
};


@interface UIImage (ZHHMask)

/// 添加文字水印
/// @param text 需要添加的水印文字
/// @param direction 水印的位置（如左上、右下等）
/// @param color 水印文字的颜色
/// @param font 水印文字的字体
/// @param margin 水印相对位置的边距，单位为点（CGPoint）
/// @return 返回添加了文字水印的图片
- (UIImage *)zhh_addTextWatermark:(NSString *)text direction:(ZHHImageWaterType)direction color:(UIColor *)color font:(UIFont *)font margin:(CGPoint)margin;

/// 添加图片水印
/// @param watermark 要添加的水印图片
/// @param direction 水印的位置（如左上、右下等）
/// @param size 水印图片的大小（如传 CGSizeZero，则默认使用原图大小）
/// @param margin 水印相对位置的边距，单位为点（CGPoint）
/// @return 返回添加了图片水印的图片
- (UIImage *)zhh_addImageWatermark:(UIImage *)watermark direction:(ZHHImageWaterType)direction size:(CGSize)size margin:(CGPoint)margin;

/// 计算水印在图片中的绘制区域
/// @param size 水印内容的大小
/// @param direction 水印的位置（如左上、右下等）
/// @param margin 水印相对位置的边距，单位为点（CGPoint）
/// @return 返回水印需要绘制的 CGRect
- (CGRect)zhh_calculateRectWithSize:(CGSize)size direction:(ZHHImageWaterType)direction margin:(CGPoint)margin;

/// 直接在图片指定区域添加水印图片
/// @param mark 水印图片
/// @param rect 水印图片在目标图片上的绘制区域
/// @return 返回绘制完成的图片
- (UIImage *)zhh_addImageMark:(UIImage *)mark rect:(CGRect)rect;

/// 为图片应用蒙版
/// @param image 蒙版图片，需为黑白图片（黑色部分表示不透明区域，白色部分表示透明区域）
/// @return 返回应用了蒙版效果的新图片
- (UIImage *)zhh_applyMask:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
