//
//  NSData+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSData+ZHHCommon.h"
#import <zlib.h>
#import <dlfcn.h>

@implementation NSData (ZHHCommon)
static void *zhh_libzOpen(void) {
    static void *libz;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libz = dlopen("/usr/lib/libz.dylib", RTLD_LAZY);
    });
    return libz;
}

/// 对 NSData 进行 gzip 压缩
/// 使用指定的压缩等级将数据压缩为 gzip 格式。如果数据已是 gzip 格式，则直接返回原数据。
/// @param level 压缩级别，范围为 0.0f（无压缩）到 1.0f（最大压缩），-1 表示使用默认压缩级别。
/// @return 压缩后的 gzip 数据。如果压缩失败或输入数据为空，返回原数据。
- (NSData *)zhh_gzippedDataWithCompressionLevel:(float)level {
    // 如果数据为空或已经是 gzip 格式，直接返回
    if (self.length == 0 || [self zhh_isGzippedData]) {
        return self;
    }

    // 动态加载 libz 库
    void *libz = zhh_libzOpen();
    if (!libz) {
        return self; // 如果动态库加载失败，返回原数据
    }

    // 动态解析 libz 函数指针
    int (*deflateInit2_)(z_streamp, int, int, int, int, int, const char *, int) =
    (int (*)(z_streamp, int, int, int, int, int, const char *, int))dlsym(libz, "deflateInit2_");
    int (*deflate)(z_streamp, int) = (int (*)(z_streamp, int))dlsym(libz, "deflate");
    int (*deflateEnd)(z_streamp) = (int (*)(z_streamp))dlsym(libz, "deflateEnd");

    if (!deflateInit2_ || !deflate || !deflateEnd) {
        return self; // 如果函数加载失败，返回原数据
    }

    // 初始化 z_stream 结构
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)(void *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    static const NSUInteger ChunkSize = 16384; // 每次压缩的块大小
    NSMutableData *output = nil;
    int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)(roundf(level * 9));

    // 初始化压缩流
    if (deflateInit2_(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY, ZLIB_VERSION, (int)sizeof(z_stream)) == Z_OK) {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += ChunkSize; // 动态扩展缓冲区大小
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH); // 执行压缩操作
        }
        deflateEnd(&stream); // 释放压缩流
        output.length = stream.total_out; // 设置最终数据长度
    }

    return output ?: self; // 如果压缩失败，返回原数据
}

/// 对 NSData 进行默认 gzip 压缩
/// 使用 zlib 默认的压缩级别对数据进行 gzip 压缩。
/// @return 压缩后的 gzip 数据。如果数据为空或已是 gzip 格式，则直接返回原数据。
- (NSData *)zhh_gzippedData {
    return [self zhh_gzippedDataWithCompressionLevel:-1.0f]; // -1.0f 表示使用 zlib 默认压缩级别
}

/// 对 gzip 压缩的 NSData 数据进行解压
/// 使用 zlib 的 inflate 功能解压 gzip 数据。
/// @return 解压后的数据。如果数据为空或不是 gzip 格式，直接返回原数据。
- (NSData *)zhh_gunzippedData {
    // 如果数据为空或者不是 gzip 格式，直接返回原数据
    if (self.length == 0 || ![self zhh_isGzippedData]) {
        return self;
    }

    // 加载 libz 库
    void *libz = zhh_libzOpen();
    int (*inflateInit2_)(z_streamp, int, const char *, int) =
    (int (*)(z_streamp, int, const char *, int))dlsym(libz, "inflateInit2_");
    int (*inflate)(z_streamp, int) = (int (*)(z_streamp, int))dlsym(libz, "inflate");
    int (*inflateEnd)(z_streamp) = (int (*)(z_streamp))dlsym(libz, "inflateEnd");

    // 初始化 zlib 解压流
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uInt)self.length; // 输入数据大小
    stream.next_in = (Bytef *)self.bytes; // 输入数据指针
    stream.total_out = 0; // 输出数据大小累计
    stream.avail_out = 0; // 输出缓冲区剩余大小

    NSMutableData *output = nil;
    // 47 = 自动检测 gzip 和 zlib 格式
    if (inflateInit2(&stream, 47) == Z_OK) {
        int status = Z_OK;
        // 初始化输出缓冲区，初始大小为原数据的两倍
        output = [NSMutableData dataWithCapacity:self.length * 2];
        while (status == Z_OK) {
            // 如果输出缓冲区空间不足，则增加一半大小
            if (stream.total_out >= output.length) {
                output.length += self.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out; // 输出位置指针
            stream.avail_out = (uInt)(output.length - stream.total_out); // 剩余输出缓冲区大小
            status = inflate(&stream, Z_SYNC_FLUSH); // 解压操作
        }
        // 结束解压
        if (inflateEnd(&stream) == Z_OK) {
            // 如果解压完成，调整输出数据大小
            if (status == Z_STREAM_END) {
                output.length = stream.total_out;
            }
        }
    }
    return output;
}
/// 判断 NSData 是否为 gzip 格式的数据
/// 根据 gzip 文件的魔数（magic number）检测数据格式。
/// gzip 的文件头以 0x1F 0x8B 开头。
/// @return 如果数据是 gzip 格式返回 YES，否则返回 NO。
- (BOOL)zhh_isGzippedData {
    const UInt8 *bytes = (const UInt8 *)self.bytes; // 获取 NSData 的字节数据
    return (self.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B); // 检查文件头的魔数
}

@end
