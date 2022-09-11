//
//  NSString+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHKit)
/// 11位 手机号处理 中间 6 位掩码 (其实能处理11位的字符串)
- (NSString *)phoneNoMask6;

/// 11位 手机号处理 中间 4 位掩码 (其实能处理11位的字符串)
- (NSString *)phoneNoMask4;
/// 身份证号掩码,只保留第一位和最后一位 (字符串长度大于15就满足格式)
- (NSString *)idNumberMask;

/// 确定它是否为SHA512加密字符串
@property (nonatomic, assign, readonly) BOOL verifySHA512;

/// Hash encryption
- (NSString *)zhh_SHA512String;

- (NSString *)zhh_SHA256String;

- (NSString *)zhh_MD5String;

/// BASE 64 解码的字符串内容
- (nullable NSString *)zhh_base64DecodeString;
/// BASE 64 编码的字符串内容
- (nullable NSString *)zhh_base64EncodeString;

/// AES256 加密
/// @param key key
- (NSString *)zhh_AES256EncryptWithKey:(NSString *)key;
+ (nullable NSData *)zhh_AES256EncryptData:(NSData *)data key:(NSString *)key;

/// AES256 解密
/// @param key key
- (NSString *)zhh_AES256DecryptWithKey:(NSString *)key;
+ (nullable NSData *)zhh_AES256DecryptData:(NSData *)data key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
