//
//  NSFileManager+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSFileManager+ZHHKit.h"

@implementation NSFileManager (ZHHKit)
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
