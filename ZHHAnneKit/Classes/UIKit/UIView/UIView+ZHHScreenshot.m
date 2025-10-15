//
//  UIView+ZHHScreenshot.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHScreenshot.h"

@implementation UIView (ZHHScreenshot)

/// @brief  截取当前view的截图
/// @return 截图
- (UIImage *)zhh_screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // iOS 13.0+ 直接使用 drawViewHierarchyInRect:afterScreenUpdates: 方法
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

/// @brief  截图当前view，包括旋转、缩放等效果
/// @param maxWidth 限制缩放的最大宽度，如果不需要限制，传0
/// @return 截图
- (UIImage *)zhh_screenshotWithMaxWidth:(CGFloat)maxWidth {
    // 如果不需要缩放，直接返回普通截图
    if (maxWidth <= 0 || CGRectGetWidth(self.frame) <= maxWidth) {
        return [self zhh_screenshot];
    }
    
    CGAffineTransform originalTransform = self.transform;
    CGFloat scaleFactor = maxWidth / CGRectGetWidth(self.frame);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    self.transform = scaleTransform; // 缩放视图
    
    // 获取变换后的实际尺寸
    CGRect actualFrame = self.frame;
    CGRect actualBounds = self.bounds;
    
    // 开始绘制截图
    UIGraphicsBeginImageContextWithOptions(actualFrame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // 应用视图的transform
    CGContextTranslateCTM(context, actualFrame.size.width / 2, actualFrame.size.height / 2);
    CGContextConcatCTM(context, self.transform);
    
    // 考虑锚点位置
    CGPoint anchorPoint = self.layer.anchorPoint;
    CGContextTranslateCTM(context, -actualBounds.size.width * anchorPoint.x, -actualBounds.size.height * anchorPoint.y);
    
    // 绘制视图内容（iOS 13.0+）
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 恢复原始的transform
    self.transform = originalTransform;
    
    return screenshot;
}
@end
