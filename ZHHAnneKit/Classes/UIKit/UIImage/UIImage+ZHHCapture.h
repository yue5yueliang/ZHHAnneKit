//
//  UIImage+ZHHCapture.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHCapture)
/// 获取指定视图的完整截图
/// @param view 需要截图的视图
/// @return 截取的图片
+ (UIImage *)zhh_captureWithView:(UIView *)view;

/// 获取指定视图的部分截图
/// @param view 需要截图的视图
/// @param rect 截取的区域（以视图坐标为准）
/// @return 截取的图片
+ (UIImage *)zhh_captureWithView:(UIView *)view rect:(CGRect)rect;

/// 获取指定视图的自定义质量截图
/// @param view 需要截图的视图
/// @param rect 截取的区域（以视图坐标为准）
/// @param quality 截图质量（屏幕缩放倍数）
/// @return 截取的图片
+ (UIImage *)zhh_captureWithView:(UIView *)view rect:(CGRect)rect quality:(NSInteger)quality;

/// 截取当前屏幕的图像
/// @return 当前屏幕的截图
+ (UIImage *)zhh_captureScreenWindow;

/// 捕获当前屏幕截图，并根据屏幕方向进行调整
/// @return 调整方向后的屏幕截图
+ (UIImage *)zhh_captureScreenAdjustedForOrientation;

/// 截取 UIScrollView 可滚动区域的长图
/// @param scroll UIScrollView 实例，目标滚动视图
/// @param offset 当前内容偏移量，用于指定截取的起始位置
/// @return 截取后的长图
+ (UIImage *)zhh_captureScreenWithScrollView:(UIScrollView *)scroll contentOffset:(CGPoint)offset;

@end

NS_ASSUME_NONNULL_END
