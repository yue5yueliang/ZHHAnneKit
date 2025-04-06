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
/// @name 设备信息
///=============================================================================
@interface UIDevice (ZHHHardware)

/// 获取设备唯一标识符（identifierForVendor）
@property (nonatomic, class, readonly) NSString *zhh_deviceID;

/// 获取设备型号（如: iPhone13,4）
@property (nonatomic, class, readonly) NSString *zhh_deviceModel;

/// 获取当前应用程序的首选语言
@property (nonatomic, class, readonly) NSString *zhh_currentLanguage;

/// 判断当前系统是否有摄像头
@property (nonatomic, class, readonly) BOOL zhh_hasCamera;

@end

///=============================================================================
/// @name 设备信息
///=============================================================================
@interface UIDevice (ZHHSystem)

/// 设备系统版本（如 13.5.1）
@property (class, nonatomic, readonly) NSString *zhh_systemVersion;

/// 判断设备是否为 iPad 或 iPad Mini
@property (class, nonatomic, readonly) BOOL zhh_isIPad;

/// 设备是否是模拟器
@property (class, nonatomic, readonly) BOOL zhh_isSimulator;

/// 设备是否越狱
@property (class, nonatomic, readonly) BOOL zhh_isJailbroken;

/// 设备是否支持拨打电话
@property (class, nonatomic, readonly) BOOL zhh_supportsPhoneCalls;

/// 设备的机器型号。如。“iPhone16,3” “iPad14,2”.
@property (class, nonatomic, readonly, nullable) NSString *zhh_machineModel;

/// 设备的机器型号名称。如。“iPhone 16 Pro” “iPad mini 2”.
@property (class, nonatomic, readonly, nullable) NSString *zhh_machineModelName;

/// 获取系统启动时间
@property (class, nonatomic, readonly) NSDate *zhh_systemUptime;

#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================
/// 该设备的WIFI IP地址(可以是nil)。如@“192.168.1.111”.
@property (nullable, nonatomic, readonly) NSString *zhh_ipAddressWIFI;

/// 该设备的单元IP地址(可以是nil)。如@“10.2.2.222”
@property (nullable, nonatomic, readonly) NSString *zhh_ipAddressCell;

///=============================================================================
/// @name 磁盘空间信息
///=============================================================================
/// 总磁盘空间(以字节为单位)。(发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_diskSpace;
/// 可用磁盘空间(以字节为单位)。(发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_diskSpaceFree;
/// 已用磁盘空间(以字节为单位)。(发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_diskSpaceUsed;

#pragma mark - Memory Information
///=============================================================================
/// @name 内存信息
///=============================================================================

/// 总物理内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryTotal;
/// 已使用的内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryUsed;
/// 空闲内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryFree;
/// 活动内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryActive;
/// 非活动内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryInactive;
/// 有线存储内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryWired;
/// 可清除内存 (字节) (发生错误时返回 -1)
@property (class, nonatomic, readonly) int64_t zhh_memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU信息
///=============================================================================

/// CPU 核心数
@property (class, nonatomic, readonly) NSUInteger zhh_cpuCount;
/// 当前 CPU 总使用率 (1.0 表示 100%) (发生错误时返回 -1)
@property (class, nonatomic, readonly) float zhh_cpuUsage;
/// 每个核心的 CPU 使用率 (NSNumber 数组) (发生错误时返回 nil)
@property (class, nonatomic, readonly, nullable) NSArray<NSNumber *> *zhh_cpuUsagePerProcessor;

@end
NS_ASSUME_NONNULL_END

