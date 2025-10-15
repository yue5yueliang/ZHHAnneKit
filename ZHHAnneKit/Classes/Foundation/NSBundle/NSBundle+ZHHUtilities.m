//
//  NSBundle+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSBundle+ZHHUtilities.h"

@implementation NSBundle (ZHHUtilities)
/// 获取应用程序图标的文件路径
/// @return 应用图标的完整文件路径，如果未找到图标则返回 nil
- (NSString *)zhh_appIconPath {
    // 从 Info.plist 中读取 CFBundleIconFile 的值
    NSString *iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
    if (!iconFilename) {
        // 如果没有找到 CFBundleIconFile，返回 nil
        return nil;
    }

    // 获取图标文件的基名（去除扩展名）
    NSString *iconBasename = [iconFilename stringByDeletingPathExtension];
    // 获取图标文件的扩展名
    NSString *iconExtension = [iconFilename pathExtension];

    // 返回图标文件的完整路径
    return [[NSBundle mainBundle] pathForResource:iconBasename ofType:iconExtension];
}

/// 获取应用程序的图标图像
/// @return 应用图标的 UIImage 对象，如果未找到图标则返回 nil
- (UIImage *)zhh_appIcon {
    // 使用 static 变量缓存图标，避免多次加载
    static UIImage *cachedAppIcon = nil;
    static dispatch_once_t onceToken;

    // 确保只加载一次图标
    dispatch_once(&onceToken, ^{
        // 获取图标的文件路径
        NSString *iconPath = [self zhh_appIconPath];
        if (iconPath) {
            // 从路径加载图标
            cachedAppIcon = [UIImage imageWithContentsOfFile:iconPath];
        }
    });

    // 返回缓存的图标
    return cachedAppIcon;
}

+ (UIImage *)zhh_imageNamed:(NSString *)imageName {
    return [UIImage imageNamed:imageName];
}

+ (NSString *)zhh_textFileNamed:(NSString *)fileName ofType:(NSString *)type {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    if (!filePath) return nil;

    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"ZHHAnneKit 警告: 读取文件 %@.%@ 失败: %@", fileName, type, error.localizedDescription);
        return nil;
    }
    return content;
}

+ (NSString *)zhh_filePathNamed:(NSString *)fileName ofType:(NSString *)type {
    return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}

+ (UIImage *)zhh_imageNamed:(NSString *)imageName inBundle:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
    if (!bundlePath) return nil;

    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (!bundle) return nil;

    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}
@end
