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
/**
 *  压缩上传图片到指定字节
 *
 *  @param image     压缩的图片
 *  @param maxLength 压缩后最大字节大小
 *
 *  @return 压缩后图片的二进制
 */
+ (NSData *)zhh_compressImage:(UIImage *)image toMaxLength:(NSInteger) maxLength maxWidth:(NSInteger)maxWidth;

/**
 *  获得指定size的图片
 *
 *  @param image   原始图片
 *  @param newSize 指定的size
 *
 *  @return 调整后的图片
 */
+ (UIImage *)zhh_resizeImage:(UIImage *) image withNewSize:(CGSize) newSize;

/**
 *  通过指定图片最长边，获得等比例的图片size
 *
 *  @param image       原始图片
 *  @param imageLength 图片允许的最长宽度（高度）
 *
 *  @return 获得等比例的size
 */
+ (CGSize)zhh_scaleImage:(UIImage *) image withLength:(CGFloat) imageLength;


+ (UIImage*)zhh_resizableHalfImage:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
