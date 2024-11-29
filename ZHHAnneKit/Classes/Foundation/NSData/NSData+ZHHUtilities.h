//
//  NSData+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCrypto.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ZHHEncryptionAlgorithm) {
    ZHHEncryptionAlgorithmAES,      // AES 加密
    ZHHEncryptionAlgorithmDES,      // DES 加密
    ZHHEncryptionAlgorithm3DES      // 3DES 加密
};

typedef NS_ENUM(NSUInteger, ZHHHashAlgorithm) {
    ZHHHashAlgorithmMD5,
    ZHHHashAlgorithmSHA1,
    ZHHHashAlgorithmSHA224,
    ZHHHashAlgorithmSHA256,
    ZHHHashAlgorithmSHA384,
    ZHHHashAlgorithmSHA512
};

@interface NSData (ZHHUtilities)
/// 将 APNS NSData 类型的 token 转换为字符串格式
/// 该方法将 APNS 返回的 NSData 类型的 token 转换为一个字符串，适用于 iOS 13 及更高版本。
/// @return 返回格式化后的字符串类型 token。如果数据格式不匹配，则返回空字符串。
- (NSString *)zhh_APNSToken;

/// 获取应用的缓存路径
/// 该方法返回应用中用于存储缓存数据的目录路径。路径是通过获取应用的 Library 目录下的 Caches 目录，并在其中创建名为 "ZHHDataCache" 的文件夹。若该文件夹不存在，则会自动创建。
/// @return 返回缓存目录路径字符串。如果目录不存在，方法会创建它并返回路径。
+ (NSString *)zhh_cachePath;
/// 生成字符串的 SHA-256 哈希值
/// 该方法接收一个字符串并返回该字符串的 SHA-256 哈希值，结果以小写字母形式返回。
/// 由于 CC_MD5 已经在 iOS 13.0 中被弃用，并且它在安全性方面已经不再推荐使用，您应该使用更强大的哈希算法，例如 SHA-256，来代替 MD5
/// @param string 要进行 SHA-256 哈希运算的输入字符串
/// @return 返回字符串的 SHA-256 哈希值，作为一个十六进制字符串
+ (NSString *)zhh_sha256WithString:(NSString *)string;

/// 将数据保存到本地缓存路径
/// 该方法将数据写入到一个由传入的标识符生成的文件路径中，并且保证文件写入是原子性的。
/// @param identifier 用于生成唯一缓存路径的标识符，通常是一个字符串
- (void)zhh_saveDataCacheWithIdentifier:(NSString *)identifier;

/// 从本地缓存中读取数据
/// 该方法根据传入的标识符 `identifier` 获取对应的数据缓存。如果缓存文件过多，会进行清理。
/// @param identifier 用于生成唯一缓存路径的标识符，通常是一个字符串
/// @return 返回从缓存文件中读取的数据，如果没有找到对应的数据则返回 nil
+ (NSData *)zhh_getDataCacheWithIdentifier:(NSString *)identifier;

/// 使用指定的加密算法对数据进行加密或解密
/// @param operation 操作类型：加密（kCCEncrypt）或解密（kCCDecrypt）
/// @param algorithm 算法类型：AES、DES 或 3DES
/// @param key 密钥
/// @param iv 初始化向量（IV），可以为空
/// @return 返回加密或解密后的数据
- (NSData *)zhh_processDataWithOperation:(CCOperation)operation algorithm:(ZHHEncryptionAlgorithm)algorithm key:(NSString *)key iv:(NSData *)iv;
/// 将 NSData 转换为 UTF-8 编码的字符串
/// 该方法将当前的 NSData 对象内容尝试转换为 UTF-8 编码的 NSString 对象。
/// @return 如果转换成功，返回 UTF-8 编码的字符串；如果失败，返回 nil。
- (NSString *)zhh_UTF8String;

/**
 * 计算当前NSData对象的哈希值或HMAC值。
 *
 * 该方法可以计算标准哈希（如SHA1、SHA256），
 * 或者如果提供了密钥，则计算HMAC。如果`key`参数为`nil`，
 * 方法将执行标准的哈希计算；否则，使用提供的密钥计算HMAC。
 *
 * @param algorithm 哈希算法。支持的算法包括：
 *   - ZHHHashAlgorithmSHA1
 *   - ZHHHashAlgorithmSHA224
 *   - ZHHHashAlgorithmSHA256
 *   - ZHHHashAlgorithmSHA384
 *   - ZHHHashAlgorithmSHA512
 *   - ZHHHashAlgorithmMD5（已废弃；出于兼容性考虑，默认使用SHA256）
 * @param key 用于HMAC计算的密钥。如果为`nil`，则计算普通的哈希值。
 *
 * @return 一个`NSData`对象，包含计算出的哈希值或HMAC值。如果算法无效，则返回`nil`。
 *
 * @note 当使用MD5（`ZHHHashAlgorithmMD5`）时，由于MD5的加密漏洞，方法将自动切换为SHA256。
 * 由于 CC_MD5 已经在 iOS 13.0 中被弃用，并且它在安全性方面已经不再推荐使用，您应该使用更强大的哈希算法，例如 SHA-256，来代替 MD5
 *
     NSData *data = [@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding];
     NSData *key = [@"secret_key" dataUsingEncoding:NSUTF8StringEncoding];
     NSData *hmac = [data zhh_hashWithAlgorithm:ZHHHashAlgorithmSHA256 key:key];
     NSLog(@"HMAC SHA256: %@", hmac);
 */
- (NSData *)zhh_hashWithAlgorithm:(ZHHHashAlgorithm)algorithm key:(NSData * _Nullable)key;
@end

NS_ASSUME_NONNULL_END
