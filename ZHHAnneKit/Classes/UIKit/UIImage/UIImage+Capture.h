//
//  UIImage+Capture.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Capture)
/// 当前视图的屏幕截图
+ (UIImage *)zhh_captureScreen:(UIView *)view;

/// 指定位置的屏幕截图
/// @param view screenshot control
/// @param rect intercept size
+ (UIImage *)zhh_captureScreen:(UIView *)view rect:(CGRect)rect;

/// 自定义质量的屏幕截图
/// @param view is intercepted view
/// @param rect intercept size
/// @param quality quality multiple
/// @return return screenshot
+ (UIImage *)zhh_captureScreen:(UIView *)view rect:(CGRect)rect quality:(NSInteger)quality;

/// 拍摄当前屏幕的截图（窗口截图）
+ (UIImage *)zhh_captureScreenWindow;

/// 捕捉当前屏幕（根据手机方向旋转）
+ (UIImage *)zhh_captureScreenWindowForInterfaceOrientation;

/// 拍摄滚动视图的屏幕截图
/// @param scroll intercept view
/// @param contentOffset start to intercept position
/// @return return screenshot
+ (UIImage *)zhh_captureScreenWithScrollView:(UIScrollView *)scroll contentOffset:(CGPoint)contentOffset;
/// 获取图片指定位置颜色
- (UIColor *)zhh_colorAtPixel:(CGPoint)point;
/// 控制台打印RGB值
+ (void)zhh_rgbValueFromUIColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
