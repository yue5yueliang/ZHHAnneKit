//
//  UIDevice+ZHHHardware.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


///=============================================================================
/// @name App Information
///=============================================================================
@interface UIDevice (ZHHHardware)
/// 获取应用程序的版本号
@property (nonatomic,strong,class) NSString *zhh_appVersion;
/// 获取应用程序的显示名称
@property (nonatomic,strong,class) NSString *zhh_appName;
/// 获取设备唯一标识符（identifierForVendor）
@property (nonatomic,strong,class) NSString *zhh_deviceID;
/// 获取应用程序图标
@property (nonatomic,strong,class) UIImage *zhh_appIcon;
/// 获取启动页面图片
@property (nonatomic,strong,class) UIImage *zhh_launchImage;
/// 判断当前系统是否有摄像头
@property (nonatomic,assign,class) BOOL zhh_hasCamera;
/// 获取应用程序的 Build 版本号（字符串形式）
@property (nonatomic,strong,class) NSString *zhh_build;
/// 获取应用程序的 Bundle Identifier
@property (nonatomic,strong,class) NSString *zhh_identifier;
/// 获取当前应用程序的首选语言
@property (nonatomic,strong,class) NSString *zhh_currentLanguage;
/// 获取设备型号（如:iPhone13,4）
@property (nonatomic,strong,class) NSString *zhh_deviceModel;
@end

@interface UIDevice (System)
#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================
/// 设备系统版本(如13.5.1)
@property (nullable, nonatomic, readonly) NSString *zhh_systemVersion;
/// 判断设备是否为 iPad 或 iPad Mini
@property (nonatomic, readonly) BOOL zhh_isPad;
/// 设备是否是模拟器.
@property (nonatomic, readonly) BOOL zhh_isSimulator;
/// 设备是否越狱.
@property (nonatomic, readonly) BOOL zhh_isJailbroken;
/// 设备可以在哪里打电话.
@property (nonatomic, readonly) BOOL zhh_canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
/// 设备的机器型号。如。“iPhone6 1”“iPad4 6”.
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *zhh_machineModel;
/// 设备的机器型号名称。如。“iPhone 5s”“iPad mini 2”.
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *zhh_machineModelName;
/// macAddress
@property (nullable, nonatomic, readonly) NSString *zhh_macAddress;
/// 系统的启动时间.
@property (nonatomic, readonly) NSDate *zhh_systemUptime;

#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================
/// 该设备的WIFI IP地址(可以是nil)。如@“192.168.1.111”.
@property (nullable, nonatomic, readonly) NSString *zhh_ipAddressWIFI;

/// 该设备的单元IP地址(可以是nil)。如@“10.2.2.222”
@property (nullable, nonatomic, readonly) NSString *zhh_ipAddressCell;

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================
/// 总磁盘空间(以字节为单位)。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_diskSpace;
/// 可用磁盘空间(以字节为单位)。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_diskSpaceFree;
/// 已用磁盘空间(以字节为单位)。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_diskSpaceUsed;

#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// 以字节为单位的总物理内存。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryTotal;

/// 已使用(活动+非活动+有线)内存(以字节计)。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryUsed;

/// 以字节为单位的空闲内存。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryFree;

/// 以字节为单位的活动内存。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryActive;

/// 以字节为单位的非活动内存。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryInactive;

/// 以字节为单位的有线存储器。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryWired;

/// 以字节为单位的可清除内存。(发生错误时为-1)
@property (nonatomic, readonly) int64_t zhh_memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// 可用CPU处理器数.
@property (nonatomic, readonly) NSUInteger zhh_cpuCount;

/// 当前的CPU使用率，1.0意味着100%。(发生错误时为-1)
@property (nonatomic, readonly) float zhh_cpuUsage;

/// 当前每个处理器的CPU使用率(NSNumber数组)，1.0表示100%。(发生错误时为nil)
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *zhh_cpuUsagePerProcessor;

@end
NS_ASSUME_NONNULL_END
