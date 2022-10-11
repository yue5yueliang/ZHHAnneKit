//
//  NSData+ZHHHash.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSData+ZHHHash.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation NSData (ZHHHash)
/**
 *  @brief  md5 NSData
 */
- (NSData *)zhh_md5Data {
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}
/**
 *  @brief  sha1Data NSData
 */
- (NSData *)zhh_sha1Data {
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}
/**
 *  @brief  sha256Data NSData
 */
- (NSData *)zhh_sha256Data {
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}
/**
 *  @brief  sha512Data NSData
 */
- (NSData *)zhh_sha512Data {
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}
/**
 *  @brief  md5 NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacMD5DataWithKey:(NSData *)key {
    return [self zhh_hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}
/**
 *  @brief  sha1Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacSHA1DataWithKey:(NSData *)key {
    return [self zhh_hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}
/**
 *  @brief  sha256Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacSHA256DataWithKey:(NSData *)key {
    return [self zhh_hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}
/**
 *  @brief  sha512Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacSHA512DataWithKey:(NSData *)key {
    return [self zhh_hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}


- (NSData *)zhh_hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}
@end
