//
//  NSData+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ZHHCommon)
/// 对 NSData 进行 gzip 压缩
/// 使用指定的压缩等级将数据压缩为 gzip 格式。如果数据已是 gzip 格式，则直接返回原数据。
/// @param level 压缩级别，范围为 0.0f（无压缩）到 1.0f（最大压缩），-1 表示使用默认压缩级别。
/// @return 压缩后的 gzip 数据。如果压缩失败或输入数据为空，返回原数据。
- (NSData *)zhh_gzippedDataWithCompressionLevel:(float)level;
/// 对 NSData 进行默认 gzip 压缩
/// 使用 zlib 默认的压缩级别对数据进行 gzip 压缩。
/// @return 压缩后的 gzip 数据。如果数据为空或已是 gzip 格式，则直接返回原数据。
/**
     NSData *originalData = [@"这是一段需要压缩的测试字符串" dataUsingEncoding:NSUTF8StringEncoding];
     NSData *compressedData = [originalData zhh_gzippedData];
     NSLog(@"原始数据大小: %lu 字节", (unsigned long)originalData.length);
     NSLog(@"压缩后的数据大小: %lu 字节", (unsigned long)compressedData.length);
 */
- (NSData *)zhh_gzippedData;
/// 对 gzip 压缩的 NSData 数据进行解压
/// 使用 zlib 的 inflate 功能解压 gzip 数据。
/// @return 解压后的数据。如果数据为空或不是 gzip 格式，直接返回原数据。
/**
     NSData *compressedData = ... // gzip 压缩数据
     NSData *decompressedData = [compressedData zhh_gunzippedData];
     if (decompressedData) {
         NSString *result = [[NSString alloc] initWithData:decompressedData encoding:NSUTF8StringEncoding];
         NSLog(@"解压结果: %@", result);
     } else {
         NSLog(@"解压失败或数据不是 gzip 格式");
     }
 */
- (NSData *)zhh_gunzippedData;
/// 判断 NSData 是否为 gzip 格式的数据
/// 根据 gzip 文件的魔数（magic number）检测数据格式。
/// gzip 的文件头以 0x1F 0x8B 开头。
/// @return 如果数据是 gzip 格式返回 YES，否则返回 NO。
- (BOOL)zhh_isGzippedData;
@end

NS_ASSUME_NONNULL_END
