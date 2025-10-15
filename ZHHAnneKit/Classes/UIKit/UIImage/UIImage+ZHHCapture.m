//
//  UIImage+ZHHCapture.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHCapture.h"

@implementation UIImage (ZHHCapture)
#pragma mark - 截图处理

/// 获取指定视图的完整截图
/// @param view 需要截图的视图
/// @return 截取的图片
+ (UIImage *)zhh_captureWithView:(UIView *)view {
    return [self zhh_captureWithView:view rect:view.bounds quality:UIScreen.mainScreen.scale];
}

/// 获取指定视图的部分截图
/// @param view 需要截图的视图
/// @param rect 截取的区域（以视图坐标为准）
/// @return 截取的图片
+ (UIImage *)zhh_captureWithView:(UIView *)view rect:(CGRect)rect {
    return [self zhh_captureWithView:view rect:rect quality:UIScreen.mainScreen.scale];
}

/// 获取指定视图的自定义质量截图
/// @param view 需要截图的视图
/// @param rect 截取的区域（以视图坐标为准）
/// @param quality 截图质量（屏幕缩放倍数）
/// @return 截取的图片
+ (UIImage *)zhh_captureWithView:(UIView *)view rect:(CGRect)rect quality:(NSInteger)quality {
    return ({
        // 计算截图区域的最终尺寸
        CGSize size = view.bounds.size;
        size.width  = floorf(size.width  * quality) / quality;
        size.height = floorf(size.height * quality) / quality;
        
        // 根据质量调整截图区域
        CGRect scaledRect = CGRectMake(rect.origin.x * quality,
                                       rect.origin.y * quality,
                                       rect.size.width * quality,
                                       rect.size.height * quality);
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, NO, quality);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 从截取的图片中裁剪出指定区域
        CGImageRef imageRef = CGImageCreateWithImageInRect(viewImage.CGImage, scaledRect);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        croppedImage;
    });
}

/// 截取当前屏幕的图像
/// @return 当前屏幕的截图
+ (UIImage *)zhh_captureScreenWindow {
    // 获取屏幕尺寸
    CGSize imageSize = [UIScreen mainScreen].bounds.size;

    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 遍历所有窗口
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        // 保存当前图形上下文状态
        CGContextSaveGState(context);

        // 设置窗口的几何变换
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context,
                              -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);

        // iOS 13.0+ 直接使用 drawViewHierarchyInRect:afterScreenUpdates: 方法
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];

        // 恢复图形上下文状态
        CGContextRestoreGState(context);
    }

    // 从当前图形上下文获取生成的图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图形上下文
    UIGraphicsEndImageContext();

    return image;
}

/// 捕获当前屏幕截图，并根据屏幕方向进行调整
/// @return 调整方向后的屏幕截图
+ (UIImage *)zhh_captureScreenAdjustedForOrientation {
    // 初始化图片尺寸变量
    CGSize imageSize = CGSizeZero;
    
    // 获取当前的屏幕方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].windows.firstObject.windowScene.interfaceOrientation;
    
    // 获取屏幕的尺寸
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    // 根据屏幕方向调整图片尺寸
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = screenBounds.size;
    } else {
        imageSize = CGSizeMake(screenBounds.size.height, screenBounds.size.width);
    }
    
    // 开启绘图上下文，指定图片尺寸和屏幕的缩放比例
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 遍历所有窗口，将每个窗口的内容绘制到上下文中
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        // 保存当前上下文状态
        CGContextSaveGState(context);
        
        // 移动上下文的原点到窗口的中心
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        
        // 应用窗口的变换（旋转、缩放等）
        CGContextConcatCTM(context, window.transform);
        
        // 调整上下文的原点以匹配窗口的锚点
        CGContextTranslateCTM(context,
                              -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);
        
        // 根据屏幕方向调整上下文的旋转和位移
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
                CGContextRotateCTM(context, M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
                break;
            case UIInterfaceOrientationLandscapeRight:
                CGContextRotateCTM(context, -M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
                break;
            default:
                break;
        }
        
        // 绘制窗口内容（iOS 13.0+）
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        
        // 恢复上下文状态
        CGContextRestoreGState(context);
    }
    
    // 从上下文中获取最终生成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束绘图上下文
    UIGraphicsEndImageContext();
    
    // 返回生成的图片
    return image;
}

/// 截取 UIScrollView 可滚动区域的长图
/// @param scroll UIScrollView 实例，目标滚动视图
/// @param offset 当前内容偏移量，用于指定截取的起始位置
/// @return 截取后的长图
+ (UIImage *)zhh_captureScreenWithScrollView:(UIScrollView *)scroll contentOffset:(CGPoint)offset {
    // 开启绘图上下文，尺寸为滚动视图当前可视区域的大小
    UIGraphicsBeginImageContext(scroll.bounds.size);
    
    // 移动绘图上下文，使其开始绘制的位置对应于指定的偏移量
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -offset.y);
    
    // 将滚动视图的内容渲染到当前绘图上下文中
    [scroll.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 从上下文中获取生成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束绘图上下文
    UIGraphicsEndImageContext();
    
    // 返回截取的图片
    return image;
}

@end
