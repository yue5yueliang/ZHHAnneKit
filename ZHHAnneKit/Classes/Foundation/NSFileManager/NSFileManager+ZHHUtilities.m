//
//  NSFileManager+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSFileManager+ZHHUtilities.h"

@implementation NSFileManager (ZHHUtilities)
/// 获取指定目录的 URL
/// @discussion 返回系统目录的 URL，比如 Documents 或 Caches 目录。
/// @param directory 系统目录类型 (NSSearchPathDirectory)
/// @return 目录对应的 URL，若未找到则返回 nil
+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:directory inDomains:NSUserDomainMask];
    return urls.lastObject; // 返回最后一个结果或 nil
}

/// 获取指定目录的路径
/// @discussion 返回系统目录的路径，比如 Documents 或 Caches 目录。
/// @param directory 系统目录类型 (NSSearchPathDirectory)
/// @return 目录对应的路径，若未找到则返回 nil
+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    return paths.count > 0 ? paths[0] : nil; // 防止空数组访问越界
}

/// 获取 Documents 目录的 URL
/// @discussion 返回当前 App 的 Documents 目录的 URL。
/// @return Documents 目录的 URL
+ (NSURL *)zhh_documentsURL {
    return [self URLForDirectory:NSDocumentDirectory];
}

/// 获取 Documents 目录的路径
/// @discussion 返回当前 App 的 Documents 目录的路径。
/// @return Documents 目录的路径
+ (NSString *)zhh_documentPath {
    return [self pathForDirectory:NSDocumentDirectory];
}

/// 获取 Library 目录的 URL
/// @discussion 返回当前 App 的 Library 目录的 URL。
/// @return Library 目录的 URL
+ (NSURL *)zhh_libraryURL {
    return [self URLForDirectory:NSLibraryDirectory];
}

/// 获取 Library 目录的路径
/// @discussion 返回当前 App 的 Library 目录的路径。
/// @return Library 目录的路径
+ (NSString *)zhh_libraryPath {
    return [self pathForDirectory:NSLibraryDirectory];
}

/// 获取 Caches 目录的 URL
/// @discussion 返回当前 App 的 Caches 目录的 URL。
/// @return Caches 目录的 URL
+ (NSURL *)zhh_cachesURL {
    return [self URLForDirectory:NSCachesDirectory];
}

/// 获取 Caches 目录的路径
/// @discussion 返回当前 App 的 Caches 目录的路径。
/// @return Caches 目录的路径
+ (NSString *)zhh_cachesPath {
    return [self pathForDirectory:NSCachesDirectory];
}

/// 为指定文件添加不备份到 iCloud 的属性
/// @discussion 设置文件的 NSURLIsExcludedFromBackupKey 属性为 YES，标记文件不上传到 iCloud。
/// 常用于缓存文件或临时数据的存储，以节省备份空间。
/// @param path 文件的完整路径
/// @return 设置是否成功，返回 YES 表示成功，NO 表示失败
+ (BOOL)zhh_addSkipBackupAttributeToFile:(NSString *)path {
    // 检查路径有效性
    if (path.length == 0) {
        NSLog(@"路径无效：path 不能为空");
        return NO;
    }
    
    // 创建文件 URL
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    // 设置文件属性
    NSError *error = nil;
    BOOL success = [fileURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    if (!success && error) {
        NSLog(@"无法为文件设置跳过备份属性: %@, 路径: %@", error.localizedDescription, path);
    }
    return success;
}

/// 获取可用磁盘空间，单位为 MB
/// @discussion 查询当前设备的剩余磁盘空间大小，返回值以 MB 为单位。常用于检查是否有足够空间存储数据。
/// @return 剩余磁盘空间大小（MB），如果查询失败，返回 0
+ (double)zhh_availableDiskSpace {
    // 获取 Document 目录路径
    NSString *documentPath = [self zhh_documentPath];
    if (!documentPath) {
        NSLog(@"无法获取 Document 路径，可能系统文件路径异常");
        return 0;
    }
    
    // 获取文件系统属性
    NSError *error = nil;
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:documentPath error:&error];
    if (!attributes || error) {
        NSLog(@"无法获取磁盘空间信息: %@", error.localizedDescription);
        return 0;
    }
    
    // 计算并返回磁盘剩余空间（以 MB 为单位）
    unsigned long long freeSpace = [attributes[NSFileSystemFreeSize] unsignedLongLongValue];
    return freeSpace / (double)(1024 * 1024);
}
@end
