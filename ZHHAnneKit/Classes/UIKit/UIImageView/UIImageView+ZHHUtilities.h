//
//  UIImageView+ZHHUtilities.h
//  Pods
//
//  Created by 桃色三岁 on 2024/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// `UIImageView` 类的扩展，用于支持更好的人脸检测和图片适配功能
@interface UIImageView (ZHHUtilities)
/// 是否需要优化图片以适应人脸区域
@property (nonatomic, assign) BOOL needsBetterFace;

/// 是否使用快速检测模式
@property (nonatomic, assign) BOOL fast;

/// 交换 UIImageView 的 `setImage:` 方法，实现人脸检测功能
void hack_uiimageview_bf(void);

/// 设置优化后的人脸图片
/// @param image 需要检测并优化的人脸图片
- (void)setBetterFaceImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
