//
//  UIImage+ZHHCompress.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  对UIImage 进行扩展，对上传图片进行压缩
 *  //512kb   2014px
 *  //usage   [UIImage compressImage:image toMaxLength:512*1024 maxWidth:1024];
 */
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (ZHHCompress)

/// 压缩图片到指定大小和最大宽度
/// @param image 原始图片
/// @param maxLength 目标文件大小（字节）
/// @param maxWidth 最大宽度（px）
/// @return 压缩后的图片数据
+ (NSData *)zhh_compressImage:(UIImage *)image toMaxLength:(NSInteger)maxLength maxWidth:(NSInteger)maxWidth;

/// 调整图片大小
/// @param image 原始图片
/// @param newSize 新的目标尺寸
/// @return 调整大小后的图片
+ (UIImage *)zhh_resizedImage:(UIImage *)image toSize:(CGSize)newSize;

/// 计算按比例缩放的目标尺寸
/// @param image 原始图片
/// @param maxLength 最大边长
/// @return 按比例缩放后的尺寸
+ (CGSize)zhh_scaledSizeForImage:(UIImage *)image withMaxLength:(CGFloat)maxLength;

@end

NS_ASSUME_NONNULL_END
