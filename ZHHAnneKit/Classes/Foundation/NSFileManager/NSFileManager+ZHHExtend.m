//
//  NSFileManager+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSFileManager+ZHHExtend.h"

@implementation NSFileManager (ZHHExtend)
+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)zhh_documentsURL{
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)zhh_documentPath{
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)zhh_libraryURL{
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)zhh_libraryPath{
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)zhh_cachesURL{
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)zhh_cachesPath{
    return [self pathForDirectory:NSCachesDirectory];
}

+ (BOOL)zhh_addSkipBackupAttributeToFile:(NSString *)path{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)zhh_availableDiskSpace{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.zhh_documentPath error:nil];
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}
@end
