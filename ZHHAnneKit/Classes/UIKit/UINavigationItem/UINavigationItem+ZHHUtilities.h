//
//  UINavigationItem+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  在导航栏中显示UIActivityIndicatorView的位置
 */
typedef NS_ENUM(NSUInteger, ZHHNavBarLoaderPosition){
    // 加载器显示在左侧
    ZHHNavBarLoaderPositionLeft,
    // 加载器显示在标题中间
    ZHHNavBarLoaderPositionCenter,
    // 加载器显示在右侧
    ZHHNavBarLoaderPositionRight
};

@interface UINavigationItem (ZHHUtilities)

/// 开始在指定位置显示加载动画
/// @param position 加载动画显示的位置
- (void)zhh_startLoadingAnimationAtPosition:(ZHHNavBarLoaderPosition)position indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

/// 停止加载动画并恢复原来视图
- (void)zhh_stopLoadingAnimation;
@end

NS_ASSUME_NONNULL_END
