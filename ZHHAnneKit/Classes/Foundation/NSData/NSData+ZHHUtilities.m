//
//  NSData+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSData+ZHHUtilities.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (ZHHUtilities)
/// 将 APNS NSData 类型的 token 转换为字符串格式
/// 该方法将 APNS 返回的 NSData 类型的 token 转换为一个字符串，适用于 iOS 13 及更高版本。
/// @return 返回格式化后的字符串类型 token。如果数据格式不匹配，则返回空字符串。
- (NSString *)zhh_APNSToken {
    // 确保数据类型为 NSData
    if (![self isKindOfClass:[NSData class]]) {
        return @""; // 如果不是 NSData 类型，直接返回空字符串
    }

    // 获取 NSData 的长度和字节内容
    NSUInteger len = [self length];
    char *chars = (char *)[self bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    // 遍历 NSData，将每个字节转换为 2 位十六进制字符
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString; // 返回格式化后的十六进制字符串
}

/// 获取应用的缓存路径
/// 该方法返回应用中用于存储缓存数据的目录路径。路径是通过获取应用的 Library 目录下的 Caches 目录，并在其中创建名为 "ZHHDataCache" 的文件夹。若该文件夹不存在，则会自动创建。
/// @return 返回缓存目录路径字符串。如果目录不存在，方法会创建它并返回路径。
+ (NSString *)zhh_cachePath {
    // 获取 Library 目录路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    // 拼接 Caches 和 ZHHDataCache 文件夹路径
    path = [path stringByAppendingPathComponent:@"Caches"];
    path = [path stringByAppendingPathComponent:@"ZHHDataCache"];
    
    // 检查路径是否存在，如果不存在则创建该目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        // 错误处理可根据需要进行日志记录或异常抛出
        if (error) {
            NSLog(@"ZHHAnneKit 警告: 创建缓存目录失败: %@", error.localizedDescription);
        }
    }
    
    // 返回缓存路径
    return path;
}

/// 生成字符串的 SHA-256 哈希值
/// 该方法接收一个字符串并返回该字符串的 SHA-256 哈希值，结果以小写字母形式返回。
/// 由于 CC_MD5 已经在 iOS 13.0 中被弃用，并且它在安全性方面已经不再推荐使用，您应该使用更强大的哈希算法，例如 SHA-256，来代替 MD5
/// @param string 要进行 SHA-256 哈希运算的输入字符串
/// @return 返回字符串的 SHA-256 哈希值，作为一个十六进制字符串
+ (NSString *)zhh_sha256WithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *sha256Data = [data zhh_hashWithAlgorithm:ZHHHashAlgorithmSHA256 key:nil];
    
    // 将 NSData 转换为十六进制字符串
    NSMutableString *hash = [NSMutableString string];
    const unsigned char *bytes = sha256Data.bytes;
    for (int i = 0; i < sha256Data.length; i++) {
        [hash appendFormat:@"%02x", bytes[i]];  // 十六进制格式，小写
    }
    return hash;
}
/// 生成基于字符串的唯一数据存储路径
/// 该方法通过对输入字符串进行 SHA-256 哈希计算，然后将哈希值作为文件名拼接到缓存目录路径下，最终生成唯一的文件存储路径。
///
/// @param string 输入的字符串，作为文件路径生成的依据
/// @return 返回生成的完整文件路径，通常用于存储数据
+ (NSString *)zhh_createDataPathWithString:(NSString *)string {
    // 获取应用缓存目录路径
    NSString *path = [NSData zhh_cachePath];
    // 对输入字符串进行 SHA-256 哈希计算，得到一个唯一的文件名
    path = [path stringByAppendingPathComponent:[self zhh_sha256WithString:string]];
    // 返回最终的文件路径
    return path;
}

/// 将数据保存到本地缓存路径
/// 该方法将数据写入到一个由传入的标识符生成的文件路径中，并且保证文件写入是原子性的。
/// @param identifier 用于生成唯一缓存路径的标识符，通常是一个字符串
- (void)zhh_saveDataCacheWithIdentifier:(NSString *)identifier {
    // 生成数据缓存路径，基于提供的标识符
    NSString *path = [NSData zhh_createDataPathWithString:identifier];
    // 将当前数据对象保存到指定路径，采用原子性写入，确保写入过程中不会发生中断
    [self writeToFile:path atomically:YES];
}

/// 从本地缓存中读取数据
/// 该方法根据传入的标识符 `identifier` 获取对应的数据缓存。如果缓存文件过多，会进行清理。
/// @param identifier 用于生成唯一缓存路径的标识符，通常是一个字符串
/// @return 返回从缓存文件中读取的数据，如果没有找到对应的数据则返回 nil
+ (NSData *)zhh_getDataCacheWithIdentifier:(NSString *)identifier {
    static BOOL isCheckedCacheDisk = NO;
    // 确保缓存清理操作只执行一次
    if (!isCheckedCacheDisk) {
        NSFileManager *manager = [NSFileManager defaultManager];
        // 获取缓存目录下的所有文件
        NSArray *contents = [manager contentsOfDirectoryAtPath:[self zhh_cachePath] error:nil];
        // 如果缓存文件数量超过最大限制，则删除缓存目录中的所有文件
        if (contents.count >= 100) {
            [manager removeItemAtPath:[self zhh_cachePath] error:nil];
        }
        // 标记缓存已检查
        isCheckedCacheDisk = YES;
    }
    // 生成数据缓存文件的路径
    NSString *path = [self zhh_createDataPathWithString:identifier];
    // 从文件中读取数据并返回
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

/// 修复加密算法所需的密钥和初始向量长度
/// 根据选择的加密算法，调整密钥和初始化向量（IV）的长度，以确保它们符合算法的要求。
/// @param algorithm 加密算法（如 AES, DES 等）
/// @param keyData  密钥数据（根据算法调整长度）
/// @param ivData   初始化向量数据（IV，长度与密钥长度一致）
static void zhh_fixKeyLengths(CCAlgorithm algorithm, NSMutableData *keyData, NSMutableData *ivData) {
    NSUInteger keyLength = [keyData length];
    // 根据选择的算法修正密钥长度
    switch (algorithm) {
        case kCCAlgorithmAES128:
            // AES128的密钥长度应该为16字节（128位）
            if (keyLength <= 16) {
                [keyData setLength:16];  // 小于等于16，填充至16字节
            } else if (keyLength > 16 && keyLength <= 24) {
                [keyData setLength:24];  // 大于16小于等于24，填充至24字节
            } else {
                [keyData setLength:32];  // 大于24，填充至32字节
            }
            break;
        case kCCAlgorithmDES:
            // DES的密钥长度固定为8字节（64位）
            [keyData setLength:8];
            break;
        case kCCAlgorithm3DES:
            // 3DES的密钥长度固定为24字节（192位）
            [keyData setLength:24];
            break;
        case kCCAlgorithmCAST:
            // CAST的密钥长度应为5到16字节之间
            if (keyLength < 5) {
                [keyData setLength:5];  // 小于5，填充至5字节
            } else if (keyLength > 16) {
                [keyData setLength:16];  // 大于16，填充至16字节
            }
            break;
        case kCCAlgorithmRC4:
            // RC4的密钥长度最大为512字节
            if (keyLength > 512) {
                [keyData setLength:512];  // 大于512，限制为512字节
            }
            break;
        default:
            break;
    }
    // 将初始向量的长度设置为与密钥相同
    [ivData setLength:[keyData length]];
}

/// 使用指定的加密算法对数据进行加密或解密
/// @param operation 操作类型：加密（kCCEncrypt）或解密（kCCDecrypt）
/// @param algorithm 算法类型：AES、DES 或 3DES
/// @param key 密钥
/// @param iv 初始化向量（IV），可以为空
/// @return 返回加密或解密后的数据
- (NSData *)zhh_processDataWithOperation:(CCOperation)operation algorithm:(ZHHEncryptionAlgorithm)algorithm key:(NSString *)key iv:(NSData *)iv {
    // 对应的底层算法
    CCAlgorithm ccAlgorithm;
    switch (algorithm) {
        case ZHHEncryptionAlgorithmAES:
            ccAlgorithm = kCCAlgorithmAES128;
            break;
        case ZHHEncryptionAlgorithmDES:
            ccAlgorithm = kCCAlgorithmDES;
            break;
        case ZHHEncryptionAlgorithm3DES:
            ccAlgorithm = kCCAlgorithm3DES;
            break;
        default:
            return nil; // 未知算法
    }
    
    // 将密钥和初始化向量处理为符合算法要求的长度
    NSMutableData *keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSMutableData *ivData = [iv mutableCopy];
    zhh_fixKeyLengths(ccAlgorithm, keyData, ivData);
    
    // 计算输出缓冲区大小
    size_t dataMoved;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    NSMutableData *outputData = [NSMutableData dataWithLength:bufferSize];
    
    // 执行加解密操作
    CCCryptorStatus result = CCCrypt(operation,
                                     ccAlgorithm,
                                     iv ? kCCOptionPKCS7Padding : (kCCOptionPKCS7Padding | kCCOptionECBMode),
                                     keyData.bytes,
                                     keyData.length,
                                     ivData.bytes,
                                     self.bytes,
                                     self.length,
                                     outputData.mutableBytes,
                                     outputData.length,
                                     &dataMoved);
    
    if (result == kCCSuccess) {
        outputData.length = dataMoved;
        return outputData;
    }
    return nil; // 失败返回 nil
}

/// 将 NSData 转换为 UTF-8 编码的字符串
/// 该方法将当前的 NSData 对象内容尝试转换为 UTF-8 编码的 NSString 对象。
/// @return 如果转换成功，返回 UTF-8 编码的字符串；如果失败，返回 nil。
- (NSString *)zhh_UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

/**
 * @brief 通用哈希方法，可同时支持普通哈希和 HMAC 运算。
 *
 * @param algorithm 哈希算法
 * @param key       密钥（传 nil 则为普通哈希运算；非 nil 则为 HMAC 运算）
 * @return 计算结果数据
 */
- (NSData *)zhh_hashWithAlgorithm:(ZHHHashAlgorithm)algorithm key:(nullable NSData *)key {
    CCHmacAlgorithm hmacAlg;
    size_t hashLength;

    // 确定算法及输出长度
    switch (algorithm) {
        case ZHHHashAlgorithmMD5:
            hmacAlg = kCCHmacAlgMD5;
            hashLength = CC_MD5_DIGEST_LENGTH;
            break;
        case ZHHHashAlgorithmSHA1:
            hmacAlg = kCCHmacAlgSHA1;
            hashLength = CC_SHA1_DIGEST_LENGTH;
            break;
        case ZHHHashAlgorithmSHA224:
            hmacAlg = kCCHmacAlgSHA224;
            hashLength = CC_SHA224_DIGEST_LENGTH;
            break;
        case ZHHHashAlgorithmSHA256:
            hmacAlg = kCCHmacAlgSHA256;
            hashLength = CC_SHA256_DIGEST_LENGTH;
            break;
        case ZHHHashAlgorithmSHA384:
            hmacAlg = kCCHmacAlgSHA384;
            hashLength = CC_SHA384_DIGEST_LENGTH;
            break;
        case ZHHHashAlgorithmSHA512:
            hmacAlg = kCCHmacAlgSHA512;
            hashLength = CC_SHA512_DIGEST_LENGTH;
            break;
        default:
            return nil; // 不支持的算法
    }

    unsigned char result[hashLength];

    if (key) {
        // HMAC 计算
        CCHmac(hmacAlg, key.bytes, key.length, self.bytes, self.length, result);
    } else {
        // 普通哈希计算
        switch (algorithm) {
            case ZHHHashAlgorithmSHA1:
                CC_SHA1(self.bytes, (CC_LONG)self.length, result);
                break;
            case ZHHHashAlgorithmSHA224:
                CC_SHA224(self.bytes, (CC_LONG)self.length, result);
                break;
            case ZHHHashAlgorithmMD5: // 使用 SHA256 替代 MD5
            case ZHHHashAlgorithmSHA256:
                CC_SHA256(self.bytes, (CC_LONG)self.length, result);
                break;
            case ZHHHashAlgorithmSHA384:
                CC_SHA384(self.bytes, (CC_LONG)self.length, result);
                break;
            case ZHHHashAlgorithmSHA512:
                CC_SHA512(self.bytes, (CC_LONG)self.length, result);
                break;
            default:
                return nil;
        }
    }

    return [NSData dataWithBytes:result length:hashLength];
}
@end
