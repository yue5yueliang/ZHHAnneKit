//
//  NSArray+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSArray+ZHHUtilities.h"

@implementation NSArray (ZHHUtilities)
- (BOOL)zhh_empty {
    return ([self isKindOfClass:[NSNull class]] || self.count == 0);
}

/// 将当前对象NSArray 转换为 JSON 字符串
- (NSString *)zhh_jsonString {
    // 检查当前对象是否是一个有效的 JSON 对象（NSArray 或 NSDictionary）
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return @"Error: Object cannot be serialized to JSON"; // 如果无效，返回错误信息
    }
    
    // 定义一个错误对象来捕获可能的错误
    NSError *error;
    
    // 配置选项，调试模式下使用漂亮的打印格式
    NSJSONWritingOptions options = 0;
#ifdef DEBUG
    options = NSJSONWritingPrettyPrinted; // 在调试模式下使用格式化输出
#endif
    
    // 将对象转换为 JSON 数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    
    // 如果转换成功，将 JSON 数据转换为字符串并返回
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        // 如果转换失败，返回错误信息
        return [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    }
}

/// 安全获取数组中指定索引的元素
/// @param index 要获取的索引值
/// @return 如果索引有效，返回对应的数组元素；如果索引超出范围，返回 nil
- (id _Nullable)zhh_safeObjectAtIndex:(NSUInteger)index {
    return (index < self.count) ? self[index] : nil;
}

/// 返回数组的倒序排列
/// @return 倒序排列后的新数组
- (NSArray *)zhh_reverseArray {
    return [[self reverseObjectEnumerator] allObjects];
}

/// 移动数组中指定索引的元素到新的索引位置
/// @param index 当前元素的索引
/// @param toIndex 新的位置索引
/// @return 移动后的数组副本
- (NSArray *)zhh_moveIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    // 创建数组的可变副本
    NSMutableArray *temp = [self mutableCopy];
    
    // 检查目标索引是否有效，且索引不同
    if (index != toIndex && index < temp.count && toIndex < temp.count) {
        id obj = temp[index];
        [temp removeObjectAtIndex:index];  // 移除当前元素
        
        // 如果目标索引在当前数组末尾，直接追加
        if (toIndex >= temp.count) {
            [temp addObject:obj];
        } else {
            [temp insertObject:obj atIndex:toIndex];  // 在目标位置插入元素
        }
    }
    
    return [temp copy];  // 返回不可变副本
}

/// 将指定元素移动到目标索引位置
/// @param object 要移动的元素
/// @param toIndex 目标索引位置
/// @return 返回移动元素后的新数组
- (NSArray *)zhh_moveObject:(id)object toIndex:(NSInteger)toIndex {
    // 创建数组的可变副本
    NSMutableArray *temp = [self mutableCopy];
    
    // 确保数组中存在目标对象
    if ([temp containsObject:object]) {
        [temp removeObject:object]; // 移除对象
        
        // 根据目标索引插入对象
        if (toIndex >= temp.count) {
            [temp addObject:object]; // 索引超出范围，追加到末尾
        } else {
            [temp insertObject:object atIndex:toIndex]; // 插入到目标索引
        }
    }
    
    return [temp copy]; // 返回不可变数组
}

/// 交换数组中两个元素的位置
/// @param index 第一个元素的索引
/// @param toIndex 第二个元素的索引
/// @return 返回交换后生成的新数组
- (NSArray *)zhh_exchangeIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    // 创建数组的可变副本
    NSMutableArray *temp = [self mutableCopy];
    
    // 检查索引是否有效且两索引不同
    if (index >= 0 && toIndex >= 0 && index < temp.count && toIndex < temp.count && index != toIndex) {
        [temp exchangeObjectAtIndex:index withObjectAtIndex:toIndex]; // 交换元素
    }
    
    return [temp copy]; // 返回不可变数组
}

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
- (id)zhh_firstObjectPassingTest:(BOOL(^)(id object, NSUInteger index))block {
    if (!block) return nil; // 防止 block 为 nil
    
    for (NSUInteger i = 0; i < self.count; i++) {
        id object = self[i];
        if (block(object, i)) { // 如果条件满足，返回该对象
            return object;
        }
    }
    return nil; // 如果没有找到符合条件的对象，返回 nil
}

/**
 * 遍历多维数组，返回第一个满足条件的对象
 *
 * @param recurse 筛选条件的 block，`stop` 参数控制终止条件
 *                - object: 当前遍历的对象
 *                - stop: 是否终止遍历（设置为 YES 则立即停止）
 *
 * @return 第一个符合条件的对象，如果没有符合条件的则返回 nil
 */
- (id)zhh_firstObjectInMultiDimensionalArrayPassingTest:(BOOL(^)(id object, BOOL *stop))recurse {
    if (!recurse) return nil; // 防止 block 为 nil

    // 使用显式栈结构代替递归
    NSMutableArray *stack = [NSMutableArray arrayWithArray:self];
    while (stack.count > 0) {
        id object = [stack lastObject];
        [stack removeLastObject];
        
        BOOL stop = NO;

        // 如果是子数组，将其展开并入栈
        if ([object isKindOfClass:[NSArray class]]) {
            [stack addObjectsFromArray:object];
        } else if (recurse(object, &stop)) {
            return object; // 找到第一个符合条件的对象
        }

        if (stop) {
            break; // 终止整个遍历
        }
    }

    return nil; // 如果没有找到符合条件的对象，返回 nil
}

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
- (id)zhh_reduceWithInitialObject:(id)object usingBlock:(id (^)(id obj1, id obj2))comparison {
    if (!comparison || !object) return object; // 防止 block 或初始对象为空

    id result = object;
    for (id obj in self) {
        result = comparison(result, obj);
    }
    return result;
}

/// 查找数据，返回该对象在数组中的索引，未查询到则返回 -1
/// @param obj 要查找的对象
/// @return 返回对象在数组中的索引，未找到则返回 -1
- (NSInteger)zhh_searchObject:(id)obj {
    if (!obj) return -1; // 检查传入对象是否为空
    
    __block NSInteger idx = -1; // 初始化索引为 -1
    [self enumerateObjectsUsingBlock:^(id _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        if ([object isEqual:obj]) {
            idx = index; // 更新索引
            *stop = YES; // 提前终止遍历
        }
    }];
    return idx;
}

/// 映射数组中的每个元素，通过 block 处理后返回一个新数组
/// @param map 映射 block，对数组中的每个元素进行处理并返回新的值
/// @return 返回映射后的不可变数组
- (NSArray *)zhh_mapArray:(id(^)(id object))map {
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        id mappedObject = map(object);
        [mappedArray addObject:mappedObject ?: [NSNull null]]; // 确保 nil 被转换为 NSNull
    }
    return [mappedArray copy]; // 返回不可变数组
}

/// 映射数组中的每个元素，并支持倒序映射，通过 block 处理后返回一个新数组
/// @param map 映射 block，对数组中的每个元素进行处理并返回新的值
/// @param reverse 是否倒序执行映射操作
/// @return 返回映射后的不可变数组
- (NSArray *)zhh_mapArray:(id(^)(id object))map reverse:(BOOL)reverse {
    NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerationOptions options = reverse ? NSEnumerationReverse : 0; // 选择正序或倒序

    [self enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id mappedObject = map(obj);
        [mappedArray addObject:mappedObject ?: [NSNull null]]; // 避免 nil，使用 NSNull 占位
    }];

    return [mappedArray copy]; // 返回不可变数组
}

/// 对数组中的每个元素进行映射操作，并根据需求决定是否去重
/// @param map 映射 block，用于对数组中的每个元素进行处理并返回新的值
/// @param repetition 是否去重，YES 表示去重，NO 表示保留重复元素
/// @return 返回映射后的数组，若 repetition 为 YES，则数组中的元素将不重复
- (NSArray *)zhh_mapArray:(id _Nullable(^)(id object))map repetition:(BOOL)repetition {
    NSMutableArray *mappedArray = [NSMutableArray array];
    NSMutableSet *seenSet = [NSMutableSet set]; // 用于去重时的检查
    
    for (id object in self) {
        id mappedObject = map(object);
        if (!mappedObject) continue; // 跳过 nil 的结果
        
        if (repetition) {
            // 如果去重模式，检查是否已添加
            if (![seenSet containsObject:mappedObject]) {
                [mappedArray addObject:mappedObject];
                [seenSet addObject:mappedObject];
            }
        } else {
            // 非去重模式，直接添加
            [mappedArray addObject:mappedObject];
        }
    }
    return [mappedArray copy]; // 返回不可变数组
}

/// 检查数组中是否包含满足条件的元素
/// @param contains 条件判断 block，若某个元素满足条件，则返回 YES
/// @return 如果数组中有满足条件的元素，返回 YES；否则，返回 NO
- (BOOL)zhh_containsObject:(BOOL(^)(id object, NSUInteger index))contains {
    if (!contains) {
        return NO; // 无条件 block 时直接返回 NO
    }

    // 遍历数组并检查条件
    for (NSUInteger i = 0; i < self.count; i++) {
        if (contains(self[i], i)) {
            return YES; // 一旦找到匹配项，直接返回 YES
        }
    }
    return NO; // 如果未找到匹配项，返回 NO
}

/**
 *  从指定位置开始检查数组中是否包含满足条件的元素
 *
 *  @param index 起始位置的索引指针，传入初始值，并在找到满足条件的元素时更新为其索引位置
 *  @param condition 条件判断 block，若某个元素满足条件，则返回 YES
 *
 *  @return 如果从指定位置开始的数组中有满足条件的元素，返回 YES；否则，返回 NO
 */
- (BOOL)zhh_containsFromIndex:(NSInteger * _Nonnull)index condition:(BOOL(^)(id object))condition {
    // 参数校验
    if (!condition || *index >= self.count || *index < 0) {
        return NO;
    }
    
    // 从指定索引开始遍历数组
    for (NSInteger i = *index; i < self.count; i++) {
        if (condition(self[i])) {
            *index = i; // 更新索引为满足条件的元素的位置
            return YES;
        }
    }
    return NO;
}

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
- (NSArray *)zhh_replaceObject:(nonnull id)object conditionBlock:(BOOL(^)(id evaluatedObject, NSUInteger index, BOOL *stop))conditionBlock {
    if (!object || !conditionBlock) {
        return self; // 如果参数无效，直接返回原数组
    }
    
    NSMutableArray *mutableArray = [self mutableCopy];
    [mutableArray enumerateObjectsUsingBlock:^(id _Nonnull currentObject, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL shouldStop = NO;
        
        // 如果条件满足，替换元素
        if (conditionBlock(currentObject, idx, &shouldStop)) {
            mutableArray[idx] = object;
        }
        
        // 如果设置了停止标志，则停止遍历
        if (shouldStop) {
            *stop = YES;
        }
    }];
    
    return [mutableArray copy];
}

/**
 *  根据条件将指定对象插入到目标位置
 *
 *  @param object 要插入的对象（不能为空）
 *  @param condition 条件 block，用于判断插入位置
 *                   - object：当前遍历到的对象
 *                   - index：当前对象的索引
 *  @return 返回插入数据后的新数组
 */
- (NSArray *)zhh_insertObject:(nonnull id)object condition:(BOOL(^)(id object, NSUInteger index))condition {
    if (!object || !condition) {
        return self; // 如果参数无效，返回原数组
    }
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count + 1];
    BOOL inserted = NO;

    for (NSUInteger i = 0; i < self.count; i++) {
        id currentObject = self[i];
        [resultArray addObject:currentObject];
        
        // 如果条件满足且尚未插入
        if (!inserted && condition(currentObject, i)) {
            [resultArray addObject:object];
            inserted = YES;
        }
    }
    
    // 如果遍历结束还未插入，将新对象追加到最后
    if (!inserted) {
        [resultArray addObject:object];
    }
    
    return [resultArray copy];
}

/// 判断当前数组与另一个数组是否包含相同的元素（不考虑顺序）
/// @param otherArray 需要比较的数组
/// @return 如果两个数组包含的元素一致（无论顺序），返回 YES，否则返回 NO
- (BOOL)zhh_isEqualToArrayIgnoringOrder:(NSArray *)otherArray {
    // 如果数组长度不同，直接返回 NO
    if (self.count != otherArray.count) {
        return NO;
    }

    // 使用 NSSet 来忽略元素的顺序进行比较
    NSSet *selfSet = [NSSet setWithArray:self];
    NSSet *otherSet = [NSSet setWithArray:otherArray];
    
    return [selfSet isEqualToSet:otherSet];
}

/// 从数组中剔除指定的元素
/// @param array 需要剔除的元素集合
/// @return 剔除后生成的新数组
- (NSArray *)zhh_excludeObjectsInArray:(NSArray *)array {
    if (!array || array.count == 0) return self; // 如果剔除列表为空，直接返回原数组
    if (self.count == 0) return @[];            // 如果原数组为空，直接返回空数组
    
    // 转为 Set 提高剔除效率
    NSMutableSet *setToRemove = [NSMutableSet setWithArray:array];
    
    // 过滤出不在剔除集合中的元素
    NSArray *filteredArray = [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![setToRemove containsObject:evaluatedObject];
    }]];
    
    return filteredArray;
}

/// MARK: - 随机获取数组中的一个元素
/// 从数组中随机返回一个元素。
/// @return 如果数组非空，返回随机的一个元素；如果数组为空，返回 nil。
- (nullable id)zhh_randomObject {
    if (self.count == 0) return nil; // 如果数组为空，直接返回 nil
    NSUInteger randomIndex = arc4random_uniform((u_int32_t)self.count);
    return self[randomIndex];
}

/// MARK: - 随机打乱数组
/// 将数组中的元素随机打乱顺序，并返回一个新的数组。
/// @return 返回一个随机打乱顺序的新数组。
- (NSArray *)zhh_shuffleArray {
    if (self.count == 0) return self; // 如果数组为空，直接返回原数组
    
    NSMutableArray *mutableArray = [self mutableCopy];
    NSUInteger count = mutableArray.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 生成一个随机索引，用于交换
        NSUInteger randomIndex = arc4random_uniform((u_int32_t)count);
        // 交换当前位置和随机索引位置的元素
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
    }
    
    return [mutableArray copy];
}
/// MARK: - 删除数组中的重复元素
/// 删除数组中的重复元素，并返回去重后的数组。
/// @return 返回一个新的去重后的数组。
- (NSArray *)zhh_removeDuplicateElements {
    if (self.count == 0) return self; // 如果数组为空，直接返回自身
    return [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
}

// MARK: - 二分查找（适用于升序排序的数组）
/*
 * 基本思想：
 * 假设数组是按升序排序的，对于给定值 `target`：
 * - 从序列的中间位置开始比较，如果中间值等于 `target`，查找成功；
 * - 如果 `target` 小于中间值，则在前半部分继续查找；
 * - 如果 `target` 大于中间值，则在后半部分继续查找；
 * - 重复以上过程，直到找到目标值或查找范围为空。
 */
- (NSInteger)zhh_findIndexWithBinarySearch:(NSInteger)target {
    if (self == nil || self.count == 0) return -1; // 边界条件，避免数组为空时崩溃
    
    NSInteger start = 0;
    NSInteger end = self.count - 1;
    
    while (start <= end) { // 注意使用 `<=`，确保范围内所有元素都被检查
        NSInteger mid = start + (end - start) / 2; // 防止溢出的写法
        
        NSInteger midValue = [self[mid] integerValue];
        
        if (midValue == target) {
            return mid; // 找到目标值，返回索引
        } else if (midValue > target) {
            end = mid - 1; // 缩小范围到前半部分
        } else {
            start = mid + 1; // 缩小范围到后半部分
        }
    }
    
    return -1; // 未找到目标值
}

// MARK: - 冒泡排序
/*
 1. 从第一个元素开始，逐个比较相邻两个元素的大小。
 2. 如果左边元素大于右边元素，交换两个元素。
 3. 对未排序的部分重复步骤1和2，直至没有需要交换的元素。
 */
- (NSArray *)zhh_sortUsingBubbleSort {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    NSInteger count = [array count];
    if (count <= 1) return array; // 如果元素数量小于等于1，则直接返回

    for (NSInteger i = 0; i < count - 1; ++i) {
        BOOL swapped = NO; // 添加优化标记，判断是否发生了交换
        for (NSInteger j = 0; j < count - i - 1; ++j) {
            if ([array[j] compare:array[j + 1]] == NSOrderedDescending) {
                // 交换位置
                [array exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                swapped = YES;
            }
        }
        if (!swapped) break; // 如果未发生交换，则说明已排序完成
    }
    return [array copy]; // 返回不可变数组
}

// MARK: - 插入排序
/*
 1. 从第一个元素开始，认为该元素已经排好序。
 2. 取下一个元素，从已排好序的部分从后向前扫描。
 3. 如果已排好序的元素大于当前元素，则将该元素右移一位。
 4. 直到找到比当前元素小的位置，插入该元素。
 5. 重复以上步骤，直到数组有序。
 */
- (NSArray *)zhh_sortUsingInsertionSort {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    NSInteger count = [array count];
    if (count <= 1) return array; // 如果只有一个元素或为空，则直接返回

    for (NSInteger i = 1; i < count; ++i) {
        id currentElement = array[i];
        NSInteger j = i;
        // 从后向前扫描并比较
        while (j > 0 && [currentElement compare:array[j - 1]] == NSOrderedAscending) {
            array[j] = array[j - 1]; // 将大于当前元素的元素右移
            j--;
        }
        array[j] = currentElement; // 插入当前元素到正确位置
    }
    return [array copy]; // 返回不可变数组
}

// MARK: - 选择排序
/*
 1. 从第一个元素开始，将其视为最小值。
 2. 遍历剩余的元素，寻找更小的值。
 3. 找到更小的值后，与当前最小值交换位置。
 4. 重复以上步骤，直到数组排序完成。
 */
- (NSArray *)zhh_sortUsingSelectionSort {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    NSInteger count = [array count];
    if (count <= 1) return array; // 如果为空或只有一个元素，直接返回

    for (NSInteger i = 0; i < count - 1; ++i) {
        NSInteger minIndex = i;
        // 寻找从 i 到末尾的最小值
        for (NSInteger j = i + 1; j < count; ++j) {
            if ([array[j] compare:array[minIndex]] == NSOrderedAscending) {
                minIndex = j;
            }
        }
        // 如果找到的最小值与当前位置不同，交换
        if (minIndex != i) {
            id temp = array[minIndex];
            array[minIndex] = array[i];
            array[i] = temp;
        }
    }
    return [array copy]; // 返回不可变数组
}

/// 生成一组不重复的随机数
/// @param min 最小值
/// @param max 最大值
/// @param count 随机数的个数
- (NSArray *)zhh_generateUniqueRandomNumbersWithMin:(NSInteger)min max:(NSInteger)max count:(NSInteger)count {
    if (min > max || count <= 0 || (max - min + 1) < count) {
        // 检查输入是否有效：范围必须合法且可以生成足够的随机数
        return @[];
    }
    
    NSMutableSet *randomSet = [NSMutableSet setWithCapacity:count];
    while (randomSet.count < count) {
        NSInteger value = arc4random_uniform((uint32_t)(max - min + 1)) + min;
        [randomSet addObject:@(value)];
    }
    
    // 打乱结果以确保顺序随机
    NSMutableArray *result = [randomSet.allObjects mutableCopy];
    for (NSInteger i = result.count - 1; i > 0; --i) {
        NSInteger j = arc4random_uniform((uint32_t)(i + 1));
        [result exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    return [result copy];
}
@end
