//
//  UIImage+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHUtilities.h"
#import <ZHHAnneKit/UIColor+ZHHUtilities.h>
#import <ZHHAnneKit/UIImage+ZHHColor.h>

@implementation UIImage (ZHHUtilities)

+ (UIImage *)zhh_createTextImageWithString:(NSString *)string imageSize:(CGSize)size {
    return [UIImage zhh_createNicknameImageName:[UIImage zhh_dealWithNikeName:string] imageSize:size];
}

// 根据规则截取昵称，提取处理后的显示名称
+ (NSString *)zhh_dealWithNikeName:(NSString *)nikeName {
    // 去除昵称中可能包含的特殊符号【】（例如，某些应用场景中昵称可能含有多余符号）
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"【】"];
    nikeName = [nikeName stringByTrimmingCharactersInSet:set];
    
    NSString *showName = @""; // 最终用于显示的昵称
    NSString *tempName = @""; // 临时存储中间处理结果的昵称
    
    // 检测昵称中是否包含“-”，并截取前部分内容
    NSRange range1 = [nikeName rangeOfString:@"-"];
    if (range1.length) {
        // 含有“-”，截取“-”之前的部分
        tempName = [nikeName substringToIndex:range1.location];
    } else {
        // 不含“-”，直接使用原昵称
        tempName = nikeName;
    }
    
    // 检测昵称中是否包含“(”，并截取前部分内容
    NSRange range2 = [tempName rangeOfString:@"("];
    if (range2.length) {
        // 含有“(”，截取“(”之前的部分
        tempName = [tempName substringToIndex:range2.location];
    } else {
        // 不含“(”，保留当前的 tempName
        tempName = tempName;
    }
    
    // 判断截取后的昵称是否包含字母
    if ([UIImage zhh_doesStringContainLetter:tempName]) {
        // 如果含有字母，则取前两个字符作为显示名称
        showName = [tempName substringToIndex:MIN(2, tempName.length)];
    } else {
        // 不含字母的情况，根据昵称长度处理
        if (tempName.length == 0) {
            // 无内容，保持空字符串
        } else if (tempName.length == 1) {
            // 单个字符，直接使用
            showName = [tempName substringToIndex:1];
        } else if (tempName.length == 2) {
            // 两个字符，直接使用
            showName = [tempName substringToIndex:2];
        } else if (tempName.length >= 3) {
            // 三个或以上字符，取后两位
            showName = [tempName substringFromIndex:tempName.length - 2];
        }
    }
    
    return showName; // 返回最终显示的昵称
}

// 检查字符串是否包含字母
+ (BOOL)zhh_doesStringContainLetter:(NSString *)str {
    // 如果字符串为空，直接返回 NO
    if (!str) {
        return NO;
    }
    
    // 使用正则表达式匹配字母（大小写皆可）
    NSRegularExpression *letterRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    // 统计字符串中匹配到的字母个数
    NSInteger count = [letterRegular numberOfMatchesInString:str options:0 range:NSMakeRange(0, str.length)];
    // 如果匹配到的字母数量大于 0，则表示字符串中包含字母
    return count > 0;
}

// 根据nickname绘制图片
+ (UIImage *)zhh_createNicknameImageName:(NSString *)name imageSize:(CGSize)size{
    NSArray *colorArr = @[@"17c295",@"b38979",@"f2725e",@"f7b55e",@"4da9eb",@"5f70a7",@"568aad"];
    NSString *nickname = colorArr[ABS(name.hash % colorArr.count)];
    UIImage *image = [UIImage zhh_imageWithColor:[UIImage zhh_colorWithHexString:nickname alpha:1.0] size:size cornerRadius:size.width/2];
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    
    // 画名字
    UIFont *fontSize = [UIFont systemFontOfSize:15.f];
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:fontSize}];
    
    [name drawAtPoint:CGPointMake((size.width  - nameSize.width)/2, (size.height - nameSize.height)/2)
       withAttributes:@{NSFontAttributeName:fontSize, NSForegroundColorAttributeName:[UIColor zhh_colorWithHex:0xffffff]}];
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}

+ (id)zhh_colorWithHexString:(NSString*)hexColor alpha:(CGFloat)alpha {
    
    unsigned int red,green,blue;
    NSRange range;
    
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    UIColor* retColor = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:alpha];
    return retColor;
}

/**
 *  @brief  根据bundle中的文件名读取图片
 *  @param name 图片名
 *  @return 无缓存的图片
 */
+ (UIImage *)zhh_imageWithFileName:(NSString *)name {
    return [self zhh_imageWithFileName:name inBundle:[NSBundle mainBundle]];
}

+ (UIImage *)zhh_imageWithFileName:(NSString *)filename inBundle:(NSBundle*)bundle{
    NSString *extension = @"png";
    
    NSArray *components = [filename componentsSeparatedByString:@"."];
    if ([components count] >= 2) {
        NSUInteger lastIndex = components.count - 1;
        extension = [components objectAtIndex:lastIndex];
        
        filename = [filename substringToIndex:(filename.length-(extension.length+1))];
    }
    
    // 如果为Retina屏幕且存在对应图片，则返回Retina图片，否则查找普通图片
    if ([UIScreen mainScreen].scale == 2.0) {
        filename = [filename stringByAppendingString:@"@2x"];
        NSString *path = [bundle pathForResource:filename ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    if ([UIScreen mainScreen].scale == 3.0) {
        filename = [filename stringByAppendingString:@"@3x"];
        NSString *path = [bundle pathForResource:filename ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    NSString *path = [bundle pathForResource:filename ofType:extension];
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}

+ (CGSize)zhh_imageSizeWithURL:(NSURL *)URL{
    if (!URL) return CGSizeZero;
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)URL, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationRight:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRightMirrored:{
                    temp = width;
                    width = height;
                    height = temp;
                } break;
                default:break;
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

/// 异步获取网络图片大小
+ (CGSize)zhh_imageAsyncGetSizeWithURL:(NSURL *)URL{
    if (!URL) return CGSizeZero;
    __block CGSize imageSize = CGSizeZero;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
        [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
            if ([response.MIMEType isEqualToString:@"image/jpeg"]) {
                imageSize = [self jpgImageSizeWithHeaderData:[data subdataWithRange:NSMakeRange(0,210)]];
            } else if ([response.MIMEType isEqualToString:@"image/png"]) {
                imageSize = [self pngImageSizeWithHeaderData:[data subdataWithRange:NSMakeRange(16,23)]];
            } else if ([response.MIMEType isEqualToString:@"image/gif"]) {
                imageSize = [self gifImageSizeWithHeaderData:[data subdataWithRange:NSMakeRange(6,9)]];
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return imageSize;
}
+ (CGSize)pngImageSizeWithHeaderData:(NSData*)data {
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    return (CGSizeMake(w, h));
}
+ (CGSize)jpgImageSizeWithHeaderData:(NSData*)data {
    if ([data length] <= 0x58) return (CGSizeZero);
    if ([data length] < 210) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return (CGSizeMake(w, h));
    }else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return (CGSizeMake(w, h));
            }else {
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return (CGSizeMake(w, h));
            }
        }else {
            return (CGSizeZero);
        }
    }
}
+ (CGSize)gifImageSizeWithHeaderData:(NSData*)data {
    short w1 = 0, w2 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    short w = w1 + (w2 << 8);
    short h1 = 0, h2 = 0;
    [data getBytes:&h1 range:NSMakeRange(2, 1)];
    [data getBytes:&h2 range:NSMakeRange(3, 1)];
    short h = h1 + (h2 << 8);
    return (CGSizeMake(w, h));
}

@end
