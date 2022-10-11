//
//  NSFileManager+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ZHHExtend)
/// 文档URL
+ (NSURL *)zhh_documentsURL;
/// 拼接了`文档目录`的全路径
+ (NSString *)zhh_documentPath;

/// 库URL
+ (NSURL *)zhh_libraryURL;
/// 库路径
+ (NSString *)zhh_libraryPath;

/// 缓存URL
+ (NSURL *)zhh_cachesURL;
/// 缓存路径
+ (NSString *)zhh_cachesPath;

/// 添加跳过备份属性文件
+ (BOOL)zhh_addSkipBackupAttributeToFile:(NSString *)path;

/// 可用的磁盘空间
+ (double)zhh_availableDiskSpace;
@end

NS_ASSUME_NONNULL_END
