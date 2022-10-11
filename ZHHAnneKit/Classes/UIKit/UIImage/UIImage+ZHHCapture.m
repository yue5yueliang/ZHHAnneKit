//
//  UIImage+ZHHCapture.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHCapture.h"

@implementation UIImage (ZHHCapture)
#pragma mark - 截图处理
/// 屏幕截图
+ (UIImage *)zhh_captureWithView:(UIView *)view{
    return [UIImage zhh_captureWithView:view rect:view.frame];
}
/// 指定位置屏幕截图
+ (UIImage *)zhh_captureWithView:(UIView *)view rect:(CGRect)rect{
    return [self zhh_captureWithView:view rect:rect quality:UIScreen.mainScreen.scale];
}
/// 自定义质量的截图，quality质量倍数
+ (UIImage *)zhh_captureWithView:(UIView *)view rect:(CGRect)rect quality:(NSInteger)quality{
    return ({
        CGSize size = view.bounds.size;
        size.width  = floorf(size.width  * quality) / quality;
        size.height = floorf(size.height * quality) / quality;
        rect = CGRectMake(rect.origin.x*quality, rect.origin.y*quality, rect.size.width*quality, rect.size.height*quality);
        UIGraphicsBeginImageContextWithOptions(size, NO, quality);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef imageRef = CGImageCreateWithImageInRect([viewImage CGImage], rect);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        newImage;
    });
}
/// 截取当前屏幕
+ (UIImage *)zhh_captureScreenWindow{
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 截取当前屏幕
+ (UIImage *)zhh_captureScreenWindowForInterfaceOrientation{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)){
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight){
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 截取滚动的长图
+ (UIImage *)zhh_captureScreenWithScrollView:(UIScrollView *)scroll contentOffset:(CGPoint)offset{
    UIGraphicsBeginImageContext(scroll.bounds.size);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -offset.y);
    [scroll.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)zhh_rgbValueFromUIColor:(UIColor *)color {
    if (color) {
        //获得RGB值描述
        NSString *rgbValue = [NSString stringWithFormat:@"%@",color];
        //将RGB值描述分隔成字符串
        NSArray *rgbArr = [rgbValue componentsSeparatedByString:@" "];
        //获取红色值
        CGFloat r = [[rgbArr objectAtIndex:1] floatValue] * 255;
        //获取绿色值
        CGFloat g = [[rgbArr objectAtIndex:2] floatValue] * 255;
        //获取蓝色值
        CGFloat b = [[rgbArr objectAtIndex:3] floatValue] * 255;
        NSLog(@"---红色值-%.f-绿色值-%.f-蓝色值-%.f---",r,g,b);
    }else{
        NSLog(@"没有获取到相应的颜色");
    }
}
@end
