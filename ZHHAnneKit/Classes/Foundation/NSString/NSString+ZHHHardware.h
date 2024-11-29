//
//  NSString+ZHHHardware.h
//  ZHHAnneKit
//
//  Created by 宁小陌 on 2022/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHHardware)
/// 获取设备的型号标识符（如 iPhone13,4）
+ (NSString *)zhh_platform;
/// 获取设备型号名称（通过型号标识符）
+ (NSString *)zhh_platformString;
@end

NS_ASSUME_NONNULL_END
