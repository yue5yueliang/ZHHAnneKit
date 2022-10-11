//
//  NSDictionary+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZHHExtend)
/// Is it empty
@property (nonatomic, assign, readonly) BOOL zhh_isEmpty;

/// 转换为json字符串
@property (nonatomic, strong, readonly) NSString *zhh_jsonString;
/// 读取本地plist文件
+ (NSDictionary *)zhh_plistWithName:(NSString *)name;

- (id)zhh_objectForKey:(NSString *)key;
/**
 *  如果key存在返回对应的对象，否则返回nil
 *
 *  @param key 键值
 *
 *  @return Value值，否则nil
 */
- (id)zhh_safeObjectForKey:(NSString *)key;

/// 是否包含某个key
- (BOOL)zhh_containsKey:(NSString *)key;

/// 按字典关键字名称升序排序
- (NSArray<NSString *> *)zhh_keysSorted;
/// 按字典键名排序，按降序排序
- (NSArray<NSString *> *)zhh_keySortDescending;

/// 快速遍历字典，返回满足条件所有key
/// @param apply traverse the event, return yes to need the value
/// @return returns the key that satisfies the condition
- (NSArray<NSString *> *)zhh_applyDictionaryValue:(BOOL(^)(id value, BOOL * stop))apply;

/// 映射字典
- (NSDictionary *)zhh_mapDictionary:(BOOL(^)(NSString * key, id value))map;

/// 合并字典
- (NSDictionary *)zhh_mergeDictionary:(NSDictionary *)dictionary;

/// Dictionary selector
- (NSDictionary *)zhh_pickForKeys:(NSArray<NSString *> *)keys;

/// Dictionary remover
- (NSDictionary *)zhh_omitForKeys:(NSArray<NSString *> *)keys;

@end

NS_ASSUME_NONNULL_END
