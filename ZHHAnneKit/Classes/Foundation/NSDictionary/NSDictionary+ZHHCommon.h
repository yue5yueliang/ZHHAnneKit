//
//  NSDictionary+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

//  在线XML、JSON数据互转
//  http://www.bejson.com/xml2json/

//  XML 新手入门基础知识
//  http://www.ibm.com/developerworks/cn/xml/x-newxml/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZHHCommon)
/// 将URL查询参数字符串转换为NSDictionary
/// @discussion 该方法接受一个URL查询字符串（例如："key1=value1&key2=value2"），并将其转换为NSDictionary对象。
/// 字符串中的每个键值对会被分解成字典的键和值。值将经过百分号编码解码。
/// 如果某个参数缺少值，或者格式不符合 "key=value" 规范，则会被忽略。
/// @param query URL查询参数字符串，例如："key1=value1&key2=value2"
/// @return 返回转换后的NSDictionary，包含所有键值对
+ (NSDictionary *)zhh_dictionaryWithURLQuery:(NSString *)query;
/// 将NSDictionary转换为URL查询参数字符串
/// @discussion 该方法将当前字典中的键值对转换为URL查询参数字符串。每个键值对会被格式化为 "key=value"，然后用 "&" 分隔开。
/// 如果字典中的值包含特殊字符，会进行百分号编码。
/// @return 返回格式化后的URL查询参数字符串
- (NSString *)zhh_queryStringFromDictionary;

/**
 * @brief 将NSDictionary转换为XML字符串
 *
 * @discussion 该方法将当前字典转换为XML格式字符串，默认无根元素和声明。可以通过调用其他方法自定义根元素和XML声明。
 * @return xml格式的字符串
 */
- (NSString *)zhh_xmlString;

/**
 * @brief 使用默认XML声明和根元素生成XML字符串
 *
 * @discussion 该方法会为生成的XML字符串添加默认声明（`<?xml version="1.0" encoding="utf-8"?>`）以及指定的根元素标签。
 * @param rootElement 根元素标签名
 * @return 包含默认声明和根元素的XML字符串
 */
- (NSString *)zhh_xmlStringDefaultDeclarationWithRootElement:(NSString *)rootElement;

/**
 * @brief 自定义生成XML字符串
 *
 * @discussion 该方法允许指定XML的根元素标签和XML声明。适用于需要灵活控制XML格式的场景。
 * @param rootElement 根元素标签名，传 `nil` 时不包含根元素。
 * @param declaration XML声明部分，例如 `<?xml version="1.0" encoding="utf-8"?>`，传 `nil` 时不添加声明。
 * @return 返回构建的XML字符串
 */
- (NSString *)zhh_xmlStringWithRootElement:(NSString * _Nullable)rootElement declaration:(NSString * _Nullable)declaration;
/**
 * @brief 将字典转换为Plist格式的字符串
 *
 * @discussion 调用内部方法生成Plist数据并转化为字符串，用于调试或保存为可读配置文件。
 * @return Plist格式的字符串，如果转换失败则返回nil
 */
- (NSString *)zhh_plistString;
/**
 * @brief 将字典转换为Plist格式的数据
 *
 * @discussion 使用`NSPropertyListSerialization`将字典序列化为Plist XML格式的数据。
 * @return Plist格式的数据，如果转换失败则返回nil
 */
- (NSData *)zhh_plistData;
@end

NS_ASSUME_NONNULL_END
