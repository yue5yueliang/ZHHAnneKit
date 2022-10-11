//
//  NSData+ZHHHash.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ZHHHash)
/**
 *  @brief  md5 NSData
 */
@property (readonly) NSData *zhh_md5Data;
/**
 *  @brief  sha1Data NSData
 */
@property (readonly) NSData *zhh_sha1Data;
/**
 *  @brief  sha256Data NSData
 */
@property (readonly) NSData *zhh_sha256Data;
/**
 *  @brief  sha512Data NSData
 */
@property (readonly) NSData *zhh_sha512Data;

/**
 *  @brief  md5 NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacMD5DataWithKey:(NSData *)key;
/**
 *  @brief  sha1Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacSHA1DataWithKey:(NSData *)key;
/**
 *  @brief  sha256Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacSHA256DataWithKey:(NSData *)key;
/**
 *  @brief  sha512Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)zhh_hmacSHA512DataWithKey:(NSData *)key;
@end

NS_ASSUME_NONNULL_END
