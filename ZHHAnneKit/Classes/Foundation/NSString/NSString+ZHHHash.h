//
//  NSString+ZHHHash.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHHash)
/// 计算字符串的 MD5 哈希值（仅用于兼容服务端加密，CC_MD5 已被弃用）
- (NSString *)zhh_MD5String;

#pragma mark - SHA 系列哈希方法
/// 生成 SHA-1 哈希值
/// @return SHA-1 哈希值（40 位十六进制字符串）
- (NSString *)zhh_sha1String;

/// 生成 SHA-224 哈希值
/// @return SHA-224 哈希值（56 位十六进制字符串）
- (NSString *)zhh_sha224String;

/// 生成 SHA-256 哈希值
/// @return SHA-256 哈希值（64 位十六进制字符串）
- (NSString *)zhh_sha256String;

/// 生成 SHA-384 哈希值
/// @return SHA-384 哈希值（96 位十六进制字符串）
- (NSString *)zhh_sha384String;

/// 生成 SHA-512 哈希值
/// @return SHA-512 哈希值（128 位十六进制字符串）
- (NSString *)zhh_sha512String;

#pragma mark - HMAC 系列哈希方法
/// 使用 MD5 算法生成带密钥的 HMAC 值
/// @param key HMAC 密钥
/// @return HMAC-MD5 哈希值（32 位十六进制字符串）
- (NSString *)zhh_hmacMD5StringWithKey:(NSString *)key;

/// 使用 SHA-1 算法生成带密钥的 HMAC 值
/// @param key HMAC 密钥
/// @return HMAC-SHA1 哈希值（40 位十六进制字符串）
- (NSString *)zhh_hmacSHA1StringWithKey:(NSString *)key;

/// 使用 SHA-224 算法生成带密钥的 HMAC 值
/// @param key HMAC 密钥
/// @return HMAC-SHA224 哈希值（56 位十六进制字符串）
- (NSString *)zhh_hmacSHA224StringWithKey:(NSString *)key;

/// 使用 SHA-256 算法生成带密钥的 HMAC 值
/// @param key HMAC 密钥
/// @return HMAC-SHA256 哈希值（64 位十六进制字符串）
- (NSString *)zhh_hmacSHA256StringWithKey:(NSString *)key;

/// 使用 SHA-384 算法生成带密钥的 HMAC 值
/// @param key HMAC 密钥
/// @return HMAC-SHA384 哈希值（96 位十六进制字符串）
- (NSString *)zhh_hmacSHA384StringWithKey:(NSString *)key;

/// 使用 SHA-512 算法生成带密钥的 HMAC 值
/// @param key HMAC 密钥
/// @return HMAC-SHA512 哈希值（128 位十六进制字符串）
- (NSString *)zhh_hmacSHA512StringWithKey:(NSString *)key;


/// AES256 加密
/// 将字符串使用指定的密钥加密，返回加密后的 Base64 编码字符串。
/// @param key 密钥（必须为 AES256 支持的长度）
/// @return 加密后的 Base64 字符串，如果加密失败，返回空字符串。
/// NSString *originalString = @"Hello, AES256!";
/// NSString *key = @"MySecurePassword";
/// NSString *encryptedString = [originalString zhh_encryptedStringUsingAES256WithKey:key];
/// NSLog(@"Encrypted: %@", encryptedString);
- (NSString *)zhh_encryptedStringUsingAES256WithKey:(NSString *)key;

/// AES256 解密
/// 使用指定密钥对 Base64 编码的加密字符串解密，返回原始字符串。
/// @param key 密钥（必须与加密时使用的密钥一致）
/// @return 解密后的字符串，如果解密失败，返回空字符串。
/// NSString *originalString = @"Hello, AES256!";
/// NSString *key = @"MySecurePassword";
/// NSString *decryptedString = [encryptedString zhh_decryptedStringUsingAES256WithKey:key];
/// NSLog(@"Decrypted: %@", decryptedString);
- (NSString *)zhh_decryptedStringUsingAES256WithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
