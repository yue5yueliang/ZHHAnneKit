//
//  UIImage+ZHHBetterFace.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHBetterFace.h"
#import <CoreImage/CoreImage.h>

#define GOLDEN_RATIO 0.618

@implementation UIImage (ZHHBetterFace)
/// 聚焦人脸区域并生成目标尺寸的图片
/// @param targetSize 目标图片尺寸
/// @param accuracy 人脸检测精度（高或低）
/// @return 聚焦人脸的裁剪图片，未检测到人脸时返回 nil
- (UIImage *)zhh_focusedImageOnFacesWithTargetSize:(CGSize)targetSize accuracy:(ZHHAccuracy)accuracy {
    // 检测人脸特征
    NSArray<CIFaceFeature *> *features = [UIImage zhh_detectFaceFeaturesInImage:self accuracy:accuracy];
    
    if (features.count == 0) {
        NSLog(@"ZHHAnneKit 信息: 未检测到人脸");
        return nil;
    } else {
        NSLog(@"ZHHAnneKit 信息: 检测到 %lu 个人脸", (unsigned long)features.count);
        // 根据人脸特征裁剪图片
        return [self zhh_croppedImageForFaceFeatures:features targetSize:targetSize];
    }
}

/// 根据人脸特征裁剪图片
/// @param faceFeatures 检测到的人脸特征数组
/// @param targetSize 目标图片尺寸
/// @return 裁剪后的人脸聚焦图片
- (UIImage *)zhh_croppedImageForFaceFeatures:(NSArray<CIFaceFeature *> *)faceFeatures targetSize:(CGSize)targetSize {
    CGRect facesBoundingBox = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    CGFloat rightBoundary = 0, bottomBoundary = 0;
    CGSize originalSize = self.size;
    
    // 遍历所有人脸特征，确定包含所有人脸的最小矩形
    for (CIFaceFeature *faceFeature in faceFeatures) {
        CGRect faceRect = faceFeature.bounds;
        // 修正坐标系，将人脸矩形翻转为图片坐标
        faceRect.origin.y = originalSize.height - faceRect.origin.y - faceRect.size.height;
        
        // 更新包含所有人脸的矩形边界
        facesBoundingBox.origin.x = MIN(faceRect.origin.x, facesBoundingBox.origin.x);
        facesBoundingBox.origin.y = MIN(faceRect.origin.y, facesBoundingBox.origin.y);
        rightBoundary = MAX(faceRect.origin.x + faceRect.size.width, rightBoundary);
        bottomBoundary = MAX(faceRect.origin.y + faceRect.size.height, bottomBoundary);
    }
    
    facesBoundingBox.size.width = rightBoundary - facesBoundingBox.origin.x;
    facesBoundingBox.size.height = bottomBoundary - facesBoundingBox.origin.y;
    
    // 确定中心点
    CGPoint faceCenter = CGPointMake(CGRectGetMidX(facesBoundingBox), CGRectGetMidY(facesBoundingBox));
    CGPoint offset = CGPointZero;
    CGSize finalSize = originalSize;
    
    // 根据目标宽高比裁剪图片
    if (originalSize.width / originalSize.height > targetSize.width / targetSize.height) {
        // 水平方向移动
        finalSize.height = targetSize.height;
        finalSize.width = originalSize.width / originalSize.height * finalSize.height;
        
        // 缩放 faceCenter
        faceCenter.x = finalSize.width / originalSize.width * faceCenter.x;
        faceCenter.y = finalSize.width / originalSize.width * faceCenter.y;
        
        // 计算水平偏移
        offset.x = faceCenter.x - targetSize.width * 0.5;
        offset.x = MAX(0, MIN(offset.x, finalSize.width - targetSize.width));
        finalSize.width = targetSize.width; // 宽度调整为目标宽度
    } else {
        // 垂直方向移动
        finalSize.width = targetSize.width;
        finalSize.height = originalSize.height / originalSize.width * finalSize.width;
        
        // 缩放 faceCenter
        faceCenter.x = finalSize.width / originalSize.width * faceCenter.x;
        faceCenter.y = finalSize.width / originalSize.width * faceCenter.y;
        
        // 计算垂直偏移
        offset.y = faceCenter.y - targetSize.height * (1 - GOLDEN_RATIO);
        offset.y = MAX(0, MIN(offset.y, finalSize.height - targetSize.height));
        finalSize.height = targetSize.height; // 高度调整为目标高度
    }
    
    // 计算最终裁剪矩形
    CGFloat scale = originalSize.width / finalSize.width;
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CGRect finalRect = CGRectApplyAffineTransform(CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height), transform);
    
    // 裁剪图片
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, finalRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

#pragma mark - 工具方法

/// 检测图片中的人脸特征
/// @param image 待检测的图片
/// @param accuracy 检测精度（高或低）
/// @return 检测到的人脸特征数组
+ (NSArray<CIFaceFeature *> *)zhh_detectFaceFeaturesInImage:(UIImage *)image accuracy:(ZHHAccuracy)accuracy {
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSString *accuracyOption = (accuracy == ZHHAccuracyLow) ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh;
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy: accuracyOption}];
    NSArray<CIFeature *> *features = [detector featuresInImage:ciImage];
    
    // 过滤非 CIFaceFeature 类型的对象
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(CIFeature *feature, NSDictionary *bindings) {
        return [feature isKindOfClass:[CIFaceFeature class]];
    }];
    return (NSArray<CIFaceFeature *> *)[features filteredArrayUsingPredicate:predicate];
}
@end
