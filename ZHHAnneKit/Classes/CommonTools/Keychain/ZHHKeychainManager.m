//
//  ZHHKeychainManager.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHKeychainManager.h"
#import <Security/Security.h>

@implementation ZHHKeychainManager

#pragma mark - Public Methods
+ (BOOL)zhh_saveValue:(NSString *)value forKey:(NSString *)key inService:(NSString *)service {
    if (!key || !value || !service) return NO;
    // 删除旧值，避免冲突
    [self zhh_deleteValueForKey:key inService:service];

    // 创建查询字典，指定服务、账号和数据
    NSMutableDictionary *query = [self zhh_keychainQueryForKey:key service:service];
    query[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    // 将数据写入 Keychain
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    return (status == errSecSuccess);
}

+ (NSString *)zhh_getValueForKey:(NSString *)key inService:(NSString *)service {
    if (!key || !service) return nil;
    // 创建查询字典
    NSMutableDictionary *query = [self zhh_keychainQueryForKey:key service:service];
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue; // 返回数据
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne; // 限定返回结果

    // 获取数据
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);

    if (status == errSecSuccess) {
        NSData *data = (__bridge_transfer NSData *)result;
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (BOOL)zhh_deleteValueForKey:(NSString *)key inService:(NSString *)service {
    if (!key || !service) return NO;

    // 创建查询字典
    NSMutableDictionary *query = [self zhh_keychainQueryForKey:key service:service];
    // 删除 Keychain 数据
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    return (status == errSecSuccess);
}


#pragma mark - Private Helper Method

/// 构造查询字典（使用默认服务名）
/// @param key 作为服务的唯一标识
+ (NSMutableDictionary *)zhh_keychainQueryForKey:(NSString *)key {
    return [self zhh_keychainQueryForKey:key service:@"com.example.KeychainService"];
}

/// 构造查询字典
+ (NSMutableDictionary *)zhh_keychainQueryForKey:(NSString *)key service:(NSString *)service {
    return [@{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: service,  // 服务名，对应 service
        (__bridge id)kSecAttrAccount: key   // 账户名，对应 key
    } mutableCopy];
}
@end
