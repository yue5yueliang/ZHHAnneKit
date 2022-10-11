//
//  UIScreen+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/26.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (ZHHExtend)
+ (CGSize)zhh_size;
/// 交换size
+ (CGSize)zhh_sizeSwap;
+ (CGFloat)zhh_width;
+ (CGFloat)zhh_height;
+ (CGFloat)zhh_scale;
+ (UIEdgeInsets)zhh_safeInsets;
@end

NS_ASSUME_NONNULL_END
