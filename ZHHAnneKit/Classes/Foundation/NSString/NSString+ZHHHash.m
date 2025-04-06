//
//  NSString+ZHHHash.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHHash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (ZHHHash)

/// 计算字符串的 MD5 哈希值（仅用于兼容服务端加密，CC_MD5 已被弃用）
- (NSString *)zhh_MD5String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
#pragma clang diagnostic pop

    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }

    return hash;
}

#pragma mark - SHA 系列哈希方法

/// 生成 SHA-1 哈希值
- (NSString *)zhh_sha1String {
    return [self zhh_hashStringUsingAlg:CC_SHA1_DIGEST_LENGTH function:CC_SHA1];
}

/// 生成 SHA-224 哈希值
- (NSString *)zhh_sha224String {
    return [self zhh_hashStringUsingAlg:CC_SHA224_DIGEST_LENGTH function:CC_SHA224];
}

/// 生成 SHA-256 哈希值zhh_sha256WithString
- (NSString *)zhh_sha256String {
    return [self zhh_hashStringUsingAlg:CC_SHA256_DIGEST_LENGTH function:CC_SHA256];
}

/// 生成 SHA-384 哈希值
- (NSString *)zhh_sha384String {
    return [self zhh_hashStringUsingAlg:CC_SHA384_DIGEST_LENGTH function:CC_SHA384];
}

/// 生成 SHA-512 哈希值
- (NSString *)zhh_sha512String {
    return [self zhh_hashStringUsingAlg:CC_SHA512_DIGEST_LENGTH function:CC_SHA512];
}

#pragma mark - HMAC 系列哈希方法

/// 使用 MD5 算法生成带密钥的 HMAC 值
- (NSString *)zhh_hmacMD5StringWithKey:(NSString *)key {
    return [self zhh_hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

/// 使用 SHA-1 算法生成带密钥的 HMAC 值
- (NSString *)zhh_hmacSHA1StringWithKey:(NSString *)key {
    return [self zhh_hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

/// 使用 SHA-224 算法生成带密钥的 HMAC 值
- (NSString *)zhh_hmacSHA224StringWithKey:(NSString *)key {
    return [self zhh_hmacStringUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

/// 使用 SHA-256 算法生成带密钥的 HMAC 值
- (NSString *)zhh_hmacSHA256StringWithKey:(NSString *)key {
    return [self zhh_hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

/// 使用 SHA-384 算法生成带密钥的 HMAC 值
- (NSString *)zhh_hmacSHA384StringWithKey:(NSString *)key {
    return [self zhh_hmacStringUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

/// 使用 SHA-512 算法生成带密钥的 HMAC 值
- (NSString *)zhh_hmacSHA512StringWithKey:(NSString *)key {
    return [self zhh_hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

#pragma mark - Helpers

/// 通用方法：根据指定的哈希算法生成哈希值
/// @param length 哈希值的字节长度（如 SHA1 为 20）
/// @param hashFunction 指定的哈希函数
- (NSString *)zhh_hashStringUsingAlg:(size_t)length function:(unsigned char *(*)(const void *, CC_LONG, unsigned char *))hashFunction {
    // 如果字符串为空，返回 nil
    if (!self.length) return nil;

    // 转换为 C 字符串
    const char *string = self.UTF8String;

    // 存储哈希值的字节数组
    unsigned char bytes[length];

    // 调用指定哈希函数
    hashFunction(string, (CC_LONG)strlen(string), bytes);

    // 将字节数组转换为十六进制字符串
    return [self zhh_stringFromBytes:bytes length:(int)length];
}

/// 通用方法：根据指定的 HMAC 算法生成带密钥的 HMAC 值
/// @param alg 指定的 HMAC 算法（如 kCCHmacAlgSHA256）
/// @param key 用于 HMAC 的密钥
- (NSString *)zhh_hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key {
    // 根据算法获取输出的哈希值长度
    size_t size = digestLengthForAlgorithm(alg);

    // 检查密钥、字符串是否为空，以及算法是否支持
    if (!size || !key.length || !self.length) return nil;

    // 获取密钥和消息数据
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];

    // 存储 HMAC 结果的字节数组
    unsigned char bytes[size];

    // 生成 HMAC 值
    CCHmac(alg, keyData.bytes, keyData.length, messageData.bytes, messageData.length, bytes);

    // 将字节数组转换为十六进制字符串
    return [self zhh_stringFromBytes:bytes length:(int)size];
}

/// 辅助方法：将字节数组转换为十六进制字符串
/// @param bytes 字节数组
/// @param length 字节数组的长度
- (NSString *)zhh_stringFromBytes:(unsigned char *)bytes length:(int)length {
    NSMutableString *string = [NSMutableString stringWithCapacity:length * 2];
    for (int i = 0; i < length; i++) {
        [string appendFormat:@"%02x", bytes[i]];
    }
    return string;
}

/// 根据 HMAC 算法获取哈希值的字节长度
/// @param alg 指定的 HMAC 算法
static size_t digestLengthForAlgorithm(CCHmacAlgorithm alg) {
    switch (alg) {
        case kCCHmacAlgMD5: return CC_MD5_DIGEST_LENGTH;
        case kCCHmacAlgSHA1: return CC_SHA1_DIGEST_LENGTH;
        case kCCHmacAlgSHA224: return CC_SHA224_DIGEST_LENGTH;
        case kCCHmacAlgSHA256: return CC_SHA256_DIGEST_LENGTH;
        case kCCHmacAlgSHA384: return CC_SHA384_DIGEST_LENGTH;
        case kCCHmacAlgSHA512: return CC_SHA512_DIGEST_LENGTH;
        default: return 0; // 未知算法返回 0
    }
}

/// AES256 加密
/// @param key 密钥
/// @return 加密后的 Base64 字符串
- (NSString *)zhh_encryptedStringUsingAES256WithKey:(NSString *)key {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    NSData *encryptedData = [NSString zhh_encryptedDataUsingAES256:data key:key];
    return encryptedData ? [encryptedData base64EncodedStringWithOptions:0] : @"";
}

/// AES256 解密
/// @param key 密钥
/// @return 解密后的字符串
- (NSString *)zhh_decryptedStringUsingAES256WithKey:(NSString *)key {
    NSData *base64DecodedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [NSString zhh_decryptedDataUsingAES256:base64DecodedData key:key];
    return decryptedData ? [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] : @"";
}

/// AES256 加密 - 辅助方法
/// @param data 需要加密的原始数据
/// @param key 密钥
/// @return 加密后的数据
+ (NSData *)zhh_encryptedDataUsingAES256:(NSData *)data key:(NSString *)key {
    if (!data || !key) return nil;

    char keyPtr[kCCKeySizeAES256 + 1] = {0};
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(
        kCCEncrypt,
        kCCAlgorithmAES,
        kCCOptionPKCS7Padding | kCCOptionECBMode,
        keyPtr,
        kCCKeySizeAES256,
        NULL,
        data.bytes,
        data.length,
        buffer,
        bufferSize,
        &numBytesEncrypted
    );

    NSData *result = (cryptStatus == kCCSuccess) ? [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] : nil;
    if (!result) free(buffer);

    return result;
}

/// AES256 解密 - 辅助方法
/// @param data 需要解密的加密数据
/// @param key 密钥
/// @return 解密后的数据
+ (NSData *)zhh_decryptedDataUsingAES256:(NSData *)data key:(NSString *)key {
    if (!data || !key) return nil;

    char keyPtr[kCCKeySizeAES256 + 1] = {0};
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(
        kCCDecrypt,
        kCCAlgorithmAES,
        kCCOptionPKCS7Padding | kCCOptionECBMode,
        keyPtr,
        kCCKeySizeAES256,
        NULL,
        data.bytes,
        data.length,
        buffer,
        bufferSize,
        &numBytesDecrypted
    );

    NSData *result = (cryptStatus == kCCSuccess) ? [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] : nil;
    if (!result) free(buffer);

    return result;
}
@end
