//
//  UIDevice+ZHHHardware.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIDevice+ZHHHardware.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <ZHHAnneKit/ZHHCommonTools.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import <sys/utsname.h>

@implementation UIDevice (ZHHHardware)
@dynamic zhh_appVersion,zhh_appName,zhh_appIcon,zhh_deviceID;

// 获取应用程序的版本号（线程安全，值只初始化一次）
+ (NSString *)zhh_appVersion{
    // 静态变量保存版本号
    static NSString * version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 从 info.plist 文件中读取应用程序的显示版本号
        version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    return version;
}

// 获取应用程序的显示名称（线程安全，值只初始化一次）
+ (NSString *)zhh_appName{
    // 静态变量保存应用名称
    static NSString * name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 从 info.plist 文件中读取应用程序的显示名称
        name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        // 如果 CFBundleDisplayName 不存在，尝试使用 CFBundleName
        if (!name) {
            name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        }
    });
    return name;
}

// 获取设备唯一标识符（identifierForVendor），线程安全且值只初始化一次
+ (NSString *)zhh_deviceID {
    static NSString *identifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 获取设备的 identifierForVendor 并转化为 UUID 字符串
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        identifier = uuid ? [uuid UUIDString] : @"UnknownDeviceID"; // 如果为 nil，返回占位值
    });
    return identifier;
}

+ (UIImage *)zhh_appIcon {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 优先从 CFBundleIcons 中获取图标
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSDictionary *iconsDict = infoDict[@"CFBundleIcons"];
        NSDictionary *primaryIconsDict = iconsDict[@"CFBundlePrimaryIcon"];
        NSArray *iconFiles = primaryIconsDict[@"CFBundleIconFiles"];
        
        // 获取图标文件名（优先取最后一个，通常是最大尺寸图标）
        NSString *iconFilename = iconFiles.lastObject ?: infoDict[@"CFBundleIconFile"];
        if (iconFilename) {
            image = [UIImage imageNamed:iconFilename];
        }
        
        // 如果获取不到图标，则返回空并记录日志
        if (!image) {
            NSLog(@"[zhh_appIcon] Failed to load app icon.");
        }
    });
    return image;
}

@dynamic zhh_build;
// 获取应用程序的 Build 版本号（字符串形式）
- (NSString *)zhh_build {
    static NSString *buildVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 从 Info.plist 中读取 CFBundleVersion
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        // 如果 CFBundleVersion 未定义，提供默认值并记录日志
        if (!buildVersion) {
            buildVersion = @"Unknown";
            NSLog(@"[zhh_build] CFBundleVersion is missing in Info.plist.");
        }
    });
    return buildVersion;
}

@dynamic zhh_identifier;
// 获取应用程序的 Bundle Identifier
- (NSString *)zhh_identifier {
    static NSString *bundleIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 从 Info.plist 中读取 CFBundleIdentifier
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
        
        // 如果 CFBundleIdentifier 未定义，提供默认值并记录日志
        if (!bundleIdentifier) {
            bundleIdentifier = @"Unknown";
            NSLog(@"[zhh_identifier] CFBundleIdentifier is missing in Info.plist.");
        }
    });
    return bundleIdentifier;
}

@dynamic zhh_currentLanguage;
// 获取当前应用程序的首选语言
- (NSString *)zhh_currentLanguage {
    static NSString *currentLanguage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 获取设备的首选语言列表
        NSArray *languages = [NSLocale preferredLanguages];
        // 获取第一个首选语言
        currentLanguage = [languages firstObject];
        
        // 如果没有获取到语言，返回默认语言 "en"
        if (!currentLanguage) {
            currentLanguage = @"en";
            NSLog(@"[zhh_currentLanguage] No preferred language found, defaulting to 'en'.");
        }
    });
    return currentLanguage;
}

@dynamic zhh_deviceModel;
// 获取设备型号
- (NSString *)zhh_deviceModel {
    static NSString *deviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        // 获取设备型号信息
        deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });
    return deviceModel;
}


@dynamic zhh_launchImage;
+ (UIImage *)zhh_launchImage{
    UIImage *lauchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    // 获取当前界面方向（兼容 iOS 13+）
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
    for (UIScene *scene in connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            orientation = windowScene.interfaceOrientation;
            break;
        }
    }
    
    // 确定方向是横向还是纵向
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight){
        viewOrientation = @"Landscape";
    } else {
        viewOrientation = @"Portrait";
    }
    
    // 查找对应的启动图
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}

@dynamic zhh_hasCamera;
+ (BOOL)zhh_hasCamera{
    NSArray *temps = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakeVideo = NO;
    for (NSString *mediaType in temps) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            canTakeVideo = YES;
            break;
        }
    }
    return canTakeVideo;
}

@end


@implementation UIDevice (System)
/// 设备系统版本(如13.5.1)
- (NSString *)zhh_systemVersion {
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion;
    });
    return version;
}

/// 判断设备是否为 iPad 或 iPad Mini
- (BOOL)zhh_isPad {
    static dispatch_once_t onceToken;
    static BOOL isPad;
    dispatch_once(&onceToken, ^{
        isPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    });
    return isPad;
}

/// 设备是否是模拟器.
- (BOOL)zhh_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

/// 设备是否越狱.
- (BOOL)zhh_isJailbroken {
    if ([self zhh_isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [ZHHCommonTools zhh_uuid]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

/// 设备可以在哪里打电话.
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)zhh_canMakePhoneCalls {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return can;
}
#endif

/// 设备的机器型号。如。“iPhone6 1”“iPad4 6”.
/// @see http://theiphonewiki.com/wiki/Models
- (NSString *)zhh_machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}
/// 设备的机器型号名称。如。“iPhone 5s”“iPad mini 2”.
/// @see http://theiphonewiki.com/wiki/Models
- (NSString *)zhh_machineModelName{
    NSString *platform = [self zhh_machineModel];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";//国行、日版、港行
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";//国行、港行
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";//美版、台版
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";//美版、台版
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";//国行(A1863)、日行(A1906)
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";//国行(A1864)、日行(A1898)
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X"; //国行(A1865)、日行(A1902)
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";//美版(Global/A1905)
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";//美版(Global/A1897)
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";//美版(Global/A1901)
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max CN";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])   return @"iPhone SE 2";//(2nd generation)
    if ([platform isEqualToString:@"iPhone13,1"])   return  @"iPhone 12 Mini";
    if ([platform isEqualToString:@"iPhone13,2"])   return  @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])   return  @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])   return  @"iPhone 12 Pro Max";
    if ([platform isEqualToString:@"iPhone14,4"])    return @"iPhone 13 Mini";
    if ([platform isEqualToString:@"iPhone14,5"])    return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,2"])    return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,3"])    return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone14,4"])    return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"])    return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,6"])    return @"iPhone SE"; //(2nd generation)
    if ([platform isEqualToString:@"iPhone14,7"])    return @"iPhone 14";
    if ([platform isEqualToString:@"iPhone14,8"])    return @"iPhone 14 Plus";
    if ([platform isEqualToString:@"iPhone15,2"])    return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone15,3"])    return @"iPhone 14 Pro Max";

    //iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPod9,1"])      return @"iPod Touch 7G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (Cellular)";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (Cellular)";
    
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7-inch (WiFi)";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7-inch (Cellular)";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9-inch (WiFi)";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9-inch (Cellular)";
    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    
    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9-inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9-inch (Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5-inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5-inch (Cellular)";
    if ([platform isEqualToString:@"iPad7,5"])      return @"iPad 6 (WiFi)";
    if ([platform isEqualToString:@"iPad7,6"])      return @"iPad 6 (Cellular)";
    if ([platform isEqualToString:@"iPad7,11"])     return @"iPad 7 (WiFi)";
    if ([platform isEqualToString:@"iPad7,12"])     return @"iPad 7 (Cellular)";
    
    if ([platform isEqualToString:@"iPad8,1"])      return @"iPad Pro 11-inch (WiFi)";
    if ([platform isEqualToString:@"iPad8,2"])      return @"iPad Pro 11-inch (WiFi, 1TB)";
    if ([platform isEqualToString:@"iPad8,3"])      return @"iPad Pro 11-inch (Cellular)";
    if ([platform isEqualToString:@"iPad8,4"])      return @"iPad Pro 11-inch (Cellular, 1TB)";
    if ([platform isEqualToString:@"iPad8,5"])      return @"iPad Pro 12.9-inch 3 (WiFi)";
    if ([platform isEqualToString:@"iPad8,6"])      return @"iPad Pro 12.9-inch 3 (WiFi, 1TB)";
    if ([platform isEqualToString:@"iPad8,7"])      return @"iPad Pro 12.9-inch 3 (Cellular)";
    if ([platform isEqualToString:@"iPad8,8"])      return @"iPad Pro 12.9-inch 3 (Cellular, 1TB)";
    if ([platform isEqualToString:@"iPad8,9"])      return @"iPad Pro 11-inch 2 (WiFi)";
    if ([platform isEqualToString:@"iPad8,10"])     return @"iPad Pro 11-inch 2 (Cellular)";
    if ([platform isEqualToString:@"iPad8,11"])     return @"iPad Pro 12.9-inch 4 (WiFi)";
    if ([platform isEqualToString:@"iPad8,12"])     return @"iPad Pro 12.9-inch 4 (Cellular)";
    
    if ([platform isEqualToString:@"iPad11,1"])     return @"iPad Mini 5 (WiFi)";
    if ([platform isEqualToString:@"iPad11,2"])     return @"iPad Mini 5 (Cellular)";
    if ([platform isEqualToString:@"iPad11,3"])     return @"iPad Air 3 (WiFi)";
    if ([platform isEqualToString:@"iPad11,4"])     return @"iPad Air 3 (Cellular)";
    if ([platform isEqualToString:@"iPad11,6"])     return @"iPad 8 (WiFi)";
    if ([platform isEqualToString:@"iPad11,7"])     return @"iPad 8 (Cellular)";
    
    if ([platform isEqualToString:@"iPad12,1"])     return @"iPad 9";
    if ([platform isEqualToString:@"iPad12,2"])     return @"iPad 9";
    
    if ([platform isEqualToString:@"iPad13,1"])     return @"iPad Air 4 (WiFi)";
    if ([platform isEqualToString:@"iPad13,2"])     return @"iPad Air 4 (Cellular)";
    if ([platform isEqualToString:@"iPad14,1"])     return @"iPad Mini 6";
    if ([platform isEqualToString:@"iPad14,2"])     return @"iPad Mini 6";

    
    if ([platform isEqualToString:@"AirPods1,1"])      return @"AirPods";
    if ([platform isEqualToString:@"AirPods2,1"])      return @"AirPods 2";
    if ([platform isEqualToString:@"AirPods8,1"])      return @"AirPods Pro";

    
    if ([platform isEqualToString:@"AudioAccessory1,1"])      return @"HomePod";
    if ([platform isEqualToString:@"AudioAccessory1,2"])      return @"HomePod";
    if ([platform isEqualToString:@"AudioAccessory5,1"])      return @"HomePod mini";

    if ([platform isEqualToString:@"i386"])         return [UIDevice currentDevice].model;
    if ([platform isEqualToString:@"x86_64"])       return [UIDevice currentDevice].model;
    
    return platform;
}

/// 获取mac地址
- (NSString *)zhh_macAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

/// 系统的启动时间.
- (NSDate *)zhh_systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================
- (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

/// 该设备的WIFI IP地址(可以是nil)。如@“192.168.1.111”.
- (NSString *)zhh_ipAddressWIFI {
    return [self ipAddressWithIfaName:@"en0"];
}

/// 该设备的单元IP地址(可以是nil)。如@“10.2.2.222”
- (NSString *)zhh_ipAddressCell {
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================
/// 总磁盘空间(以字节为单位)。(发生错误时为-1)
- (int64_t)zhh_diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

/// 可用磁盘空间(以字节为单位)。(发生错误时为-1)
- (int64_t)zhh_diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

/// 已用磁盘空间(以字节为单位)。(发生错误时为-1)
- (int64_t)zhh_diskSpaceUsed {
    int64_t total = self.zhh_diskSpace;
    int64_t free = self.zhh_diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// 以字节为单位的总物理内存。(发生错误时为-1)
- (int64_t)zhh_memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

/// 已使用(活动+非活动+有线)内存(以字节计)。(发生错误时为-1)
- (int64_t)zhh_memoryUsed {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

/// 以字节为单位的空闲内存。(发生错误时为-1)
- (int64_t)zhh_memoryFree {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

/// 以字节为单位的活动内存。(发生错误时为-1)
- (int64_t)zhh_memoryActive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

/// 以字节为单位的非活动内存。(发生错误时为-1)
- (int64_t)zhh_memoryInactive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

/// 以字节为单位的有线存储器。(发生错误时为-1)
- (int64_t)zhh_memoryWired {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

/// 以字节为单位的可清除内存。(发生错误时为-1)
- (int64_t)zhh_memoryPurgable {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// 可用CPU处理器数.
- (NSUInteger)zhh_cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}
/// 当前的CPU使用率，1.0意味着100%。(发生错误时为-1)
- (float)zhh_cpuUsage {
    float cpu = 0;
    NSArray *cpus = [self zhh_cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

/// 当前每个处理器的CPU使用率(NSNumber数组)，1.0表示100%。(发生错误时为nil)
- (NSArray *)zhh_cpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

@end
