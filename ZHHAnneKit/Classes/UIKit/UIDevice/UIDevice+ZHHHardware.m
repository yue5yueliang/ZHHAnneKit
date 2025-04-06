//
//  UIDevice+ZHHHardware.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIDevice+ZHHHardware.h"
#import <AVFoundation/AVFoundation.h>
//#include <sys/socket.h>
#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (ZHHHardware)

#pragma mark - 设备唯一标识符
+ (NSString *)zhh_deviceID {
    static NSString *identifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ?: @"UnknownDeviceID";
    });
    return identifier;
}

#pragma mark - 设备型号
+ (NSString *)zhh_deviceModel {
    static NSString *deviceModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });
    return deviceModel;
}

#pragma mark - 当前系统首选语言
+ (NSString *)zhh_currentLanguage {
    static NSString *currentLanguage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *languages = [NSLocale preferredLanguages];
        currentLanguage = languages.firstObject ?: @"en";
    });
    return currentLanguage;
}

#pragma mark - 设备是否有摄像头
+ (BOOL)zhh_hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end

@implementation UIDevice (ZHHSystem)

#pragma mark - 系统版本
+ (NSString *)zhh_systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

#pragma mark - 是否为 iPad
+ (BOOL)zhh_isIPad {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

#pragma mark - 是否是模拟器
+ (BOOL)zhh_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#pragma mark - 设备是否越狱
+ (BOOL)zhh_isJailbroken {
    if ([self zhh_isSimulator]) return NO; // 模拟器无法检测越狱
    
    NSArray *jailbreakPaths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt"
    ];
    
    for (NSString *path in jailbreakPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash) {
        fclose(bash);
        return YES;
    }
    
    NSString *testPath = [NSString stringWithFormat:@"/private/%@", [[NSUUID UUID] UUIDString]];
    if ([@"test" writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:testPath error:nil];
        return YES;
    }
    
    return NO;
}

#pragma mark - 设备是否支持拨打电话
+ (BOOL)zhh_supportsPhoneCalls {
    static BOOL canMakeCalls;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = networkInfo.serviceSubscriberCellularProviders.allValues.firstObject;
        NSString *mobileNetworkCode = carrier.mobileNetworkCode;
        
        // 如果 MNC 为空，说明设备没有 SIM 卡，不支持拨打电话
        canMakeCalls = (mobileNetworkCode != nil) && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return canMakeCalls;
}

#pragma mark - 设备的机器型号
+ (NSString *)zhh_machineModel {
    static dispatch_once_t onceToken;
    static NSString *model;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        if (machine) {
            sysctlbyname("hw.machine", machine, &size, NULL, 0);
            model = [NSString stringWithUTF8String:machine];
            free(machine);
        }
    });
    return model;
}

#pragma mark - 设备的机器型号名称
+ (NSString *)zhh_machineModelName {
    static dispatch_once_t onceToken;
    static NSDictionary *deviceMap;
    dispatch_once(&onceToken, ^{
        deviceMap = @{
            // iPhone 系列
            @"iPhone6,1": @"iPhone 5s", @"iPhone6,2": @"iPhone 5s",
            @"iPhone7,1": @"iPhone 6 Plus", @"iPhone7,2": @"iPhone 6",
            @"iPhone8,1": @"iPhone 6s", @"iPhone8,2": @"iPhone 6s Plus",
            @"iPhone8,4": @"iPhone SE (1st generation)",
            @"iPhone9,1": @"iPhone 7", @"iPhone9,2": @"iPhone 7 Plus",
            @"iPhone9,3": @"iPhone 7", @"iPhone9,4": @"iPhone 7 Plus",
            @"iPhone10,1": @"iPhone 8", @"iPhone10,2": @"iPhone 8 Plus",
            @"iPhone10,3": @"iPhone X", @"iPhone10,4": @"iPhone 8",
            @"iPhone10,5": @"iPhone 8 Plus", @"iPhone10,6": @"iPhone X",
            @"iPhone11,2": @"iPhone XS", @"iPhone11,4": @"iPhone XS Max",
            @"iPhone11,6": @"iPhone XS Max CN", @"iPhone11,8": @"iPhone XR",
            @"iPhone12,1": @"iPhone 11", @"iPhone12,3": @"iPhone 11 Pro",
            @"iPhone12,5": @"iPhone 11 Pro Max", @"iPhone12,8": @"iPhone SE (2nd generation)",
            @"iPhone13,1": @"iPhone 12 mini", @"iPhone13,2": @"iPhone 12",
            @"iPhone13,3": @"iPhone 12 Pro", @"iPhone13,4": @"iPhone 12 Pro Max",
            @"iPhone14,4": @"iPhone 13 mini", @"iPhone14,5": @"iPhone 13",
            @"iPhone14,2": @"iPhone 13 Pro", @"iPhone14,3": @"iPhone 13 Pro Max",
            @"iPhone14,6": @"iPhone SE (3rd generation)",
            @"iPhone14,7": @"iPhone 14", @"iPhone14,8": @"iPhone 14 Plus",
            @"iPhone15,2": @"iPhone 14 Pro", @"iPhone15,3": @"iPhone 14 Pro Max",
            // iPhone 15 系列
            @"iPhone15,4": @"iPhone 15", @"iPhone15,5": @"iPhone 15 Plus",
            @"iPhone16,1": @"iPhone 15 Pro", @"iPhone16,2": @"iPhone 15 Pro Max",
            // iPhone 16 预测型号
            @"iPhone16,3": @"iPhone 16", @"iPhone16,4": @"iPhone 16 Plus",
            @"iPhone16,5": @"iPhone 16 Pro", @"iPhone16,6": @"iPhone 16 Pro Max",

            // iPad 系列（仅保留部分常见设备）
            @"iPad11,1": @"iPad mini (5th generation)", @"iPad11,2": @"iPad mini (5th generation)",
            @"iPad11,3": @"iPad Air (3rd generation)", @"iPad11,4": @"iPad Air (3rd generation)",
            @"iPad13,1": @"iPad Air (4th generation)", @"iPad13,2": @"iPad Air (4th generation)",
            @"iPad14,1": @"iPad mini (6th generation)", @"iPad14,2": @"iPad mini (6th generation)",

            // 其他设备
            @"i386": [UIDevice currentDevice].model,
            @"x86_64": [UIDevice currentDevice].model
        };
    });

    NSString *platform = [self zhh_machineModel];
    return deviceMap[platform] ?: platform;
}

#pragma mark - 获取系统启动时间
+ (NSDate *)zhh_systemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [NSDate dateWithTimeIntervalSinceNow:-time];
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

#pragma mark - 磁盘空间信息
/// 总磁盘空间(以字节为单位)。(发生错误时返回 -1)
+ (int64_t)zhh_diskSpace {
    return [self zhh_getFileSystemAttribute:NSFileSystemSize];
}
/// 可用磁盘空间(以字节为单位)。(发生错误时返回 -1)
+ (int64_t)zhh_diskSpaceFree {
    return [self zhh_getFileSystemAttribute:NSFileSystemFreeSize];
}
/// 已用磁盘空间(以字节为单位)。(发生错误时返回 -1)
+ (int64_t)zhh_diskSpaceUsed {
    int64_t total = [self zhh_diskSpace];
    int64_t free = [self zhh_diskSpaceFree];
    if (total < 0 || free < 0) return -1;
    return total - free;
}

#pragma mark - 获取磁盘空间属性
+ (int64_t)zhh_getFileSystemAttribute:(NSString *)attributeKey {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    
    if (!attrs || error) {
        NSLog(@"获取文件系统属性失败: %@", error.localizedDescription);
        return -1;
    }

    NSNumber *value = attrs[attributeKey];
    return value ? value.longLongValue : -1;
}

#pragma mark - 内存信息
+ (int64_t)zhh_memoryTotal {
    return [[NSProcessInfo processInfo] physicalMemory];
}

+ (int64_t)zhh_memoryUsed {
    return [self zhh_getMemoryInfo:HOST_VM_INFO type:@"used"];
}

+ (int64_t)zhh_memoryFree {
    return [self zhh_getMemoryInfo:HOST_VM_INFO type:@"free"];
}

+ (int64_t)zhh_memoryActive {
    return [self zhh_getMemoryInfo:HOST_VM_INFO type:@"active"];
}

+ (int64_t)zhh_memoryInactive {
    return [self zhh_getMemoryInfo:HOST_VM_INFO type:@"inactive"];
}

+ (int64_t)zhh_memoryWired {
    return [self zhh_getMemoryInfo:HOST_VM_INFO type:@"wired"];
}

+ (int64_t)zhh_memoryPurgable {
    return [self zhh_getMemoryInfo:HOST_VM_INFO type:@"purgable"];
}

/// 获取内存信息
+ (int64_t)zhh_getMemoryInfo:(host_flavor_t)flavor type:(NSString *)type {
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;

    kern = host_page_size(mach_host_self(), &page_size);
    if (kern != KERN_SUCCESS) return -1;

    kern = host_statistics(mach_host_self(), flavor, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;

    if ([type isEqualToString:@"used"]) {
        return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
    } else if ([type isEqualToString:@"free"]) {
        return vm_stat.free_count * page_size;
    } else if ([type isEqualToString:@"active"]) {
        return vm_stat.active_count * page_size;
    } else if ([type isEqualToString:@"inactive"]) {
        return vm_stat.inactive_count * page_size;
    } else if ([type isEqualToString:@"wired"]) {
        return vm_stat.wire_count * page_size;
    } else if ([type isEqualToString:@"purgable"]) {
        return vm_stat.purgeable_count * page_size;
    }

    return -1;
}

#pragma mark - CPU 信息
+ (NSUInteger)zhh_cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (float)zhh_cpuUsage {
    float cpu = 0;
    NSArray *cpus = [self zhh_cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

+ (NSArray<NSNumber *> *)zhh_cpuUsagePerProcessor {
    processor_info_array_t cpuInfo;
    mach_msg_type_number_t numCPUInfo;
    unsigned numCPUs;
    NSLock *cpuUsageLock;

    int mib[2U] = {CTL_HW, HW_NCPU};
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if (status) numCPUs = 1;

    cpuUsageLock = [[NSLock alloc] init];

    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCPUInfo);
    if (err != KERN_SUCCESS) return nil;

    [cpuUsageLock lock];

    NSMutableArray *cpus = [NSMutableArray new];
    for (unsigned i = 0U; i < numCPUs; ++i) {
        Float32 inUse, total;
        inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] +
                cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] +
                cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
        total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];

        [cpus addObject:@(inUse / total)];
    }

    [cpuUsageLock unlock];
    return cpus;
}

@end

