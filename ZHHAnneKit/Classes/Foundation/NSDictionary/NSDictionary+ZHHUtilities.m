//
//  NSDictionary+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSDictionary+ZHHUtilities.h"

@implementation NSDictionary (ZHHUtilities)
- (BOOL)zhh_empty{
    return (self == nil || [self isKindOfClass:[NSNull class]] || self.count == 0);
}

/// 将当前对象NSDictionary 转换为 JSON 字符串
- (NSString *)zhh_jsonString {
    // 检查是否是有效的 JSON 对象
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return @"Error: Object cannot be serialized to JSON";
    }

    // 设置 JSON 序列化选项
    NSJSONWritingOptions options = 0;
#ifdef DEBUG
    options = NSJSONWritingPrettyPrinted;
#endif

    // 序列化为 JSON 数据
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    
    // 如果序列化成功，返回 JSON 字符串
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        // 如果序列化失败，返回错误信息
        return [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    }
}

/// 对字典(Key-Value)排序 不区分大小写
- (NSString *)zhh_sortedDictionaryByCaseInsensitive {
    // 将所有的key放进数组
    NSArray *allKeyArray = [self allKeys];
    
    // 按照键进行排序，不区分大小写
    NSArray *sortedKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        // 将key转换为大写进行比较，忽略大小写差异
        obj1 = [obj1 uppercaseString];
        obj2 = [obj2 uppercaseString];
        return [obj1 compare:obj2];
    }];
    
    // 拼接排序后的键值对
    NSMutableArray *valueArray = [NSMutableArray array];
    NSMutableString *resultString = [NSMutableString string];
    
    for (NSString *key in sortedKeyArray) {
        NSString *value = [self objectForKey:key];
        [valueArray addObject:value];
        
        // 拼接格式为 "key=value&"
        [resultString appendFormat:@"%@=%@&", key, value];
    }
    
    // 去除最后一个"&"并添加一个自定义的结束符号 "-"
    if ([resultString length] > 0) {
        [resultString deleteCharactersInRange:NSMakeRange(resultString.length - 1, 1)]; // 删除末尾的"&"
        [resultString appendString:@"-"];
    }
    
    // 分割字符串并返回结果
    NSArray *segments = [resultString componentsSeparatedByString:@"&-"];
    NSString *finalString = segments.firstObject;  // 获取分割后的第一个部分
    
    NSLog(@"大小写转换后的字符串：%@", finalString);
    return finalString;
}

/// 根据 plist 文件名读取并返回字典。
/// @param name plist 文件的名称（不包含扩展名）。
/// @discussion 该方法会查找当前应用程序的主 bundle 中是否存在名为 `name` 的 plist 文件。
/// 如果文件存在且能够成功读取，它会返回该 plist 文件对应的字典对象。如果文件不存在或读取失败，则返回 nil。
/// @return 返回一个 NSDictionary 对象，包含 plist 文件的内容。如果读取失败，则返回 nil。
+ (NSDictionary *)zhh_plistWithName:(NSString *)name {
    // 获取主 bundle 中 plist 文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    
    // 如果文件路径不存在，直接返回 nil
    if (!path) {
        return nil;
    }
    
    // 创建 plist 文件的 URL
    NSURL *plistURL = [NSURL fileURLWithPath:path];
    
    // 使用 dictionaryWithContentsOfURL 方法读取 plist 内容并返回对应的字典对象
    return [NSDictionary dictionaryWithContentsOfURL:plistURL];
}

/// 根据给定的键获取字典中的对象。
/// @param key 要查找的键。
/// @discussion 该方法首先检查当前对象是否为 NSDictionary 类型，
/// 如果是字典类型，则继续判断该字典是否包含指定的键。如果键存在，则返回对应的值；如果不存在，返回 nil。如果当前对象不是字典，则直接返回 nil。
/// @return 返回字典中与指定键关联的值，如果对象不是字典或键不存在，则返回 nil。
- (id)zhh_objectForKey:(NSString *)key {
    // 确保当前对象是字典类型
    if ([self isKindOfClass:[NSDictionary class]]) {
        // 如果字典包含该键，则返回对应的值
        if ([self.allKeys containsObject:key]) {
            return [self objectForKey:key];
        } else {
            // 键不存在时返回 nil
            return nil;
        }
    } else {
        // 当前对象不是字典类型，返回 nil
        return nil;
    }
}

/// 安全地根据给定的键获取字典中的对象。
/// @param key 要查找的键。
/// @discussion 该方法通过首先获取字典中的所有键，
/// 然后检查是否包含指定的键。如果字典中包含该键，则返回对应的值；
/// 如果不包含该键，则返回 nil。
/// @return 返回字典中与指定键关联的值，如果键不存在，则返回 nil。
- (id)zhh_safeObjectForKey:(NSString *)key {
    // 获取字典中的所有键
    NSArray *keysArray = [self allKeys];
    // 如果字典包含指定的键，则返回对应的值
    if ([keysArray containsObject:key]) {
        return [self objectForKey:key];
    } else {
        // 键不存在时返回 nil
        return nil;
    }
}

/// 检查字典是否包含某个键，并且该键的值不为 `NSNull` 或空字符串。
/// @param key 要检查的键。
/// @discussion 该方法首先检查字典是否包含指定的键，并确保该键的值不为 `NSNull` 或空字符串。如果满足这些条件，返回 `YES`；否则返回 `NO`。
/// @return 如果字典包含指定键且该键的值有效（不为 `NSNull` 且不为空字符串），则返回 `YES`；否则返回 `NO`。
- (BOOL)zhh_containsKey:(NSString *)key {
    // 如果字典为空或者字典不包含该键，返回 NO
    if (self.allKeys.count == 0 || ![self.allKeys containsObject:key]) {
        return NO;
    }
    // 如果键的值为 NSNull，返回 NO
    if ([self[key] isEqual:[NSNull null]]) {
        return NO;
    }
    // 如果键的值是空字符串，返回 NO
    if ([self[key] isKindOfClass:[NSString class]] && [self[key] isEqualToString:@""]) {
        return NO;
    }
    // 如果键的值为 NSNull，返回 NO
    if ([self[key] isEqual:[NSNull null]]) {
        return NO;
    }
    // 如果通过了所有检查，返回 YES
    return YES;
}

/// 对字典的所有键名进行排序，排序规则为不区分大小写的字母排序，排序顺序由 `ascending` 参数决定。
/// @discussion 该方法会获取字典的所有键，并按照不区分大小写的字母顺序进行排序。排序顺序由 `ascending` 参数来控制，`ascending` 为 `YES` 时按升序排序，`NO` 时按降序排序。
/// @param ascending 控制排序顺序，如果为 `YES`，则按升序排序；如果为 `NO`，则按降序排序。
/// @return 返回按字母顺序排序后的键名数组，排序顺序由 `ascending` 参数控制。
- (NSArray<NSString *> *)zhh_keysSortedWithAscending:(BOOL)ascending {
    NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:ascending];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self allKeys]];
    [array sortUsingDescriptors:@[des]];
    return array.mutableCopy;
}

/// 快速遍历字典，返回满足条件的所有 key
/// @discussion 该方法会遍历字典中的所有值，对于每个值，调用传入的闭包（block）来判断该值是否满足条件。如果满足条件，则将该值对应的所有键添加到结果集中。遍历过程中如果 `stop` 为 `YES`，则会中断遍历。返回满足条件的所有键名数组。
/// @param apply 闭包，用于判断每个值是否满足条件。闭包接受两个参数：值 (`value`) 和一个指示是否停止遍历的 `stop` 标记。如果闭包返回 `YES`，则将该值对应的键添加到结果集；如果返回 `NO`，则跳过该值。`stop` 是一个指针，可以通过修改其值来中止遍历。
/// @return 返回所有满足条件的键名数组。
- (NSArray<NSString *> *)zhh_applyDictionaryValue:(BOOL(^)(id value, BOOL *stop))apply {
    id value;
    NSMutableSet *set = [NSMutableSet set];
    NSEnumerator *enumerator = [self objectEnumerator];
    while ((value = [enumerator nextObject])) {
        BOOL stop = NO;
        if (apply(value, &stop)) {
            NSArray *array = [self allKeysForObject:value];
            [set addObjectsFromArray:array];
        }
        if (stop) break;
    }
    return set.allObjects;
}

/// 映射字典，返回满足条件的键值对组成的新字典
/// @discussion 该方法会遍历当前字典中的所有键值对，并根据传入的闭包（block）来判断是否将该键值对包含在结果字典中。遍历过程中，只有闭包返回 `YES` 的键值对才会被添加到新字典中。
/// @param map 闭包，用于判断每个键值对是否满足条件。闭包接收两个参数：键 (`key`) 和对应的值 (`value`)。如果闭包返回 `YES`，则将键值对添加到结果字典中；如果返回 `NO`，则跳过该键值对。
/// @return 返回一个包含所有满足条件键值对的新字典。
- (NSDictionary *)zhh_mapDictionary:(BOOL(^)(NSString *key, id value))map {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSEnumerator *enumerator = [self keyEnumerator];
    NSString *key = nil;
    while ((key = [enumerator nextObject])) {
        id value = self[key];
        if (map(key, value)) {
            dict[key] = value;
        }
    }
    return [dict copy];
}

/// 从字典中移除指定键的键值对 用于筛选出特定的键值对
/// @discussion 该方法会根据传入的键数组 `keys`，从字典中筛选出匹配的键值对，构成一个新的字典并返回。
/// @param keys 包含需要挑选的键的数组
/// @return 返回一个包含所选键值对的新字典
- (NSDictionary *)zhh_pickForKeys:(NSArray *)keys {
    NSMutableDictionary *picked = [[NSMutableDictionary alloc] initWithCapacity:keys.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([keys containsObject:key]) {
            picked[key] = obj;
        }
    }];
    return [picked copy];
}

/// 从字典中移除指定键的键值对
/// @discussion 该方法会根据传入的键数组 `keys`，从字典中移除匹配的键值对，返回一个新的字典。
/// @param keys 包含需要移除的键的数组
/// @return 返回一个新的字典，不包含指定键的键值对
- (NSDictionary *)zhh_omitForKeys:(NSArray *)keys {
    NSMutableDictionary *result = [self mutableCopy];
    [result removeObjectsForKeys:keys];
    return [result copy];
}

/// 合并两个字典
/// @discussion 该方法将当前字典与传入的字典合并。如果两个字典中存在相同的键：
/// - 如果值是字典类型，则递归合并两个字典的值。
/// - 如果值不是字典类型，则以第二个字典中的值为准。
/// 该方法适用于处理复杂的字典合并，特别是在需要递归合并字典类型的值时。
/// @param dict1 第一个字典，作为合并的基准字典
/// @param dict2 第二个字典，将与第一个字典合并
/// @return 返回合并后的字典，字典内容将包含来自两个字典的所有键值对
+ (NSDictionary *)zhh_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2 {
    // 创建一个可变字典以存储合并结果，初始内容为第一个字典
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict1];

    // 遍历第二个字典的所有键值对
    [dict2 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([result objectForKey:key]) {
            // 如果键在第一个字典中已存在
            id existingValue = result[key];
            if ([existingValue isKindOfClass:[NSDictionary class]] && [obj isKindOfClass:[NSDictionary class]]) {
                // 如果值为字典类型，则递归合并
                NSDictionary *mergedDict = [self zhh_dictionaryByMerging:(NSDictionary *)existingValue with:(NSDictionary *)obj];
                [result setObject:mergedDict forKey:key];
            } else {
                // 如果值不是字典类型，则以第二个字典的值为准
                [result setObject:obj forKey:key];
            }
        } else {
            // 如果键在第一个字典中不存在，直接添加
            [result setObject:obj forKey:key];
        }
    }];

    // 返回不可变字典
    return [result copy];
}

/// 将另一个字典并入当前字典
/// @discussion 使用实例方法将一个字典并入当前字典，逻辑与静态方法一致。
/// @param dict 要合并的字典
/// @return 返回合并后的新字典
- (NSDictionary *)zhh_dictionaryByMergingWith:(NSDictionary *)dict {
    // 调用类方法进行合并
    return [[self class] zhh_dictionaryByMerging:self with:dict];
}

/// 创建一个包含新增键值对的字典
/// @discussion 该方法将传入的字典中的所有键值对添加到当前字典中，生成并返回一个新的字典。
/// 如果两个字典中有相同的键，当前字典中的值将被第二个字典中的值覆盖。
/// 该方法适用于简单的字典合并，尤其是在不需要递归合并值的情况下。
/// @param dictionary 需要添加键值对的字典
/// @return 返回包含当前字典与传入字典键值对合并后的新字典
- (NSDictionary *)zhh_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary {
    // 创建当前字典的可变副本
    NSMutableDictionary *result = [self mutableCopy];

    // 将传入字典的键值对添加到副本中
    [result addEntriesFromDictionary:dictionary];

    // 返回不可变字典
    return [result copy];
}

@end
