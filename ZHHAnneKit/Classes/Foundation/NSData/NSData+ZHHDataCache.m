//
//  NSData+ZHHDataCache.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSData+ZHHDataCache.h"
#import <CommonCrypto/CommonDigest.h>

#define kSDMaxCacheFileAmount 100

@implementation NSData (ZHHDataCache)
+ (NSString *)zhh_cachePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"Caches"];
    path = [path stringByAppendingPathComponent:@"ZHHDataCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSString *)zhh_creatMD5StringWithString:(NSString *)string {
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    [hash lowercaseString];
    return hash;
}

+ (NSString *)zhh_creatDataPathWithString:(NSString *)string {
    NSString *path = [NSData zhh_cachePath];
    path = [path stringByAppendingPathComponent:[self zhh_creatMD5StringWithString:string]];
    return path;
}

- (void)zhh_saveDataCacheWithIdentifier:(NSString *)identifier {
    NSString *path = [NSData zhh_creatDataPathWithString:identifier];
    [self writeToFile:path atomically:YES];
}

+ (NSData *)zhh_getDataCacheWithIdentifier:(NSString *)identifier {
    static BOOL isCheckedCacheDisk = NO;
    if (!isCheckedCacheDisk) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *contents = [manager contentsOfDirectoryAtPath:[self zhh_cachePath] error:nil];
        if (contents.count >= kSDMaxCacheFileAmount) {
            [manager removeItemAtPath:[self zhh_cachePath] error:nil];
        }
        isCheckedCacheDisk = YES;
    }
    NSString *path = [self zhh_creatDataPathWithString:identifier];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}
@end
