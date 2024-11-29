//
//  NSArray+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZHHCommon)

/// 计算两个数组的交集
/// @param otherArray 另一个数组
/**
     NSArray *array1 = @[@1, @2, @3, @4, @5];
     NSArray *array2 = @[@3, @4, @5, @6, @7];
     NSArray *intersection = [array1 zhh_intersectionWithArray:array2];
     NSLog(@"Intersection: %@", intersection);
     // Output: Intersection: (3, 4, 5)
 */
- (NSArray *)zhh_intersectionWithArray:(NSArray *)otherArray;

/// 计算两个数组的差集
/// @param otherArray 另一个数组
/**
     NSArray *array1 = @[@1, @2, @3, @4, @5];
     NSArray *array2 = @[@3, @4, @6, @7];
     NSArray *difference = [array1 zhh_subtractionWithArray:array2];
     NSLog(@"Difference: %@", difference);
     // Output: Difference: (1, 2, 5, 6, 7)
 */
- (NSArray *)zhh_subtractionWithArray:(NSArray *)otherArray;

/// 删除数组相同部分并追加不同部分
/// @param otherArray 另一个数组
/**
     NSArray *array1 = @[@1, @2, @3];
     NSArray *array2 = @[@3, @4, @5];
     NSArray *result = [array1 zhh_mergeWithArrayRemovingDuplicates:array2];
     NSLog(@"Merged Array: %@", result);
     // Output: Merged Array: (1, 2, 3, 4, 5)
 */
- (NSArray *)zhh_mergeWithArrayRemovingDuplicates:(NSArray *)otherArray;

/// 过滤数组，排除不需要部分
/**
     NSArray *array = @[@5, @8, @12, @15, @3];
     NSArray *filteredArray = [array zhh_filterArrayExclude:^BOOL(id object) {
         return [object integerValue] > 10;  // 排除大于10的数
     }];
     NSLog(@"%@", filteredArray);  // 输出：(@5, @8, @3)
 */
- (NSArray *)zhh_filterArrayExclude:(BOOL(^)(id object))block;

/// 过滤数组，获取需要部分
/**
     NSArray *array = @[@1, @2, @3, @4, @5];
     NSArray *filteredArray = [array zhh_filterArrayNeed:^BOOL(id object) {
         return [object integerValue] % 2 == 0;  // 只保留偶数
     }];
     NSLog(@"%@", filteredArray);  // 输出：(@2, @4)
 */
- (NSArray *)zhh_filterArrayNeed:(BOOL(^)(id object))block;

/// MARK: - 使用 NSPredicate 从当前数组中移除另一个数组中的元素
/**
     NSArray *originalArray = @[@1, @2, @3, @4, @5];
     NSArray *targetArray = @[@2, @4];
     NSArray *resultArray = [originalArray zhh_deleteTargetArray:targetArray];
     NSLog(@"%@", resultArray);  // 输出：(@1, @3, @5)
 */
- (NSArray *)zhh_deleteTargetArray:(NSArray *)temp;

// MARK: - 根据指定属性对对象数组进行升序或降序排序
/// @param key 用于排序的属性名称
/// @param ascending 是否按升序排序，YES 为升序，NO 为降序
/// @return 返回排序后的新数组
/**
     // 假设 Person 是一个模型类，包含 name 和 age 属性
     NSArray *people = @[
         [[Person alloc] initWithName:@"Alice" age:30],
         [[Person alloc] initWithName:@"Bob" age:25],
         [[Person alloc] initWithName:@"Charlie" age:35]
     ];

     // 按照 name 升序排序
     NSArray *sortedByName = [people zhh_sortArrayByKey:@"name" ascending:YES];
     NSLog(@"Sorted by name: %@", sortedByName);
     Sorted by name: (
         Name: Alice, Age: 30,
         Name: Bob, Age: 25,
         Name: Charlie, Age: 35
     )
     // 按照 age 降序排序
     NSArray *sortedByAge = [people zhh_sortArrayByKey:@"age" ascending:NO];
     NSLog(@"Sorted by age: %@", sortedByAge);
     Sorted by name: (
        Name: Charlie, Age: 35,
        Name: Bob, Age: 25,
        Name: Alice, Age: 30
     )
 */
- (NSArray *)zhh_sortArrayByKey:(NSString *)key ascending:(BOOL)ascending;

/// MARK: - 利用 NSPredicate 对对象数组进行筛选，取出 key 属性值匹配指定 value 的元素
/// @param key 属性名，表示要筛选的字段
/// @param value 要匹配的字段值
/// @return 返回匹配的元素组成的数组
/**
     // 假设我们有如下 Person 类对象
     NSArray *people = @[
         [[Person alloc] initWithName:@"Alice" age:30],
         [[Person alloc] initWithName:@"Bob" age:25],
         [[Person alloc] initWithName:@"Charlie" age:35]
     ];

     // 根据 name 为 "Bob" 过滤出对应的元素
     NSArray *filteredPeople = [people zhh_filterArrayByKey:@"name" value:@"Bob"];
     NSLog(@"Filtered People: %@", filteredPeople);
     Filtered People: (
         Name: Bob, Age: 25
     )
 */
- (NSArray *)zhh_filterArrayByKey:(NSString *)key value:(NSString *)value;

/// MARK: - 使用字符串比较运算符筛选数组元素
/// @param ope 比较操作符，支持: beginswith（以开头）、endswith（以结尾）、contains（包含）、like（模糊匹配）、matches（正则表达式）
/// @param key 要比较的属性名
/// @param value 要比较的值
/// @return 返回符合条件的数组
/**
     NSArray *people = @[
         [[Person alloc] initWithName:@"Alice" age:30],
         [[Person alloc] initWithName:@"Bob" age:25],
         [[Person alloc] initWithName:@"张三" age:25],
         [[Person alloc] initWithName:@"陈小明" age:25],
         [[Person alloc] initWithName:@"Charlie 王" age:35]
     ];

     // 按 name 属性筛选以 "C" 开头的对象
     NSArray *filteredBeginsWithC = [people zhh_filterArrayWithOperator:@"beginswith" key:@"name" value:@"C"];
     NSLog(@"Begins with C: %@", filteredBeginsWithC);
     Begins with C: (
         "Name: Charlie 王, Age: 35",
         "Name: 陈小明, Age: 25"
     )
 
     // 按 name 属性筛选以 "明" 结尾的对象
     NSArray *filteredEndsWithMing = [people zhh_filterArrayWithOperator:@"endswith" key:@"name" value:@"明"];
     NSLog(@"Ends with 明: %@", filteredEndsWithMing);
     Ends with 明: (
         "Name: 陈小明, Age: 25"
     )
 
     // 按 name 属性筛选包含 "王" 的对象
     NSArray *filteredContainsWang = [people zhh_filterArrayWithOperator:@"contains" key:@"name" value:@"王"];
     NSLog(@"Contains 王: %@", filteredContainsWang);
     Contains 王: (
         "Name: Charlie 王, Age: 35"
     )
 
     // 按 name 属性筛选使用 like 模糊匹配（例如包含 "Cha*"）
     NSArray *filteredLikeCha = [people zhh_filterArrayWithOperator:@"like" key:@"name" value:@"Cha*"];
     NSLog(@"Like Cha*: %@", filteredLikeCha);
     Like Cha*: (
         "Name: Charlie 王, Age: 35"
     )
 
     // 使用正则表达式筛选 name 包含英文字母的对象
     NSArray *filteredMatchesAlpha = [people zhh_filterArrayWithOperator:@"matches" key:@"name" value:@".*[A-Za-z].*"];
     NSLog(@"Matches alphabet: %@", filteredMatchesAlpha);
     Matches alphabet: (
         "Name: Alice, Age: 30",
         "Name: Bob, Age: 25",
         "Name: Charlie 王, Age: 35"
     )
 */
- (NSArray *)zhh_filterArrayWithOperator:(NSString *)ope key:(NSString *)key value:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
