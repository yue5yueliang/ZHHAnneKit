//
//  UIScreen+Extend.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/26.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIScreen+Extend.h"

@implementation UIScreen (Extend)
+ (CGSize)zhh_size {
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGSize)zhh_sizeSwap {
    return CGSizeMake([self zhh_size].height, [self zhh_size].width);
}

+ (CGFloat)zhh_width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)zhh_height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)zhh_scale {
    return [UIScreen mainScreen].scale;
}

+ (UIEdgeInsets)zhh_safeInsets {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}
@end
