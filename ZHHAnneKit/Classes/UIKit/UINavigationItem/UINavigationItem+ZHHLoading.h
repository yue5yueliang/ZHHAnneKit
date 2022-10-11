//
//  UINavigationItem+ZHHLoading.h
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
    /**
     *  将显示UIActivityIndicatorView代替标题视图
     */
    ZHHNavBarLoaderPositionCenter = 0,
    /**
     *  将显示UIActivityIndicatorView代替左侧项目
     */
    ZHHNavBarLoaderPositionLeft,
    /**
     *  将显示UIActivityIndicatorView代替正确的项目
     */
    ZHHNavBarLoaderPositionRight
};

@interface UINavigationItem (ZHHLoading)
/**
 * 将UIActivityIndicatorView添加到视图层次结构并立即开始设置动画
 *
 *  @param position 向左、居中或向右
 */
- (void)zhh_startAnimatingAt:(ZHHNavBarLoaderPosition)position;

/**
 * 停止动画，从视图层次结构中删除UIActivityIndicatorView并还原项目
 */
- (void)zhh_stopAnimating;
@end

NS_ASSUME_NONNULL_END
