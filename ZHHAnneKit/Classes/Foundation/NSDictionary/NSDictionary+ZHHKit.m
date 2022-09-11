//
//  NSDictionary+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSDictionary+ZHHKit.h"

@implementation NSDictionary (ZHHKit)
- (BOOL)isEmpty{
    return (self == nil || [self isKindOfClass:[NSNull class]] || self.allKeys == 0);
}

- (NSString *)zhh_jsonString{
    NSError *error;
#ifdef DEBUG
    NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
#else
    NSJSONWritingOptions options = 0;
#endif
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
}

+ (NSDictionary *)zhh_plistWithName:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSURL *plistURL = [NSURL fileURLWithPath:path];
    return [NSDictionary dictionaryWithContentsOfURL:plistURL];
}

- (id)zhh_objectForKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]]){
        if ([self.allKeys containsObject:key]) {
            return [self objectForKey:key];
        }else{
            return nil;
        }
    }else {
        return nil;
    }
}

- (id)zhh_safeObjectForKey:(NSString *)key {
    NSArray *keysArray = [self allKeys];
    if ([keysArray containsObject:key]) {
        return [self objectForKey:key];
    } else {
        return nil;
    }
}

/// 是否包含某个key
- (BOOL)zhh_containsKey:(NSString *)key{
    if (self.allKeys.count == 0 || ![self.allKeys containsObject:key]) {
        return NO;
    }
    if ([self[key] isEqual:[NSNull null]]) {
        return NO;
    }
    if ([self[key] isKindOfClass:[NSString class]] && [self[key] isEqualToString:@""]) {
        return NO;
    }
    if ([self[key] isEqual:[NSNull null]]) {
        return NO;
    }
    return YES;
}
/// 字典键名排序
- (NSArray<NSString *> *)zhh_keysSorted{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray<NSString *> *)zhh_keySortDescending{
    @autoreleasepool {
        // "self"，表示字符串本身
        NSSortDescriptor * des = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        NSMutableArray * array = [NSMutableArray arrayWithArray:[self allKeys]];
        [array sortUsingDescriptors:@[des]];
        return array.mutableCopy;
    }
}

/// 快速遍历字典，返回满足条件所有key
- (NSArray<NSString *> *)zhh_applyDictionaryValue:(BOOL(^)(id value, BOOL * stop))apply{
    @autoreleasepool {
        id value;
        NSMutableSet * set = [NSMutableSet set];
        NSEnumerator * enumtor = [self objectEnumerator];
        while (value = [enumtor nextObject]) {
            BOOL stop = NO;
            if (apply(value, &stop)) {
                NSArray * array = [self allKeysForObject:value];
                [set addObjectsFromArray:array];
            }
            if (stop) break;
        }
        return set.allObjects;
    }
}
/// 映射字典
- (NSDictionary *)zhh_mapDictionary:(BOOL(^)(NSString * key, id value))map{
    @autoreleasepool {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSEnumerator * enumtor = [self keyEnumerator];
        NSString * key = nil;
        while (key = [enumtor nextObject]) {
            id value = self[key];
            if (map(key, value)) {
                [dict setValue:value forKey:key];
            }
        }
        return dict.mutableCopy;
    }
}
/// 合并字典
- (NSDictionary *)zhh_mergeDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:self];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self];
    [temp addEntriesFromDictionary:dictionary];
    [temp enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([self objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = [[self objectForKey:key] zhh_mergeDictionary:obj];
                [result setObject:dict forKey:key];
            } else {
                [result setObject:obj forKey:key];
            }
        } else if ([dictionary objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = [[dictionary objectForKey:key] zhh_mergeDictionary:obj];
                [result setObject:dict forKey:key];
            } else {
                [result setObject:obj forKey:key];
            }
        }
    }];
    return (NSDictionary *) [result mutableCopy];
}

- (NSDictionary *)zhh_pickForKeys:(NSArray *)keys{
    @autoreleasepool {
        NSMutableDictionary *picked = [[NSMutableDictionary alloc] initWithCapacity:keys.count];
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([keys containsObject:key]) {
                picked[key] = obj;
            }
        }];
        return picked.mutableCopy;
    }
}

- (NSDictionary *)zhh_omitForKeys:(NSArray *)keys{
    @autoreleasepool {
        NSMutableDictionary *result = [self mutableCopy];
        [result removeObjectsForKeys:keys];
        return result.mutableCopy;
    }
}
@end
