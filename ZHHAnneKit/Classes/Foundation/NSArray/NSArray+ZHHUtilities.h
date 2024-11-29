//
//  NSArray+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZHHUtilities)
/// 检查NSArray是否为空
- (BOOL)zhh_empty;
/// 将当前对象NSArray 转换为 JSON 字符串
- (NSString *)zhh_jsonString;

/// 安全获取数组中指定索引的元素
/// @param index 要获取的索引值
/// @return 如果索引有效，返回对应的数组元素；如果索引超出范围，返回 nil
- (id _Nullable)zhh_safeObjectAtIndex:(NSUInteger)index;

/// 返回数组的倒序排列
/// @return 倒序排列后的新数组
- (NSArray *)zhh_reverseArray;

/// 移动数组中指定索引的元素到新的索引位置
/// @param index 当前元素的索引
/// @param toIndex 新的位置索引
/// @return 移动后的数组副本
- (NSArray *)zhh_moveIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
/// 将指定元素移动到目标索引位置
/// @param object 要移动的元素
/// @param toIndex 目标索引位置
/// @return 返回移动元素后的新数组
- (NSArray *)zhh_moveObject:(id)object toIndex:(NSInteger)toIndex;
/// 交换数组中两个元素的位置
/// @param index 第一个元素的索引
/// @param toIndex 第二个元素的索引
/// @return 返回交换后生成的新数组
- (NSArray *)zhh_exchangeIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
/**
 * 遍历数组，返回第一个满足条件的对象
 *
 * @param block 筛选条件的 block，返回 YES 时即为找到的对象
 *              block 参数：
 *              - object：当前遍历的元素
 *              - index：当前元素的索引
 *
 * @return 第一个符合条件的对象，如果没有符合条件的则返回 nil
 */
/**
     NSArray *array = @[@1, @3, @5, @7, @9];

     // 查找第一个大于 5 的数字
     NSNumber *first = [array zhh_firstObjectPassingTest:^BOOL(NSNumber *object, NSUInteger index) {
         return object.integerValue > 5;
     }];

     NSLog(@"第一个大于 5: %@", first); // 输出: 第一个大于 5: 7
 */
- (id)zhh_firstObjectPassingTest:(BOOL(^)(id object, NSUInteger index))block;
/**
 * 遍历多维数组，返回第一个满足条件的对象
 *
 * @param recurse 筛选条件的 block，`stop` 参数控制递归是否停止
 *                - object: 当前遍历的对象
 *                - stop: 是否终止递归（设置为 YES 则立即停止）
 *
 * @return 第一个符合条件的对象，如果没有符合条件的则返回 nil
 */
/**
     NSArray *multiArray = @[
         @1,
         @[@3, @5],
         @[@[@7], @9],
         @"test"
     ];

     // 查找第一个大于 5 的数字
     id found = [multiArray zhh_firstObjectInMultiDimensionalArrayPassingTest:^BOOL(id object, BOOL *stop) {
         if ([object isKindOfClass:[NSNumber class]] && [object integerValue] > 5) {
             *stop = YES; // 找到后停止递归
             return YES;
         }
         return NO;
     }];

     NSLog(@"Found: %@", found); // 输出: Found: 7
 */
- (id)zhh_firstObjectInMultiDimensionalArrayPassingTest:(BOOL(^)(id object, BOOL *stop))recurse;
/**
 *  对数组元素进行归纳操作，返回经过比较后的结果
 *
 *  @param object 初始对比对象
 *  @param comparison 比较 block，用于对比数组元素并返回更新后的结果
 *                    - obj1: 当前对比结果
 *                    - obj2: 数组中的下一个元素
 *
 *  @return 返回最终的归纳结果
 */
/**
     NSArray *numbers = @[@1, @2, @3, @4, @5];
     NSNumber *sum = [numbers zhh_reduceWithInitialObject:@0 usingBlock:^id(NSNumber *result, NSNumber *number) {
         return @(result.integerValue + number.integerValue);
     }];
     NSLog(@"Sum: %@", sum); // 输出: Sum: 15
     
     NSArray *numbers = @[@10, @3, @55, @7, @21];
     NSNumber *max = [numbers zhh_reduceWithInitialObject:numbers.firstObject usingBlock:^id(NSNumber *maxValue, NSNumber *current) {
         return (current.integerValue > maxValue.integerValue) ? current : maxValue;
     }];
     NSLog(@"Max: %@", max); // 输出: Max: 55
     
     NSArray *strings = @[@"Hello", @"World", @"!"];
     NSString *concatenated = [strings zhh_reduceWithInitialObject:@"" usingBlock:^id(NSString *result, NSString *current) {
         return [result stringByAppendingString:current];
     }];
     NSLog(@"Concatenated: %@", concatenated); // 输出: Concatenated: HelloWorld!
 */
- (id)zhh_reduceWithInitialObject:(id)object usingBlock:(id (^)(id obj1, id obj2))comparison;

/// 查找数据，返回该对象在数组中的索引，未查询到则返回 -1
/// @param obj 要查找的对象
/// @return 返回对象在数组中的索引，未找到则返回 -1
- (NSInteger)zhh_searchObject:(id)obj;

/// 映射数组中的每个元素，通过 block 处理后返回一个新数组
/// @param map 映射 block，对数组中的每个元素进行处理并返回新的值
/// @return 返回映射后的不可变数组
/**
     NSArray *array = @[@"A", @"B", @"C", @42, [NSNull null]];
     NSArray *mappedArray = [array zhh_mapArray:^id _Nullable(id  _Nonnull object) {
         if ([object isKindOfClass:[NSString class]]) {
             return [object stringByAppendingString:@"_mapped"];
         } else if ([object isKindOfClass:[NSNumber class]]) {
             return @([(NSNumber *)object integerValue] * 2);
         }
         return nil; // 返回 nil 测试 NSNull 占位
     }];
     NSLog(@"映射结果: %@", mappedArray);
     映射结果: (
         "A_mapped",
         "B_mapped",
         "C_mapped",
         84,
         "<null>"
     )
 */
- (NSArray *)zhh_mapArray:(id(^)(id object))map;

/// 映射数组中的每个元素，并支持倒序映射，通过 block 处理后返回一个新数组
/// @param map 映射 block，对数组中的每个元素进行处理并返回新的值
/// @param reverse 是否倒序执行映射操作
/// @return 返回映射后的不可变数组
/**
     NSArray *array = @[@"A", @"B", @"C"];

     // 正序映射：加后缀 "-mapped"
     NSArray *mappedArray = [array zhh_mapArray:^id _Nullable(id  _Nonnull object) {
         return [NSString stringWithFormat:@"%@-mapped", object];
     } reverse:NO];
     NSLog(@"正序映射结果: %@", mappedArray);
     // 输出: 正序映射结果: ( "A-mapped", "B-mapped", "C-mapped" )

     // 倒序映射：加后缀 "-reversed"
     NSArray *reversedMappedArray = [array zhh_mapArray:^id _Nullable(id  _Nonnull object) {
         return [NSString stringWithFormat:@"%@-reversed", object];
     } reverse:YES];
     NSLog(@"倒序映射结果: %@", reversedMappedArray);
     // 输出: 倒序映射结果: ( "C-reversed", "B-reversed", "A-reversed" )
 */
- (NSArray *)zhh_mapArray:(id(^)(id object))map reverse:(BOOL)reverse;

/// 对数组中的每个元素进行映射操作，并根据需求决定是否去重
/// @param map 映射 block，用于对数组中的每个元素进行处理并返回新的值
/// @param repetition 是否去重，YES 表示去重，NO 表示保留重复元素
/// @return 返回映射后的数组，若 repetition 为 YES，则数组中的元素将不重复
/**
     NSArray *array = @[@"apple", @"banana", @"Apple", @"BANANA", @"cherry"];

     // 映射为小写，并去重
     NSArray *lowercaseUnique = [array zhh_mapArray:^id _Nullable(id object) {
         return [object lowercaseString];
     } repetition:YES];
     NSLog(@"Lowercase and unique: %@", lowercaseUnique);

     // 映射为字符串长度，不去重
     NSArray *lengths = [array zhh_mapArray:^id _Nullable(id object) {
         return @([object length]);
     } repetition:NO];
     NSLog(@"Mapped lengths: %@", lengths);

     // 复杂映射：添加前缀和去重
     NSArray *prefixedUnique = [array zhh_mapArray:^id _Nullable(id object) {
         return [NSString stringWithFormat:@"prefix_%@", [object lowercaseString]];
     } repetition:YES];
     NSLog(@"Prefixed and unique: %@", prefixedUnique);
 */
- (NSArray *)zhh_mapArray:(id _Nullable(^)(id object))map repetition:(BOOL)repetition;

/// 检查数组中是否包含满足条件的元素
/// @param contains 条件判断 block，若某个元素满足条件，则返回 YES
/// @return 如果数组中有满足条件的元素，返回 YES；否则，返回 NO
/**
     NSArray *array = @[@"Alice", @"Bob", @"Charlie", @"David"];

     // 检查数组中是否包含以 'C' 开头的元素
     BOOL containsC = [array zhh_containsObject:^BOOL(id object, NSUInteger index) {
         return [object hasPrefix:@"C"];
     }];
     NSLog(@"Contains an element starting with 'C': %@", containsC ? @"YES" : @"NO");

     // 检查数组中是否包含索引为偶数且以 'D' 开头的元素
     BOOL containsEvenD = [array zhh_containsObject:^BOOL(id object, NSUInteger index) {
         return index % 2 == 0 && [object hasPrefix:@"D"];
     }];
     NSLog(@"Contains an element at an even index starting with 'D': %@", containsEvenD ? @"YES" : @"NO");
 */
- (BOOL)zhh_containsObject:(BOOL(^)(id object, NSUInteger index))contains;

/**
 *  从指定位置开始检查数组中是否包含满足条件的元素
 *
 *  @param index 起始位置的索引指针，传入初始值，并在找到满足条件的元素时更新为其索引位置
 *  @param condition 条件判断 block，若某个元素满足条件，则返回 YES
 *
 *  @return 如果从指定位置开始的数组中有满足条件的元素，返回 YES；否则，返回 NO
 */
/**
     NSArray *array = @[@"Alice", @"Bob", @"Charlie", @"David"];

     // 初始化起始索引
     NSInteger startIndex = 1;

     // 查找第一个包含字符 'i' 的元素
     BOOL found = [array zhh_containsFromIndex:&startIndex condition:^BOOL(id object) {
         return [object containsString:@"i"];
     }];

     if (found) {
         NSLog(@"Found an element satisfying the condition at index: %ld, value: %@", startIndex, array[startIndex]);
     } else {
         NSLog(@"No element satisfying the condition was found from the specified index.");
     }

     // 再次查找从新位置开始的下一个包含 'i' 的元素
     startIndex++; // 移动到下一个元素后的位置
     found = [array zhh_containsFromIndex:&startIndex condition:^BOOL(id object) {
         return [object containsString:@"i"];
     }];

     if (found) {
         NSLog(@"Found another element satisfying the condition at index: %ld, value: %@", startIndex, array[startIndex]);
     } else {
         NSLog(@"No further element satisfying the condition was found.");
     }
 */
- (BOOL)zhh_containsFromIndex:(NSInteger * _Nonnull)index condition:(BOOL(^)(id object))condition;

/**
 *  根据条件替换数组中的元素
 *
 *  @param object 替换的元素，不能为空
 *  @param conditionBlock 条件 block，用于决定是否替换元素及是否停止遍历
 *                        - `evaluatedObject`: 当前遍历到的对象
 *                        - `index`: 当前对象的索引
 *                        - `stop`: 用于停止遍历的标志，设置为 `YES` 将停止遍历
 *  @return 替换后的数组，若未发生任何替换，则返回与原数组一致的内容
 */
/**
     NSArray *array = @[@"Alice", @"Bob", @"Charlie", @"David"];
     // 示例1：将数组中第一个满足条件的元素替换为 "Eve"，条件为元素为 "Bob"
     NSArray *result1 = [array zhh_replaceObject:@"Eve" conditionBlock:^BOOL(id evaluatedObject, NSUInteger index, BOOL *stop) {
         if ([evaluatedObject isEqualToString:@"Bob"]) {
             *stop = YES; // 找到后停止遍历
             return YES;  // 替换当前元素
         }
         return NO;
     }];

     // 示例2：替换所有包含 "i" 字符的元素为 "Replaced"
     NSArray *result2 = [array zhh_replaceObject:@"Replaced" conditionBlock:^BOOL(id evaluatedObject, NSUInteger index, BOOL *stop) {
         return [evaluatedObject containsString:@"i"];
     }];

     // 示例3：未找到满足条件的元素，数组保持原样
     NSArray *result3 = [array zhh_replaceObject:@"NewElement" conditionBlock:^BOOL(id evaluatedObject, NSUInteger index, BOOL *stop) {
         return [evaluatedObject isEqualToString:@"NonExisting"];
     }];
 */
- (NSArray *)zhh_replaceObject:(nonnull id)object conditionBlock:(BOOL(^)(id evaluatedObject, NSUInteger index, BOOL *stop))conditionBlock;

/**
 *  根据条件将指定对象插入到目标位置
 *
 *  @param object 要插入的对象（不能为空）
 *  @param condition 条件 block，用于判断插入位置
 *                   - object：当前遍历到的对象
 *                   - index：当前对象的索引
 *  @return 返回插入数据后的新数组
 */
/**
     NSArray *array = @[@"Alice", @"Bob", @"Charlie"];

     // 示例1：将对象插入到 "Bob" 之后
     NSArray *result1 = [array zhh_insertObject:@"David" condition:^BOOL(id object, NSUInteger index) {
         return [object isEqualToString:@"Bob"];
     }];

     // 示例2：将对象插入到索引为1之前
     NSArray *result2 = [array zhh_insertObject:@"Eve" condition:^BOOL(id object, NSUInteger index) {
         return index == 1;
     }];

     // 示例3：对象没有匹配到，插入到末尾
     NSArray *result3 = [array zhh_insertObject:@"Frank" condition:^BOOL(id object, NSUInteger index) {
         return [object isEqualToString:@"NonExisting"];
     }];
 */
- (NSArray *)zhh_insertObject:(nonnull id)object condition:(BOOL(^)(id object, NSUInteger index))condition;

/// 判断当前数组与另一个数组是否包含相同的元素（不考虑顺序）
/// @param otherArray 需要比较的数组
/// @return 如果两个数组包含的元素一致（无论顺序），返回 YES，否则返回 NO
- (BOOL)zhh_isEqualToArrayIgnoringOrder:(NSArray *)otherArray;

/// 从数组中剔除指定的元素
/// @param array 需要剔除的元素集合
/// @return 剔除后生成的新数组
- (NSArray *)zhh_excludeObjectsInArray:(NSArray *)array;

/// MARK: - 随机获取数组中的一个元素
/// 从数组中随机返回一个元素。
/// @return 如果数组非空，返回随机的一个元素；如果数组为空，返回 nil。
- (nullable id)zhh_randomObject;

/// MARK: - 随机打乱数组
/// 将数组中的元素随机打乱顺序，并返回一个新的数组。
/// @return 返回一个随机打乱顺序的新数组。
- (NSArray *)zhh_shuffleArray;

/// MARK: - 删除数组中的重复元素
/// 删除数组中的重复元素，并返回去重后的数组。
/// @return 返回一个新的去重后的数组。
- (NSArray *)zhh_removeDuplicateElements;


// MARK: - 二分查找（适用于升序排序的数组）
/*
 * 基本思想：
 * 假设数组是按升序排序的，对于给定值 `target`：
 * - 从序列的中间位置开始比较，如果中间值等于 `target`，查找成功；
 * - 如果 `target` 小于中间值，则在前半部分继续查找；
 * - 如果 `target` 大于中间值，则在后半部分继续查找；
 * - 重复以上过程，直到找到目标值或查找范围为空。
     NSArray *sortedArray = @[@1, @3, @5, @7, @9];
     NSInteger target = 5;
     NSInteger index = [sortedArray zhh_findIndexWithBinarySearch:target];
     if (index != -1) {
         NSLog(@"找到目标值 %ld，索引为 %ld", target, index);
     } else {
         NSLog(@"未找到目标值 %ld", target);
     }
 */
- (NSInteger)zhh_findIndexWithBinarySearch:(NSInteger)target;
// MARK: - 冒泡排序
/*
 1. 从第一个元素开始，逐个比较相邻两个元素的大小。
 2. 如果左边元素大于右边元素，交换两个元素。
 3. 对未排序的部分重复步骤1和2，直至没有需要交换的元素。
     NSArray *unsortedArray = @[@5, @3, @8, @6, @2];
     NSArray *sortedArray = [unsortedArray zhh_sortUsingBubbleSort];
     NSLog(@"Sorted Array: %@", sortedArray);
     // Output: Sorted Array: (2, 3, 5, 6, 8)
 */
- (NSArray *)zhh_sortUsingBubbleSort;
// MARK: - 插入排序
/*
 1. 从第一个元素开始，认为该元素已经排好序。
 2. 取下一个元素，从已排好序的部分从后向前扫描。
 3. 如果已排好序的元素大于当前元素，则将该元素右移一位。
 4. 直到找到比当前元素小的位置，插入该元素。
 5. 重复以上步骤，直到数组有序。
     NSArray *unsortedArray = @[@5, @2, @8, @3, @1];
     NSArray *sortedArray = [unsortedArray zhh_sortUsingInsertionSort];
     NSLog(@"Sorted Array: %@", sortedArray);
     // Output: Sorted Array: (1, 2, 3, 5, 8)
 */
- (NSArray *)zhh_sortUsingInsertionSort;
// MARK: - 选择排序
/*
 1. 从第一个元素开始，将其视为最小值。
 2. 遍历剩余的元素，寻找更小的值。
 3. 找到更小的值后，与当前最小值交换位置。
 4. 重复以上步骤，直到数组排序完成。
     NSArray *unsortedArray = @[@4, @2, @7, @1, @9];
     NSArray *sortedArray = [unsortedArray zhh_sortUsingSelectionSort];
     NSLog(@"Sorted Array: %@", sortedArray);
     // Output: Sorted Array: (1, 2, 4, 7, 9)
 */
- (NSArray *)zhh_sortUsingSelectionSort;

/// 生成一组不重复的随机数
/// @param min 最小值
/// @param max 最大值
/// @param count 随机数的个数
/// NSArray *randomNumbers = [self zhh_generateUniqueRandomNumbersWithMin:1 max:100 count:10];
/// NSLog(@"Random Numbers: %@", randomNumbers);
/// Output: Random Numbers: (34, 12, 78, 56, 23, 89, 45, 67, 90, 11) （结果随机）
- (NSArray *)zhh_generateUniqueRandomNumbersWithMin:(NSInteger)min max:(NSInteger)max count:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
