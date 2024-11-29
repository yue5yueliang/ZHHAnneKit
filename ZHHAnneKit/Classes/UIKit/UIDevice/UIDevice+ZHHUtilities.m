//
//  UIDevice+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 宁小陌 on 2022/9/24.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIDevice+ZHHUtilities.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIDevice (ZHHUtilities)

/// @brief 获取启动图缓存路径
/// 根据当前系统版本，返回存储启动图的缓存路径。如果路径不存在，返回 `nil`。
///@return 启动图缓存路径字符串，若不存在则返回 `nil`。
+ (NSString *)zhh_launchImageCachePath {
    // 获取应用的 Bundle ID
    NSString *bundleID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    NSString *path = nil;
    
    // 统一使用 iOS 13 以上的路径格式
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    path = [NSString stringWithFormat:@"%@/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", libraryDirectory, bundleID];
    
    // 检查路径是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}

/**
 * @brief 获取启动图备份路径
 *
 * @discussion 该方法用于获取存储启动图备份的路径，路径位于 `Documents` 目录下的
 *             `ll_launchImage_backup` 文件夹。如果路径不存在，会自动创建。
 *
 * @return 启动图备份文件夹的完整路径。
 */
+ (NSString *)zhh_launchImageBackupPath {
    // 获取应用的 Documents 目录路径
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // 拼接启动图备份路径
    NSString *backupPath = [documentsDirectory stringByAppendingPathComponent:@"ll_launchImage_backup"];
    
    // 检查路径是否存在，不存在则创建
    if (![NSFileManager.defaultManager fileExistsAtPath:backupPath]) {
        NSError *error = nil;
        [NSFileManager.defaultManager createDirectoryAtPath:backupPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:&error];
        if (error) {
            NSLog(@"[Error] 创建启动图备份路径失败: %@", error.localizedDescription);
        }
    }
    
    return backupPath;
}
@end
