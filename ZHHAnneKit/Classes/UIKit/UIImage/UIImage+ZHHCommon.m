//
//  UIImage+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHCommon.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation UIImage (ZHHCommon)

/// 加载一张始终使用原始模式的图片
/// @param imageName 图片的名称
/// @return 一张不受渲染影响的原始图片
+ (UIImage *)zhh_imageWithOriginalModeNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        NSLog(@"ZHHAnneKit 警告: 图片加载失败，名称: %@", imageName);
        return nil;
    }
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/// 改变图片的透明度
/// @param alpha 透明度值，范围 [0.0, 1.0]
/// @return 修改透明度后的新图片
- (UIImage *)zhh_imageWithAlpha:(CGFloat)alpha {
    NSAssert(alpha >= 0.0 && alpha <= 1.0, @"透明度值必须在 0.0 到 1.0 之间");
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale); // 使用图片原始分辨率
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 翻转坐标系
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -area.size.height);
    
    // 设置透明度和混合模式
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    
    // 绘制图片
    CGContextDrawImage(ctx, area, self.CGImage);
    
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/// 改变图片亮度
- (UIImage *)zhh_changeImageLuminance:(CGFloat)luminance{
    CGImageRef cgimage = self.CGImage;
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    UInt32 * data = (UInt32 *)calloc(width * height * 4, sizeof(UInt32));
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    for (size_t i = 0; i < height; i++){
        for (size_t j = 0; j < width; j++){
            size_t pixelIndex = i * width * 4 + j * 4;
            UInt32 red   = data[pixelIndex];
            UInt32 green = data[pixelIndex + 1];
            UInt32 blue  = data[pixelIndex + 2];
            red += luminance;
            green += luminance;
            blue += luminance;
            data[pixelIndex]     = red > 255 ? 255 : red;
            data[pixelIndex + 1] = green > 255 ? 255 : green;
            data[pixelIndex + 2] = blue > 255 ? 255 : blue;
        }
    }
    cgimage = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    CGImageRelease(cgimage);
    free(data);
    return newImage;
}

/// 根据图片名返回一张能够自由拉伸的图片（从中间拉伸）
/// @param imageName 图片名
+ (UIImage *)zhh_resizableImage:(NSString *)imageName {
    return [self zhh_resizableImage:imageName xPos:0.5 yPos:0.5];
}

/// 根据图片名返回一张能够自由拉伸的图片
/// @param imageName 图片名
/// @param xPos 水平方向拉伸点比例（0.0~1.0）
/// @param yPos 垂直方向拉伸点比例（0.0~1.0）
+ (UIImage *)zhh_resizableImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos {
    NSAssert(imageName != nil, @"图片名不能为空");
    NSAssert(xPos >= 0.0 && xPos <= 1.0, @"xPos 必须在 0.0~1.0 之间");
    NSAssert(yPos >= 0.0 && yPos <= 1.0, @"yPos 必须在 0.0~1.0 之间");
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        NSLog(@"ZHHAnneKit 警告: 图片加载失败: %@", imageName);
        return nil;
    }
    
    CGFloat leftCap = image.size.width * xPos;
    CGFloat topCap = image.size.height * yPos;
    
    return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

/// 获取视频第一帧图片
/// @param videoUrl 视频文件的 URL
/// @return 视频第一帧的图片
+ (UIImage *)zhh_videoFirstFrameImageWithURL:(NSURL *)videoUrl {
    // 参数校验
    NSAssert(videoUrl != nil, @"视频 URL 不能为空");
    
    // 创建视频资源
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    if (!asset) {
        NSLog(@"ZHHAnneKit 警告: 视频资源创建失败，URL: %@", videoUrl);
        return nil;
    }
    
    // 创建图片生成器
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    // 获取指定时间的图片
    CMTime thumbnailTime = CMTimeMake(0, 1); // 第一帧时间 (0 秒)
    NSError *error = nil;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:nil error:&error];
    
    // 错误处理
    if (!imageRef) {
        NSLog(@"获取视频第一帧失败，错误信息: %@", error);
        return nil;
    }
    
    // 创建 UIImage 并释放 CGImageRef
    UIImage *thumbnailImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbnailImage;
}

/// 根据传入的图片对象生成一张缩略图
/// @param imageObj 传入的对象可以是 UIImage 或 PHAsset
/// @return 缩略图 UIImage
+ (UIImage *)zhh_thumbnailFromImageObject:(id)imageObj {
    if ([imageObj isKindOfClass:[UIImage class]]) {
        // 如果是 UIImage，直接返回
        return (UIImage *)imageObj;
    } else if ([imageObj isKindOfClass:[PHAsset class]]) {
        // 如果是 PHAsset，获取缩略图
        PHAsset *asset = (PHAsset *)imageObj;
        __block UIImage *thumbnail = nil;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES; // 同步获取
        
        CGSize targetSize = CGSizeMake(100, 100); // 缩略图大小
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            thumbnail = result;
        }];
        return thumbnail;
    } else {
        NSLog(@"ZHHAnneKit 警告: 不支持的对象类型: %@", NSStringFromClass([imageObj class]));
        return nil;
    }
}
@end
