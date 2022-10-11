//
//  UIImage+ZHHFileName.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHFileName.h"

@implementation UIImage (ZHHFileName)
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

@end
