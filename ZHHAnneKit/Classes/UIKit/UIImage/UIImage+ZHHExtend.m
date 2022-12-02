//
//  UIImage+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHExtend.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

static NSTimeInterval const ZHHThumbnailImageTime = 10.0f;

@implementation UIImage (ZHHExtend)

+ (UIImage *)zhh_originImageWithName:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/// 改变图片透明度
- (UIImage *)zhh_changeImageAlpha:(CGFloat)alpha{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
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

/// 根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
+ (UIImage *)zhh_resizableImage:(NSString *)imageName {
    return [self zhh_resizableImage:imageName xPos:0.5 yPos:0.5];;
}

/// 根据图片名返回一张能够自由拉伸的图片
+ (UIImage *)zhh_resizableImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

/// 获取视频第一帧图片
+ (UIImage *)zhh_getVideoFirstThumbnailImageWithVideoUrl:(NSURL *)videoUrl {
    AVURLAsset*asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = nil;
    CFTimeInterval thumbnailImageTime = ZHHThumbnailImageTime;
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 1.0f) actualTime:nil error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef) {
        NSLog(@"======thumbnailImageGenerationError======= %@",thumbnailImageGenerationError);
    }
    return thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
}

/// 图片不被渲染
+ (UIImage *)zhh_imageAlwaysOriginalImageWithImageName:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 *  通过传入一个图片对象获取一张缩略图
 */
+ (UIImage *)zhh_getThumbnailImageWithImageObj:(id)imageObj {
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    }else if ([imageObj isKindOfClass:[PHAsset class]]){
        @autoreleasepool {
            PHAsset *asset = (PHAsset *)imageObj;
            return [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)([asset accessibilityPath])];
        }
    }
    return image;
}

/**
 *  设置图片的圆角大小的新图像.
 *  @param radius       每个角椭圆的半径.
 */
- (UIImage *)zhh_imageByRoundCornerRadius:(CGFloat)radius{
    return [self zhh_imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

/**
 *  设置图片的圆角大小的新图像.
 *  @param radius       每个角椭圆的半径.
 *  @param borderWidth  插入边框线宽度.
 *  @param borderColor  边框描边颜色。Nil表示颜色清晰.
 */
- (UIImage *)zhh_imageByRoundCornerRadius:(CGFloat)radius
                              borderWidth:(CGFloat)borderWidth
                              borderColor:(nullable UIColor *)borderColor{
    return [self zhh_imageByRoundCornerRadius:radius
                                      corners:UIRectCornerAllCorners
                                  borderWidth:borderWidth
                                  borderColor:borderColor
                               borderLineJoin:kCGLineJoinMiter];
}

/**
 *  设置图片的圆角大小的新图像.
 *  @param radius       每个角椭圆的半径.
 *  @param corners      标识您想要角圆的位置.
 *  @param borderWidth  插入边框线宽度.
 *  @param borderColor  边框描边颜色。Nil表示颜色清晰.
 *  @param borderLineJoin 边界线连接在一起
 */
- (UIImage *)zhh_imageByRoundCornerRadius:(CGFloat)radius
                                  corners:(UIRectCorner)corners
                              borderWidth:(CGFloat)borderWidth
                              borderColor:(nullable UIColor *)borderColor
                           borderLineJoin:(CGLineJoin)borderLineJoin{
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
