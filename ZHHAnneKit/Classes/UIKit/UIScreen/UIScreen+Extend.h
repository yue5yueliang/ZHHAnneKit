//
//  UIScreen+Extend.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/26.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (Extend)
+ (CGSize)zhh_size;
+ (CGSize)zhh_sizeSwap;
+ (CGFloat)zhh_width;
+ (CGFloat)zhh_height;
+ (CGFloat)zhh_scale;
+ (UIEdgeInsets)zhh_safeInsets;
@end

NS_ASSUME_NONNULL_END
