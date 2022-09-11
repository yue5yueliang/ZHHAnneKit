//
//  UIImage+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIImage+ZHHKit.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

static NSTimeInterval const ZHHThumbnailImageTime = 10.0f;

@implementation UIImage (ZHHKit)
- (UIImage *)zhh_imageGradientWithSize:(CGSize)imageSize colorArr:(NSArray *)colorArr percentArr:(NSArray *)percentArr gradientType:(ZHHGradientType)gradientType {
    NSAssert(percentArr.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colorArr) {
        [ar addObject:(id)c.CGColor];
    }
    
    //    NSUInteger capacity = percents.count;
    //    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percentArr.count; i++) {
        locations[i] = [percentArr[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colorArr lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case ZHHGradientFromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case ZHHGradientFromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case ZHHGradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case ZHHGradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)zhh_originImageWithName:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)zhh_imageWithColor:(UIColor *)color{
    return [self zhh_imageWithColor:color size:CGSizeMake(1, 1)];
}

/// 生成颜色图片
/// @param color 生成图片颜色
/// @param size 图片尺寸
+ (UIImage *)zhh_imageWithColor:(UIColor *)color size:(CGSize)size{
    if (!color || size.width <= 0 || size.height <= 0) return [[UIImage alloc] init];
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 改变图片颜色
- (UIImage *)zhh_changeImageColor:(UIColor *)color{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*2, self.size.height*2));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width * 2, self.size.height * 2);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    [color set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
/// 改变图片内部像素颜色
- (UIImage *)zhh_changeImagePixelColor:(UIColor *)color{
    CGFloat red = 0, green = 0, blue = 0, a;
    [color getRed:&red green:&green blue:&blue alpha:&a];
    int imageWidth = self.size.width;
    int imageHeight = self.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 bytesPerRow,
                                                 space,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i<pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t *ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255;
            ptr[2] = green*255;
            ptr[1] = blue*255;
        } else {
            uint8_t *ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, kProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth,
                                        imageHeight,
                                        8,
                                        32,
                                        bytesPerRow,
                                        space,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little,
                                        dataProvider,
                                        NULL,
                                        true,
                                        kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    return resultImage;
}
/// 释放
static void kProviderReleaseData(void *info, const void * data, size_t size){
    free((void*)data);
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

/// 修改图片线条颜色
- (UIImage *)zhh_imageLinellaeColor:(UIColor *)color{
    return [self zhh_imageBlendMode:kCGBlendModeDestinationIn tineColor:color];
}
/// 图层混合
- (UIImage *)zhh_imageBlendMode:(CGBlendMode)blendMode tineColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
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

/// 根据图片和颜色返回一张加深颜色以后的图片
+ (UIImage *)zhh_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color{
    UIGraphicsBeginImageContext(CGSizeMake(sourceImage.size.width*2, sourceImage.size.height*2));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, sourceImage.size.width * 2, sourceImage.size.height * 2);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, sourceImage.CGImage);
    
    [color set];
    
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, sourceImage.CGImage);
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

/// 根据指定的图片颜色和图片大小获取指定的Image
+ (UIImage *)zhh_getImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
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
@end
