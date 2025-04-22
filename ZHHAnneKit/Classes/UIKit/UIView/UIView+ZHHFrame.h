//
//  UIView+ZHHFrame.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHFrame)
/*----------------------
 * Absolute coordinate *
 ----------------------*/
@property (nonatomic, assign) CGFloat zhh_x;            ///< X位置
@property (nonatomic, assign) CGFloat zhh_y;            ///< Y位置
@property (nonatomic, assign) CGFloat zhh_width;        ///< 宽度
@property (nonatomic, assign) CGFloat zhh_height;       ///< 高度

@property (nonatomic, assign, readonly) CGFloat zhh_maxX;    ///< 最大X值
@property (nonatomic, assign, readonly) CGFloat zhh_maxY;    // 最大Y值

@property (nonatomic, assign) CGSize zhh_size;           ///< 尺寸
@property (nonatomic, assign) CGPoint zhh_origin;        ///< 原点
@property (nonatomic, assign) CGFloat zhh_originX;       ///< X原点
@property (nonatomic, assign) CGFloat zhh_originY;       ///< Y原点
@property (nonatomic, assign) CGFloat zhh_centerX;       ///< X中心点
@property (nonatomic, assign) CGFloat zhh_centerY;       ///< Y中心点

@property (nonatomic, assign) CGFloat zhh_top;           ///< 上边距
@property (nonatomic, assign) CGFloat zhh_bottom;        ///< 下边距
@property (nonatomic, assign) CGFloat zhh_left;          ///< 左边距
@property (nonatomic, assign) CGFloat zhh_right;         ///< 右边距

@property (nonatomic, assign) CGPoint zhh_viewOrigin;    ///< 视图原点
@property (nonatomic, assign) CGSize zhh_viewSize;       ///< 视图尺寸

/*----------------------
 * Relative coordinate *
 ----------------------*/
@property (nonatomic, readonly) CGFloat zhh_middleX;     ///< 水平中心
@property (nonatomic, readonly) CGFloat zhh_middleY;     ///< 垂直中心
@property (nonatomic, readonly) CGPoint zhh_middlePoint;  ///< 中心点

@end

NS_ASSUME_NONNULL_END
