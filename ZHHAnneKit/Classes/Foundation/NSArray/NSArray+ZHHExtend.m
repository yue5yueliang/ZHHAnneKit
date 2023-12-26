//
//  NSArray+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSArray+ZHHExtend.h"

@implementation NSArray (ZHHExtend)

- (BOOL)isEmpty{
    return (self == nil || [self isKindOfClass:[NSNull class]] || self.count == 0);
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
        return error.localizedDescription;
    }
}

- (id _Nullable)zhh_safeObjectAtIndex:(NSUInteger)index {
    if ([self count] > 0 && [self count] > index) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

/// 加载json数据
+ (NSArray *)zhh_loadJSONDataWithFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return jsonArr;
}

/// 倒序排列
- (NSArray * _Nonnull)zhh_reverseArray {
    return [[self reverseObjectEnumerator] allObjects];
}

/// 移动对象元素位置
- (NSArray *)zhh_moveIndex:(NSInteger)index toIndex:(NSInteger)toIndex{
    @autoreleasepool {
        NSMutableArray * temp = [NSMutableArray arrayWithArray:self];
        if (index != toIndex) {
            id obj = [temp objectAtIndex:index];
            [temp removeObjectAtIndex:index];
            if (toIndex >= [temp count]) {
                [temp addObject:obj];
            } else {
                [temp insertObject:obj atIndex:toIndex];
            }
        }
        return temp.mutableCopy;
    };
}

/// 移动元素
- (NSArray *)zhh_moveObject:(id)object toIndex:(NSInteger)toIndex{
    @autoreleasepool {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self];
        [temp removeObject:object];
        if (toIndex >= [temp count]) {
            [temp addObject:object];
        } else {
            [temp insertObject:object atIndex:toIndex];
        }
        return temp.mutableCopy;
    }
}

/// 交换位置
- (NSArray *)zhh_exchangeIndex:(NSInteger)index toIndex:(NSInteger)toIndex{
    @autoreleasepool {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self];
        [temp exchangeObjectAtIndex:index withObjectAtIndex:toIndex];
        return temp.mutableCopy;
    }
}

//MARK: - 筛选数据
- (id)zhh_detectArray:(BOOL(^)(id object, int index))block{
    for (int i = 0; i < self.count; i++) {
        id object = self[i];
        if (block(object,i)) return object;
    }
    return nil;
}

//MARK: - 多维数组筛选数据
- (id)zhh_detectManyDimensionArray:(BOOL(^)(id object, BOOL * stop))recurse{
    @autoreleasepool {
        for (id object in self) {
            BOOL stop = NO;
            if ([object isKindOfClass:[NSArray class]]) {
                return [(NSArray *)object zhh_detectManyDimensionArray:recurse];
            }
            if (recurse(object, &stop) || stop) {
                return object;
            }
        }
        return nil;
    }
}

/// 归纳对比选择，最终返回经过对比之后的数据
- (id)zhh_reduceObject:(id)object comparison:(id(^)(id obj1, id obj2))comparison{
    @autoreleasepool {
        __block id obj = object;
        [self enumerateObjectsUsingBlock:^(id _obj, NSUInteger idx, BOOL *stop) {
            obj = comparison(obj, _obj);
        }];
        return obj;
    }
}

// 查找数据，返回-1表示未查询到
- (NSInteger)zhh_searchObject:(id)object{
    @autoreleasepool {
        __block NSInteger idx = -1;
        [self zhh_detectArray:^BOOL(id _Nonnull obj, int index) {
            if (obj == object) {
                idx = index;
                return YES;
            }
            return NO;
        }];
        return idx;
    }
}

//MARK: - 映射
- (NSArray *)zhh_mapArray:(id(^)(id object))map{
    @autoreleasepool {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
        for (id object in self) {
            [array addObject:map(object) ?: [NSNull null]];
        }
        return array.mutableCopy;
    }
}

/// 映射，是否倒序
- (NSArray *)zhh_mapArray:(id(^)(id object))map reverse:(BOOL)reverse{
    @autoreleasepool {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
        NSEnumerationOptions options = reverse ? NSEnumerationReverse : NSEnumerationConcurrent;
        [self enumerateObjectsWithOptions:options usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:map(obj) ?: [NSNull null]];
        }];
        return array.mutableCopy;
    }
}

/// 映射和过滤数据
- (NSArray *)zhh_mapArray:(id _Nullable(^)(id object))map repetition:(BOOL)repetition{
    @autoreleasepool {
        NSMutableArray *array = [NSMutableArray array];
        for (id object in self) {
            id xx = map(object);
            if (xx) [array addObject:xx];
        }
        if (repetition) {
            NSSet * set = [NSSet setWithArray:array.mutableCopy];
            return set.allObjects;
        } else {
            return array.mutableCopy;
        }
    }
}

//MARK: - 包含数据
- (BOOL)zhh_containsObject:(BOOL(^)(id object, NSUInteger index))contains{
    @autoreleasepool {
        __block BOOL boo = NO;
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (contains(obj, idx)) {
                boo = YES;
                *stop = YES;
            }
        }];
        return boo;
    }
}

/// 指定位置之后是否包含数据
- (BOOL)zhh_containsFromIndex:(NSInteger * _Nonnull)index contains:(BOOL(^)(id object))contains{
    for (NSInteger i = *index; i < self.count; i++) {
        if (contains(self[i])) {
            *index = i;
            return YES;
        }
    }
    return NO;
}

/// 替换数组指定元素
- (NSArray *)zhh_replaceObject:(id)object operation:(BOOL(^)(id object, NSUInteger index, BOOL * stop))operation{
    @autoreleasepool {
        NSMutableArray *temps = [NSMutableArray arrayWithArray:self];
        [temps enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL end = NO;
            if (operation(obj, idx, &end)) {
                [temps replaceObjectAtIndex:idx withObject:object];
            } else if (end) {
                *stop = YES;
            }
        }];
        return temps.mutableCopy;
    }
}

/// 插入数据到目的位置
- (NSArray *)zhh_insertObject:(id)object aim:(BOOL(^)(id object, int index))aim{
    @autoreleasepool {
        NSMutableArray *temps = [NSMutableArray array];
        BOOL stop = NO;
        for (int i = 0; i < self.count; i++) {
            id obj = self[i];
            [temps addObject:obj];
            if (aim(obj, i)) {
                stop = YES;
                [temps addObject:object];
            }
        }
        if (stop == NO) [temps addObject:object];
        return temps.mutableCopy;
    }
}

/// 判断两个数组包含元素是否一致
- (BOOL)zhh_isEqualOtherArray:(NSArray *)otherArray{
    if (self.count != otherArray.count) {
        return NO;
    }
    for (id obj in self) {
        if (![otherArray containsObject:obj]) {
            return NO;
        }
    }
    for (id obj in otherArray) {
        if (![self containsObject:obj]) {
            return NO;
        }
    }
    return YES;
}

/// 随机打乱数组
- (NSArray *)zhh_disorganizeArray{
    @autoreleasepool {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
        NSMutableArray *copy = [self mutableCopy];
        while ([copy count] > 0) {
            int index = arc4random() % [copy count];
            id objectToMove = [copy objectAtIndex:index];
            [array addObject:objectToMove];
            [copy removeObjectAtIndex:index];
        }
        return array;
    }
}

// 删除数组当中的相同元素
- (NSArray *)zhh_deleteArrayEquelObject{
    return [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
}

/// 随机数组当中一条数据
- (nullable id)zhh_randomObject{
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

/// 数组剔除器
/// @param array 需要剔除的数据
- (NSArray *)zhh_pickArray:(NSArray *)array{
    @autoreleasepool {
        NSMutableArray *results = [NSMutableArray arrayWithArray:self];
        for (id obj in array) {
            if ([self containsObject:obj]) {
                [results removeObject:obj];
            }
        }
        return results.mutableCopy;
    }
}
@end
