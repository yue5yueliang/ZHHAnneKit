//
//  UIImage+ZHHURLSize.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHURLSize)
/// 获取网络图片大小
/// @param URL image link
+ (CGSize)zhh_imageSizeWithURL:(NSURL *)URL;

/// 同步获取网络图片大小和信号量
/// @param URL image link
+ (CGSize)zhh_imageAsyncGetSizeWithURL:(NSURL *)URL;
@end

NS_ASSUME_NONNULL_END
