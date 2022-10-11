//
//  NSDictionary+ZHHXML.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//
/**
 NSDictionary *dic = @{@"name":@"zhangsan",@"data1":@[@{@"secondname":@"zzzz"},@[@"cat1",@"cat2",@"cat3"],@"data2",@"data3",@"data4"]};


 //将NSDictionary转换成XML字符串 不带XML声明 不带根节点
 NSString *xml = [dic zhh_XMLString];
 //将NSDictionary转换成XML字符串, 默认 <?xml version=\"1.0\" encoding=\"utf-8\"?> 声明   自定义根节点
 NSString *xml2 = [dic zhh_XMLStringDefaultDeclarationWithRootElement:@"dict"];
 //将NSDictionary转换成XML字符串, 自定义根节点  自定义xml声明
 NSString *xml3 = [dic zhh_XMLStringWithRootElement:@"dict" declaration:@"<?xml version=\"1.0\"?>"];
 //转换为plist
 NSString *plist = [dic zhh_plistString];


 NSLog(@"%@",xml);
 NSLog(@"==============================");
 NSLog(@"%@",xml2);
 NSLog(@"==============================");
 NSLog(@"%@",xml3);
 NSLog(@"==============================");
 NSLog(@"%@",plist);


 <name>zhangsan</name><data1><secondname>zzzz</secondname></data1><data1>cat1</data1><data1>cat2</data1><data1>cat3</data1><data1>data2</data1><data1>data3</data1><data1>data4</data1>
 ==============================
 <?xml version="1.0" encoding="utf-8"?><dict><name>zhangsan</name><data1><secondname>zzzz</secondname></data1><data1>cat1</data1><data1>cat2</data1><data1>cat3</data1><data1>data2</data1><data1>data3</data1><data1>data4</data1></dict>
 ==============================
 <?xml version="1.0"?><dict><name>zhangsan</name><data1><secondname>zzzz</secondname></data1><data1>cat1</data1><data1>cat2</data1><data1>cat3</data1><data1>data2</data1><data1>data3</data1><data1>data4</data1></dict>
  ==============================
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 <key>data1</key>
 <array>
 <dict>
 <key>secondname</key>
 <string>zzzz</string>
 </dict>
 <array>
 <string>cat1</string>
 <string>cat2</string>
 <string>cat3</string>
 </array>
 <string>data2</string>
 <string>data3</string>
 <string>data4</string>
 </array>
 <key>name</key>
 <string>zhangsan</string>
 </dict>
 </plist>
 */
//  在线XML、JSON数据互转
//  http://www.bejson.com/xml2json/

//  XML 新手入门基础知识
//  http://www.ibm.com/developerworks/cn/xml/x-newxml/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZHHXML)
/**
 *  @brief  将NSDictionary转换成XML字符串 不带XML声明 不带根节点
 *
 *  @return XML 字符串
 */
- (NSString *)zhh_XMLString;
/**
 *  @brief  将NSDictionary转换成XML字符串, 默认 <?xml version=\"1.0\" encoding=\"utf-8\"?> 声明   自定义根节点
 *
 *  @param rootElement 根节点
 *
 *  @return XML 字符串
 */
- (NSString *)zhh_XMLStringDefaultDeclarationWithRootElement:(NSString*)rootElement;
/**
 *  @brief  将NSDictionary转换成XML字符串, 自定义根节点  自定义xml声明
 *
 *  @param rootElement 根节点
 *
 *  @param declaration xml声明
 *
 *  @return 标准合法 XML 字符串
 */
- (NSString *)zhh_XMLStringWithRootElement:(NSString * _Nullable)rootElement declaration:(NSString * _Nullable)declaration;
/**
 *  @brief  将NSDictionary转换成Plist字符串
 *
 *  @return Plist 字符串
 */
- (NSString *)zhh_plistString;
/**
 *  @brief  将NSDictionary转换成Plist data
 *
 *  @return Plist data
 */
- (NSData *)zhh_plistData;
@end

NS_ASSUME_NONNULL_END
