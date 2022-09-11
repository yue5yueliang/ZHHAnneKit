//
//  UIImage+QRCode.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QRCode)
/// 将字符串转换为条形码
/// @param content QR code content
/// @return returns the QR code image
+ (UIImage *)zhh_barCodeImageWithContent:(NSString *)content;

/// 生成二维码
/// @param content QR code content
/// @param size QR code size
/// @return returns the QR code image
+ (UIImage *)zhh_QRCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size;

/// 生成指定颜色的二维码
/// @param content QR code content
/// @param size QR code size
/// @param color QR code color
/// @return returns the QR code image
+ (UIImage *)zhh_QRCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size color:(UIColor *)color;

/// 生成条形码
/// @param content barcode content
/// @param size barcode size
/// @return returns the barcode image
+ (UIImage *)zhh_barcodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size;

/// 生成指定颜色的条形码
/// @param content barcode content
/// @param size barcode size
/// @param color barcode color
/// @return returns the barcode image
+ (UIImage *)zhh_barcodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size color:(UIColor *)color;

/// 异步生成二维码
/// @param codeImage Generate QR code callback
/// @param content QR code content
/// @param size QR code size
extern void kQRCodeImage(void(^codeImage)(UIImage * image), NSString * content, CGFloat size);

/// 异步生成指定的彩色QR码
/// @param codeImage Generate QR code callback
/// @param content QR code content
/// @param size QR code size
/// @param color QR code color
extern void kQRCodeImageFromColor(void(^codeImage)(UIImage * image),
                                  NSString * content,
                                  CGFloat size,
                                  UIColor * color);
@end

NS_ASSUME_NONNULL_END
