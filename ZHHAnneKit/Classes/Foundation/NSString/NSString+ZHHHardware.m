//
//  NSString+ZHHHardware.m
//  ZHHAnneKit
//
//  Created by 宁小陌 on 2022/9/25.
//

#import "NSString+ZHHHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation NSString (ZHHHardware)
+ (NSString *)zhh_platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

//获取设备型号名称
+ (NSString *)zhh_platformString {
    // 获取设备的原始平台字符串
    NSString *platform = [self zhh_platform];

    // iPhone 16 系列
    if ([platform isEqualToString:@"iPhone16,1"])    return @"iPhone 16 Pro Max";
    if ([platform isEqualToString:@"iPhone16,2"])    return @"iPhone 16 Pro";
    if ([platform isEqualToString:@"iPhone16,3"])    return @"iPhone 16 Plus";
    if ([platform isEqualToString:@"iPhone16,4"])    return @"iPhone 16";

    // iPhone 15 系列
    if ([platform isEqualToString:@"iPhone15,3"])    return @"iPhone 15 Pro Max";
    if ([platform isEqualToString:@"iPhone15,2"])    return @"iPhone 15 Pro";
    if ([platform isEqualToString:@"iPhone15,1"])    return @"iPhone 15 Plus";
    if ([platform isEqualToString:@"iPhone15,0"])    return @"iPhone 15";

    // iPhone 14 系列
    if ([platform isEqualToString:@"iPhone14,3"])    return @"iPhone 14 Pro Max";
    if ([platform isEqualToString:@"iPhone14,2"])    return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone14,8"])    return @"iPhone 14 Plus";
    if ([platform isEqualToString:@"iPhone14,7"])    return @"iPhone 14";
    if ([platform isEqualToString:@"iPhone14,6"])    return @"iPhone SE (3rd generation)";

    // iPhone 13 系列
    if ([platform isEqualToString:@"iPhone13,4"])    return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone13,3"])    return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone13,2"])    return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone13,1"])    return @"iPhone 13 mini";

    // iPhone 12 系列
    if ([platform isEqualToString:@"iPhone12,5"])    return @"iPhone 12 Pro Max";
    if ([platform isEqualToString:@"iPhone12,3"])    return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone12,2"])    return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone12,1"])    return @"iPhone 12 mini";

    // iPhone X 系列
    if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone XR";

    if ([platform isEqualToString:@"iPhone10,6"] || [platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 7";

    if ([platform isEqualToString:@"iPhone9,4"])     return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])     return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])     return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone9,1"])     return @"iPhone 6s";

    if ([platform isEqualToString:@"iPhone8,4"])     return @"iPhone SE (1st generation)";
    if ([platform isEqualToString:@"iPhone8,2"])     return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,1"])     return @"iPhone 6s";

    if ([platform isEqualToString:@"iPhone7,2"])     return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])     return @"iPhone 6 Plus";

    if ([platform isEqualToString:@"iPhone6,2"])     return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,1"])     return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone5,4"])     return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,3"])     return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,2"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,1"])     return @"iPhone 5";

    if ([platform isEqualToString:@"iPhone4,1"])     return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone3,3"])     return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone3,1"])     return @"iPhone 4";

    if ([platform isEqualToString:@"iPhone2,1"])     return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone1,2"])     return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone1,1"])     return @"iPhone";

    // iPad mini 6th
    if ([platform isEqualToString:@"iPad14,1"])      return @"iPad mini 6th";
    if ([platform isEqualToString:@"iPad14,2"])      return @"iPad mini 6th";
    
    // iPad Air (4th generation)
    if ([platform isEqualToString:@"iPad13,1"])      return @"iPad Air (4th generation)";
    if ([platform isEqualToString:@"iPad13,2"])      return @"iPad Air (4th generation)";
    if ([platform isEqualToString:@"iPad13,4"])      return @"iPad Pro 11-inch (3rd generation)";
    if ([platform isEqualToString:@"iPad13,5"])      return @"iPad Pro 11-inch (3rd generation)";
    if ([platform isEqualToString:@"iPad13,6"])      return @"iPad Pro 11-inch (3rd generation)";
    if ([platform isEqualToString:@"iPad13,7"])      return @"iPad Pro 11-inch (3rd generation)";

    if ([platform isEqualToString:@"iPad13,8"])      return @"iPad Pro 12.9-inch (5th generation)";
    if ([platform isEqualToString:@"iPad13,9"])      return @"iPad Pro 12.9-inch (5th generation)";
    if ([platform isEqualToString:@"iPad13,10"])     return @"iPad Pro 12.9-inch (5th generation)";
    if ([platform isEqualToString:@"iPad13,11"])     return @"iPad Pro 12.9-inch (5th generation)";

    if ([platform isEqualToString:@"iPad12,1"])      return @"iPad (9th generation)";
    if ([platform isEqualToString:@"iPad12,2"])      return @"iPad (9th generation)";

    if ([platform isEqualToString:@"iPad11,1"])      return @"iPad mini (5th generation)";
    if ([platform isEqualToString:@"iPad11,2"])      return @"iPad mini (5th generation)";
    if ([platform isEqualToString:@"iPad11,3"])      return @"iPad Air (3rd generation)";
    if ([platform isEqualToString:@"iPad11,4"])      return @"iPad Air (3rd generation)";
    if ([platform isEqualToString:@"iPad11,6"])      return @"iPad (8th generation)";
    if ([platform isEqualToString:@"iPad11,7"])      return @"iPad (8th generation)";

    if ([platform isEqualToString:@"iPad8,1"])       return @"iPad Pro 11-inch (1st generation)";
    if ([platform isEqualToString:@"iPad8,2"])       return @"iPad Pro 11-inch (1st generation)";
    if ([platform isEqualToString:@"iPad8,3"])       return @"iPad Pro 11-inch (1st generation)";
    if ([platform isEqualToString:@"iPad8,4"])       return @"iPad Pro 11-inch (1st generation)";

    if ([platform isEqualToString:@"iPad8,5"])       return @"iPad Pro 12.9-inch (3rd generation)";
    if ([platform isEqualToString:@"iPad8,6"])       return @"iPad Pro 12.9-inch (3rd generation)";
    if ([platform isEqualToString:@"iPad8,7"])       return @"iPad Pro 12.9-inch (3rd generation)";
    if ([platform isEqualToString:@"iPad8,8"])       return @"iPad Pro 12.9-inch (3rd generation)";

    if ([platform isEqualToString:@"iPad7,1"])       return @"iPad Pro 12.9-inch (2nd generation)";
    if ([platform isEqualToString:@"iPad7,2"])       return @"iPad Pro 12.9-inch (2nd generation)";
    if ([platform isEqualToString:@"iPad7,3"])       return @"iPad Pro 10.5-inch";
    if ([platform isEqualToString:@"iPad7,4"])       return @"iPad Pro 10.5-inch";

    if ([platform isEqualToString:@"iPad6,11"])      return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad6,12"])      return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad6,3"])       return @"iPad Pro 9.7-inch";
    if ([platform isEqualToString:@"iPad6,4"])       return @"iPad Pro 9.7-inch";
    if ([platform isEqualToString:@"iPad6,7"])       return @"iPad Pro 12.9-inch (1st generation)";
    if ([platform isEqualToString:@"iPad6,8"])       return @"iPad Pro 12.9-inch (1st generation)";

    if ([platform isEqualToString:@"iPad5,1"])       return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])       return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,3"])       return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])       return @"iPad Air 2";

    if ([platform isEqualToString:@"iPad4,1"])       return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])       return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])       return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])       return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,5"])       return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,6"])       return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"])       return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])       return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])       return @"iPad mini 3";

    if ([platform isEqualToString:@"iPad3,1"])       return @"iPad (3rd generation)";
    if ([platform isEqualToString:@"iPad3,2"])       return @"iPad (3rd generation)";
    if ([platform isEqualToString:@"iPad3,3"])       return @"iPad (3rd generation)";
    if ([platform isEqualToString:@"iPad3,4"])       return @"iPad (4th generation)";
    if ([platform isEqualToString:@"iPad3,5"])       return @"iPad (4th generation)";
    if ([platform isEqualToString:@"iPad3,6"])       return @"iPad (4th generation)";

    if ([platform isEqualToString:@"iPad2,1"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])       return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,6"])       return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,7"])       return @"iPad mini";

    if ([platform isEqualToString:@"iPad1,1"])       return @"iPad";

    // iPod
    if ([platform isEqualToString:@"iPod9,1"])       return @"iPod Touch (7th generation)";
    if ([platform isEqualToString:@"iPod7,1"])       return @"iPod Touch (6th generation)";
    if ([platform isEqualToString:@"iPod5,1"])       return @"iPod Touch (5th generation)";
    if ([platform isEqualToString:@"iPod4,1"])       return @"iPod Touch (4th generation)";
    if ([platform isEqualToString:@"iPod3,1"])       return @"iPod Touch (3rd generation)";
    if ([platform isEqualToString:@"iPod2,1"])       return @"iPod Touch (2nd generation)";
    if ([platform isEqualToString:@"iPod1,1"])       return @"iPod Touch (1st generation)";

    // Simulator
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"] || [platform isEqualToString:@"arm64"]) {
        return @"Simulator";
    }

    return platform; // 若未匹配，返回原始平台字符串
}
@end
