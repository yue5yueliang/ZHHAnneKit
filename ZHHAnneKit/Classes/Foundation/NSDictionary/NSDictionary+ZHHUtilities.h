//
//  NSDictionary+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZHHUtilities)
/// 检查字典是否为空
- (BOOL) zhh_empty;
/// 将当前对象NSDictionary 转换为 JSON 字符串
- (NSString *)zhh_jsonString;
/// 对字典(Key-Value)排序 不区分大小写
- (NSString *)zhh_sortedDictionaryByCaseInsensitive;

/// 根据 plist 文件名读取并返回字典。
/// @param name plist 文件的名称（不包含扩展名）。
/// @discussion 该方法会查找当前应用程序的主 bundle 中是否存在名为 `name` 的 plist 文件。
/// 如果文件存在且能够成功读取，它会返回该 plist 文件对应的字典对象。如果文件不存在或读取失败，则返回 nil。
/// @return 返回一个 NSDictionary 对象，包含 plist 文件的内容。如果读取失败，则返回 nil。
+ (NSDictionary *)zhh_plistWithName:(NSString *)name;

/// 根据给定的键获取字典中的对象。
/// @param key 要查找的键。
/// @discussion 该方法首先检查当前对象是否为 NSDictionary 类型，
/// 如果是字典类型，则继续判断该字典是否包含指定的键。如果键存在，则返回对应的值；如果不存在，返回 nil。如果当前对象不是字典，则直接返回 nil。
/// @return 返回字典中与指定键关联的值，如果对象不是字典或键不存在，则返回 nil。
- (id)zhh_objectForKey:(NSString *)key;

/// 安全地根据给定的键获取字典中的对象。
/// @param key 要查找的键。
/// @discussion 该方法通过首先获取字典中的所有键，
/// 然后检查是否包含指定的键。如果字典中包含该键，则返回对应的值；
/// 如果不包含该键，则返回 nil。
/// @return 返回字典中与指定键关联的值，如果键不存在，则返回 nil。
- (id)zhh_safeObjectForKey:(NSString *)key;

/// 检查字典是否包含某个键，并且该键的值不为 `NSNull` 或空字符串。
/// @param key 要检查的键。
/// @discussion 该方法首先检查字典是否包含指定的键，并确保该键的值不为 `NSNull` 或空字符串。如果满足这些条件，返回 `YES`；否则返回 `NO`。
/// @return 如果字典包含指定键且该键的值有效（不为 `NSNull` 且不为空字符串），则返回 `YES`；否则返回 `NO`。
- (BOOL)zhh_containsKey:(NSString *)key;

/// 对字典的所有键名进行排序，排序规则为不区分大小写的字母排序，排序顺序由 `ascending` 参数决定。
/// @discussion 该方法会获取字典的所有键，并按照不区分大小写的字母顺序进行排序。排序顺序由 `ascending` 参数来控制，`ascending` 为 `YES` 时按升序排序，`NO` 时按降序排序。
/// @param ascending 控制排序顺序，如果为 `YES`，则按升序排序；如果为 `NO`，则按降序排序。
/// @return 返回按字母顺序排序后的键名数组，排序顺序由 `ascending` 参数控制。
- (NSArray<NSString *> *)zhh_keysSortedWithAscending:(BOOL)ascending;

/// 快速遍历字典，返回满足条件的所有 key
/// @discussion 该方法会遍历字典中的所有值，对于每个值，调用传入的闭包（block）来判断该值是否满足条件。如果满足条件，则将该值对应的所有键添加到结果集中。遍历过程中如果 `stop` 为 `YES`，则会中断遍历。返回满足条件的所有键名数组。
/// @param apply 闭包，用于判断每个值是否满足条件。闭包接受两个参数：值 (`value`) 和一个指示是否停止遍历的 `stop` 标记。如果闭包返回 `YES`，则将该值对应的键添加到结果集；如果返回 `NO`，则跳过该值。`stop` 是一个指针，可以通过修改其值来中止遍历。
/// @return 返回所有满足条件的键名数组。
/**
     NSDictionary *dict = @{@"key1": @1, @"key2": @2, @"key3": @1};
     NSArray *keys = [dict zhh_applyDictionaryValue:^BOOL(id value, BOOL *stop) {
         // 查找值为 1 的所有键
         return [value isEqual:@1];
     }];
     // keys 会是 @[@"key1", @"key3"]
 */
- (NSArray<NSString *> *)zhh_applyDictionaryValue:(BOOL(^)(id value, BOOL *stop))apply;

/// 映射字典，返回满足条件的键值对组成的新字典
/// @discussion 该方法会遍历当前字典中的所有键值对，并根据传入的闭包（block）来判断是否将该键值对包含在结果字典中。遍历过程中，只有闭包返回 `YES` 的键值对才会被添加到新字典中。
/// @param map 闭包，用于判断每个键值对是否满足条件。闭包接收两个参数：键 (`key`) 和对应的值 (`value`)。如果闭包返回 `YES`，则将键值对添加到结果字典中；如果返回 `NO`，则跳过该键值对。
/// @return 返回一个包含所有满足条件键值对的新字典。
- (NSDictionary *)zhh_mapDictionary:(BOOL(^)(NSString *key, id value))map;

/// 从字典中挑选指定的键对应的键值对
/// @discussion 该方法会根据传入的键数组 `keys`，从字典中筛选出匹配的键值对，构成一个新的字典并返回。
/// @param keys 包含需要挑选的键的数组
/// @return 返回一个包含所选键值对的新字典
- (NSDictionary *)zhh_pickForKeys:(NSArray *)keys;

/// 从字典中移除指定键的键值对 用于筛选出特定的键值对
/// @discussion 该方法会根据传入的键数组 `keys`，从字典中移除匹配的键值对，返回一个新的字典。
/// @param keys 包含需要移除的键的数组
/// @return 返回一个新的字典，不包含指定键的键值对
- (NSDictionary *)zhh_omitForKeys:(NSArray *)keys;

/// 合并两个字典
/// @discussion 该方法将当前字典与传入的字典合并。如果两个字典中存在相同的键：
/// - 如果值是字典类型，则递归合并两个字典的值。
/// - 如果值不是字典类型，则以第二个字典中的值为准。
/// 该方法适用于处理复杂的字典合并，特别是在需要递归合并字典类型的值时。
/// @param dict1 第一个字典，作为合并的基准字典
/// @param dict2 第二个字典，将与第一个字典合并
/// @return 返回合并后的字典，字典内容将包含来自两个字典的所有键值对
+ (NSDictionary *)zhh_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

/// 将另一个字典并入当前字典
/// @discussion 使用实例方法将一个字典并入当前字典，逻辑与静态方法一致。
/// @param dict 要合并的字典
/// @return 返回合并后的新字典
- (NSDictionary *)zhh_dictionaryByMergingWith:(NSDictionary *)dict;

/// 创建一个包含新增键值对的字典
/// @discussion 该方法将传入的字典中的所有键值对添加到当前字典中，生成并返回一个新的字典。
/// 如果两个字典中有相同的键，当前字典中的值将被第二个字典中的值覆盖。
/// 该方法适用于简单的字典合并，尤其是在不需要递归合并值的情况下。
/// @param dictionary 需要添加键值对的字典
/// @return 返回包含当前字典与传入字典键值对合并后的新字典
- (NSDictionary *)zhh_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
