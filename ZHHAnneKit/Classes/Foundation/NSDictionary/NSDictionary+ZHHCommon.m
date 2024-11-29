//
//  NSDictionary+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDictionary+ZHHCommon.h"

@implementation NSDictionary (ZHHCommon)
/// 将URL查询参数字符串转换为NSDictionary
/// @discussion 该方法接受一个URL查询字符串（例如："key1=value1&key2=value2"），并将其转换为NSDictionary对象。
/// 字符串中的每个键值对会被分解成字典的键和值。值将经过百分号编码解码。
/// 如果某个参数缺少值，或者格式不符合 "key=value" 规范，则会被忽略。
/// @param query URL查询参数字符串，例如："key1=value1&key2=value2"
/// @return 返回转换后的NSDictionary，包含所有键值对
+ (NSDictionary *)zhh_dictionaryWithURLQuery:(NSString *)query {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // 将查询参数按 "&" 分隔开
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    
    // 遍历每个参数，处理键值对
    for(NSString *parameter in parameters) {
        // 将每个参数按 "=" 分隔
        NSArray *contents = [parameter componentsSeparatedByString:@"="];
        
        // 如果格式正确，且包含键和值
        if([contents count] == 2) {
            NSString *key = [contents objectAtIndex:0];
            NSString *value = [contents objectAtIndex:1];
            
            // 对值进行百分号解码
            value = [value stringByRemovingPercentEncoding];
            
            // 如果键和值都存在，添加到字典中
            if (key && value) {
                [dict setObject:value forKey:key];
            }
        }
    }
    
    // 返回转换后的字典
    return [NSDictionary dictionaryWithDictionary:dict];
}

/// 将NSDictionary转换为URL查询参数字符串
/// @discussion 该方法将当前字典中的键值对转换为URL查询参数字符串。每个键值对会被格式化为 "key=value"，然后用 "&" 分隔开。
/// 如果字典中的值包含特殊字符，会进行百分号编码。
/// @return 返回格式化后的URL查询参数字符串
- (NSString *)zhh_queryStringFromDictionary {
    NSMutableString *string = [NSMutableString string];
    // 遍历字典的每个键
    for (NSString *key in [self allKeys]) {
        // 如果字符串非空，添加 "&" 分隔符
        if ([string length]) {
            [string appendString:@"&"];
        }
        
        // 对值进行百分号编码
        NSString *escaped = [[[self objectForKey:key] description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet   characterSetWithCharactersInString:@"!$&'()*+-./:;=?@_~%#[]"]];
        
        // 将键值对按 "key=value" 格式添加到字符串中
        [string appendFormat:@"%@=%@", key, escaped];
    }
    
    // 返回构建好的URL查询参数字符串
    return string;
}

/**
 * @brief 将NSDictionary转换为XML字符串
 *
 * @discussion 该方法将当前字典转换为XML格式字符串，默认无根元素和声明。可以通过调用其他方法自定义根元素和XML声明。
 * @return xml格式的字符串
 */
- (NSString *)zhh_xmlString {
    return [self zhh_xmlStringWithRootElement:nil declaration:nil];
}

/**
 * @brief 使用默认XML声明和根元素生成XML字符串
 *
 * @discussion 该方法会为生成的XML字符串添加默认声明（`<?xml version="1.0" encoding="utf-8"?>`）以及指定的根元素标签。
 * @param rootElement 根元素标签名
 * @return 包含默认声明和根元素的XML字符串
 */
- (NSString *)zhh_xmlStringDefaultDeclarationWithRootElement:(NSString *)rootElement {
    return [self zhh_xmlStringWithRootElement:rootElement declaration:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
}

/**
 * @brief 自定义生成XML字符串
 *
 * @discussion 该方法允许指定XML的根元素标签和XML声明。适用于需要灵活控制XML格式的场景。
 * @param rootElement 根元素标签名，传 `nil` 时不包含根元素。
 * @param declaration XML声明部分，例如 `<?xml version="1.0" encoding="utf-8"?>`，传 `nil` 时不添加声明。
 * @return 返回构建的XML字符串
 */
- (NSString *)zhh_xmlStringWithRootElement:(NSString * _Nullable)rootElement declaration:(NSString * _Nullable)declaration {
    // 初始化XML字符串
    NSMutableString *xml = [[NSMutableString alloc] initWithString:@""];
    
    // 添加声明
    if (declaration) {
        [xml appendString:declaration];
    }
    
    // 添加根元素起始标签
    if (rootElement) {
        [xml appendString:[NSString stringWithFormat:@"<%@>", rootElement]];
    }
    
    // 递归构建节点内容
    [self zhh_convertNode:self withString:xml andTag:nil];
    
    // 添加根元素结束标签
    if (rootElement) {
        [xml appendString:[NSString stringWithFormat:@"</%@>", rootElement]];
    }
    
    // 替换特殊字符以符合XML标准
    NSString *finalXML = [xml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    return finalXML;
}

#pragma mark - XML 相关方法

/**
 * @brief 将字典或数组节点转换为XML字符串
 *
 * @discussion 递归地将字典或数组中的内容转换为XML节点。如果是字典，会处理键值对；如果是数组，会处理每个元素。
 * @param node 要转换的节点，可以是字典、数组或基本类型
 * @param xml 用于拼接生成XML内容的可变字符串
 * @param tag 当前节点的标签名，若为nil，则直接处理为字典的根节点
 */
- (void)zhh_convertNode:(id)node withString:(NSMutableString *)xml andTag:(NSString *)tag {
    if ([node isKindOfClass:[NSDictionary class]] && !tag) {
        // 如果节点是字典且无标签，递归处理所有键值对
        NSArray *keys = [node allKeys];
        for (NSString *key in keys) {
            [self zhh_convertNode:[node objectForKey:key] withString:xml andTag:key];
        }
    } else if ([node isKindOfClass:[NSArray class]]) {
        // 如果节点是数组，递归处理每个元素，保持相同标签
        for (id value in node) {
            [self zhh_convertNode:value withString:xml andTag:tag];
        }
    } else {
        // 为基本节点或具体标签拼接起始标签
        [xml appendString:[NSString stringWithFormat:@"<%@>", tag]];

        if ([node isKindOfClass:[NSString class]]) {
            // 如果是字符串类型，直接拼接内容
            [xml appendString:node];
        } else if ([node isKindOfClass:[NSDictionary class]]) {
            // 如果是字典，递归处理字典的内容
            [self zhh_convertNode:node withString:xml andTag:nil];
        }

        // 拼接结束标签
        [xml appendString:[NSString stringWithFormat:@"</%@>", tag]];
    }
}

#pragma mark - Plist 相关方法

/**
 * @brief 将字典转换为Plist格式的字符串
 *
 * @discussion 调用内部方法生成Plist数据并转化为字符串，用于调试或保存为可读配置文件。
 * @return Plist格式的字符串，如果转换失败则返回nil
 */
- (NSString *)zhh_plistString {
    NSString *result = [[NSString alloc] initWithData:[self zhh_plistData] encoding:NSUTF8StringEncoding];
    return result;
}

/**
 * @brief 将字典转换为Plist格式的数据
 *
 * @discussion 使用`NSPropertyListSerialization`将字典序列化为Plist XML格式的数据。
 * @return Plist格式的数据，如果转换失败则返回nil
 */
- (NSData *)zhh_plistData {
    NSError *error = nil;
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
}
@end
