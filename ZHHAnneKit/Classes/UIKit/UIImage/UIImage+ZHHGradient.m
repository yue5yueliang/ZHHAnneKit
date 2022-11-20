//
//  UIImage+ZHHGradient.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/20.
//

#import "UIImage+ZHHGradient.h"

@implementation UIImage (ZHHGradient)

- (UIImage *)zhh_imageGradientWithColors:(NSArray *)colors
                                percents:(NSArray *)percents
                                    type:(ZHHGradientType)type
                                    size:(CGSize)size {
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
    //    NSUInteger capacity = percents.count;
    //    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (type) {
        case ZHHGradientFromTopToBottom:
            start = CGPointMake(size.width/2, 0.0);
            end = CGPointMake(size.width/2, size.height);
            break;
        case ZHHGradientFromLeftToRight:
            start = CGPointMake(0.0, size.height/2);
            end = CGPointMake(size.width, size.height/2);
            break;
        case ZHHGradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case ZHHGradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, size.height);
            end = CGPointMake(size.width, 0.0);
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
@end
