//
//  ZHHKeychainManager.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**  使用示例
     NSString *service = @"com.example.MyApp";
     NSString *key = @"userPassword";

     // 保存数据
     [ZHHKeychainManager zhh_saveValue:@"mypassword" forKey:key inService:service];

     // 获取数据
     NSString *password = [ZHHKeychainManager zhh_getValueForKey:key inService:service];
     NSLog(@"ZHHAnneKit 信息: 密码: %@", password);

     // 删除数据
     [ZHHKeychainManager zhh_deleteValueForKey:key inService:service];
 */

@interface ZHHKeychainManager : NSObject
/// 保存数据到 Keychain
/// @param value 要保存的值
/// @param key 唯一标识，用于存储
/// @param service 服务名称，用于分隔不同模块数据
+ (BOOL)zhh_saveValue:(NSString *)value forKey:(NSString *)key inService:(NSString *)service;

/// 从 Keychain 获取数据
/// @param key 唯一标识，用于查询
/// @param service 服务名称
+ (NSString *)zhh_getValueForKey:(NSString *)key inService:(NSString *)service;

/// 删除 Keychain 中的数据
/// @param key 唯一标识，用于删除
/// @param service 服务名称
+ (BOOL)zhh_deleteValueForKey:(NSString *)key inService:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
