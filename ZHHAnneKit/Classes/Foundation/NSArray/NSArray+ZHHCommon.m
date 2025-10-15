//
//  NSArray+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSArray+ZHHCommon.h"

@implementation NSArray (ZHHCommon)

/// 计算两个数组的交集
/// @param otherArray 另一个数组
- (NSArray *)zhh_intersectionWithArray:(NSArray *)otherArray {
    if (!self || self.count == 0 || !otherArray || otherArray.count == 0) {
        // 如果任意一个数组为空或不存在，直接返回空数组
        return @[];
    }

    NSSet *set1 = [NSSet setWithArray:self];
    NSSet *set2 = [NSSet setWithArray:otherArray];

    // 使用更高效的集合交集方法
    NSMutableSet *intersectionSet = [set1 mutableCopy];
    [intersectionSet intersectSet:set2];
    
    return intersectionSet.allObjects;
}

/// 计算两个数组的差集
/// @param otherArray 另一个数组
- (NSArray *)zhh_subtractionWithArray:(NSArray *)otherArray {
    @autoreleasepool {
        // 检查自身数组
        if (!self || self.count == 0) {
            return otherArray ?: @[];
        }

        // 检查对比数组
        if (!otherArray || otherArray.count == 0) {
            return self;
        }

        // 筛选出只存在于otherArray但不在self中的元素
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", self];
        NSArray *filter1 = [otherArray filteredArrayUsingPredicate:predicate1];

        // 筛选出只存在于self但不在otherArray中的元素
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", otherArray];
        NSArray *filter2 = [self filteredArrayUsingPredicate:predicate2];

        // 合并两个差集
        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:filter1];
        [resultArray addObjectsFromArray:filter2];

        return resultArray;
    }
}

/// 删除数组相同部分并追加不同部分
/// @param otherArray 另一个数组
- (NSArray *)zhh_mergeWithArrayRemovingDuplicates:(NSArray *)otherArray {
    @autoreleasepool {
        // 检查是否存在数组为空的情况
        if (!self || self.count == 0) {
            return otherArray ?: @[];
        }
        if (!otherArray || otherArray.count == 0) {
            return self;
        }

        // 筛选出otherArray中与self不同的部分
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", self];
        NSArray *filteredArray = [otherArray filteredArrayUsingPredicate:predicate];

        // 创建新的数组并追加不同部分
        NSMutableArray *mergedArray = [NSMutableArray arrayWithArray:self];
        [mergedArray addObjectsFromArray:filteredArray];

        return mergedArray;
    }
}

/// 过滤数组，排除不需要部分
- (NSArray *)zhh_filterArrayExclude:(BOOL(^)(id object))block {
    // 获取所有不符合 block 条件的对象的索引
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        // 只返回 block 为 NO 的对象
        return !block(obj);
    }];
    
    // 返回索引对应的对象数组
    return [self objectsAtIndexes:indexes];
}

/// 过滤数组，获取需要部分
- (NSArray *)zhh_filterArrayNeed:(BOOL(^)(id object))block {
    // 通过闭包筛选符合条件的元素
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);  // 只保留符合 block 条件的元素
    }];
    return [self objectsAtIndexes:indexes];  // 返回筛选后的新数组
}

/// MARK: - 使用 NSPredicate 从当前数组中移除另一个数组中的元素
- (NSArray *)zhh_deleteTargetArray:(NSArray *)temp {
    // 使用 NSPredicate 创建一个过滤条件：排除 temp 数组中的元素
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", temp];
    // 使用 predicate 筛选当前数组中不在 temp 中的元素，并返回新的数组
    return [self filteredArrayUsingPredicate:predicate];
}

/// MARK: - 根据指定属性对对象数组进行升序或降序排序
/// @param key 用于排序的属性名称
/// @param ascending 是否按升序排序，YES 为升序，NO 为降序
/// @return 返回排序后的新数组
- (NSArray *)zhh_sortArrayByKey:(NSString *)key ascending:(BOOL)ascending {
    if (self.count == 0) return self; // 如果数组为空，直接返回原数组
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    return [self sortedArrayUsingDescriptors:@[sortDescriptor]];
}

// /MARK: - 利用 NSPredicate 对对象数组进行筛选，取出 key 属性值匹配指定 value 的元素
/// @param key 属性名，表示要筛选的字段
/// @param value 要匹配的字段值
/// @return 返回匹配的元素组成的数组
- (NSArray *)zhh_filterArrayByKey:(NSString *)key value:(NSString *)value {
    // 参数验证
    if (!key || key.length == 0 || !value) {
        NSLog(@"ZHHAnneKit 警告: 筛选参数无效");
        return @[];
    }
    
    // 构造Predicate格式字符串，执行匹配
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ LIKE %@", key, value];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    return [self filteredArrayUsingPredicate:predicate];
}

/// MARK: - 使用字符串比较运算符筛选数组元素
/// @param ope 比较操作符，支持: beginswith（以开头）、endswith（以结尾）、contains（包含）、like（模糊匹配）、matches（正则表达式）
/// @param key 要比较的属性名
/// @param value 要比较的值
/// @return 返回符合条件的数组
- (NSArray *)zhh_filterArrayWithOperator:(NSString *)ope key:(NSString *)key value:(NSString *)value {
    // 参数验证
    if (!ope || ope.length == 0 || !key || key.length == 0 || !value) {
        NSLog(@"ZHHAnneKit 警告: 筛选操作符参数无效");
        return @[];
    }
    
    // 特殊处理支持拼音的操作符
    NSArray *supportedOperators = @[@"beginswith", @"endswith", @"contains"];
    if ([supportedOperators containsObject:ope.lowercaseString]) {
        NSMutableArray *filteredResults = [NSMutableArray array];
        
        // 遍历数组，筛选符合条件的对象
        for (id obj in self) {
            NSString *targetValue = [obj valueForKey:key]; // 获取指定 key 的值
            
            if ([self zhh_isValue:targetValue matchesOperator:ope.lowercaseString withValue:value]) {
                [filteredResults addObject:obj];
            }
        }
        return filteredResults;
    }
    
    // 默认处理逻辑（like 和 matches 直接交给 NSPredicate 处理）
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ %@ '%@'", key, ope, value];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    return [self filteredArrayUsingPredicate:predicate];
}

// 判断字符串是否匹配操作符和值
- (BOOL)zhh_isValue:(NSString *)targetValue matchesOperator:(NSString *)ope withValue:(NSString *)value {
    if (!targetValue || !value || !ope) return NO;
    
    NSString *pinyinValue = [self zhh_pinyinFirstLetters:targetValue]; // 获取拼音首字母

    // 区分操作符执行逻辑
    if ([ope isEqualToString:@"beginswith"]) {
        return ([targetValue.lowercaseString hasPrefix:value.lowercaseString] ||
                [pinyinValue.lowercaseString hasPrefix:value.lowercaseString]);
    } else if ([ope isEqualToString:@"endswith"]) {
        return ([targetValue.lowercaseString hasSuffix:value.lowercaseString] ||
                [pinyinValue.lowercaseString hasSuffix:value.lowercaseString]);
    } else if ([ope isEqualToString:@"contains"]) {
        return ([targetValue.lowercaseString containsString:value.lowercaseString] ||
                [pinyinValue.lowercaseString containsString:value.lowercaseString]);
    }
    
    return NO;
}

// 获取字符串的拼音首字母
- (NSString *)zhh_pinyinFirstLetters:(NSString *)string {
    if (!string || string.length == 0) {
        return @"";
    }
    
    NSMutableString *mutableString = [string mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    // 提取拼音首字母
    NSMutableString *firstLetters = [NSMutableString string];
    NSArray *words = [mutableString componentsSeparatedByString:@" "];
    for (NSString *word in words) {
        if (word.length > 0) {
            [firstLetters appendString:[word substringToIndex:1]];
        }
    }
    return firstLetters;
}

//MARK: - ------------------------ Predicate谓词的简单使用 ------------------------
/*
 // self 表示数组元素/字符串本身
 // 比较运算符 =/==(等于)、>=/=>(大于等于)、<=/=<(小于等于)、>(大于)、<(小于)、!=/<>(不等于)
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"self = %@",[people_arr lastObject]];//比较数组元素相等
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"address = %@",[(People *)[people_arr lastObject] address]];//比较数组元素中某属性相等
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"age in {18,21}"];//比较数组元素中某属性值在这些值中
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"age between {18,21}"];//比较数组元素中某属性值大于等于左边的值，小于等于右边的值
 
 // 逻辑运算符 and/&&(与)、or/||(或)、not/!(非)
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"address = %@ && age between {19,22}", [(People *)[people_arr lastObject] address]];
 
 // 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
 // [c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd]既 又
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name beginswith[cd] 'ja'"];
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name matches '^[a-zA-Z]{4}$'"];
 
 //集合运算符 some/any:集合中任意一个元素满足条件、all:集合中所有元素都满足条件、none:集合中没有元素满足条件、in:集合中元素在另一个集合中
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"all employees.employeeId in {7,8,9}"];
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"self in %@",filter_arr];
 // $K：用于动态传入属性名、%@：用于动态设置属性值(字符串、数字、日期对象)、$(value)：可以动态改变
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K > $age",@"age"];
 //pre = [pre predicateWithSubstitutionVariables:@{@"age":@21}];
 // NSCompoundPredicate 相当于多个NSPredicate的组合
 //NSCompoundPredicate *compPre = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"age > 19"],[NSPredicate predicateWithFormat:@"age < 21"]]];
 // 暂时没找到用法
 //NSComparisonPredicate *compPre = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"name"] rightExpression:[NSExpression expressionForVariable:@"ja"] modifier:NSAnyPredicateModifier type:NSBeginsWithPredicateOperatorType options:NSNormalizedPredicateOption];
 //[people_arr filterUsingPredicate:compPre];

 */
@end
