//
//  UIImage+ZHHFileName.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHFileName)
/**
 *  @brief  根据main bundle中的文件名读取图片
 *  @param name 图片名
 *  @return 无缓存的图片
 */
+ (UIImage *)zhh_imageWithFileName:(NSString *)name;
/**
 *  根据指定bundle中的文件名读取图片
 *
 *  @param name   图片名
 *  @param bundle bundle
 *  @return 无缓存的图片
 */
+ (UIImage *)zhh_imageWithFileName:(NSString *)name inBundle:(NSBundle*)bundle;
@end

NS_ASSUME_NONNULL_END
