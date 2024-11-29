//
//  UIView+ZHHScreenshot.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHScreenshot)
/// @brief  截取当前view的截图
/// @return 截图
- (UIImage *)zhh_screenshot;

/// @brief  截图当前view，包括旋转、缩放等效果
/// @param maxWidth 限制缩放的最大宽度，如果不需要限制，传0
/// @return 截图
- (UIImage *)zhh_screenshotWithMaxWidth:(CGFloat)maxWidth;
@end

NS_ASSUME_NONNULL_END
