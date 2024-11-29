//
//  NSFileManager+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ZHHUtilities)
/// 获取 Documents 目录的 URL
/// @discussion 返回当前 App 的 Documents 目录的 URL。
/// @return Documents 目录的 URL
+ (NSURL *)zhh_documentsURL;
/// 获取 Documents 目录的路径
/// @discussion 返回当前 App 的 Documents 目录的路径。
/// @return Documents 目录的路径
+ (NSString *)zhh_documentPath;

/// 获取 Library 目录的 URL
/// @discussion 返回当前 App 的 Library 目录的 URL。
/// @return Library 目录的 URL
+ (NSURL *)zhh_libraryURL;
/// 获取 Library 目录的路径
/// @discussion 返回当前 App 的 Library 目录的路径。
/// @return Library 目录的路径
+ (NSString *)zhh_libraryPath;

/// 获取 Caches 目录的 URL
/// @discussion 返回当前 App 的 Caches 目录的 URL。
/// @return Caches 目录的 URL
+ (NSURL *)zhh_cachesURL;
/// 获取 Caches 目录的路径
/// @discussion 返回当前 App 的 Caches 目录的路径。
/// @return Caches 目录的路径
+ (NSString *)zhh_cachesPath;

/// 为指定文件添加不备份到 iCloud 的属性
/// @discussion 设置文件的 NSURLIsExcludedFromBackupKey 属性为 YES，标记文件不上传到 iCloud。
/// 常用于缓存文件或临时数据的存储，以节省备份空间。
/// @param path 文件的完整路径
/// @return 设置是否成功，返回 YES 表示成功，NO 表示失败
+ (BOOL)zhh_addSkipBackupAttributeToFile:(NSString *)path;

/// 获取可用磁盘空间，单位为 MB
/// @discussion 查询当前设备的剩余磁盘空间大小，返回值以 MB 为单位。常用于检查是否有足够空间存储数据。
/// @return 剩余磁盘空间大小（MB），如果查询失败，返回 0
+ (double)zhh_availableDiskSpace;
@end

NS_ASSUME_NONNULL_END
