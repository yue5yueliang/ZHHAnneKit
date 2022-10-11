//
//  NSArray+ZHHPredicate.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZHHPredicate)
/// 数组计算交集
- (NSArray *)zhh_intersectionWithOtherArray:(NSArray *)otherArray;

/// 组计算差集
- (NSArray *)zhh_subtractionWithOtherArray:(NSArray *)otherArray;

/// 删除数组相同部分然后追加不同部分
- (NSArray *)zhh_deleteEqualObjectAndMergeWithOtherArray:(NSArray *)otherArray;

/// 过滤数组，排除不需要部分
- (NSArray *)zhh_filterArrayExclude:(BOOL(^)(id object))block;

/// 过滤数组，获取需要部分
- (NSArray *)zhh_filterArrayNeed:(BOOL(^)(id object))block;

/// NSPredicate 除去数组temps中包含的数组targetTemps元素
- (NSArray *)zhh_deleteTargetArray:(NSArray *)temp;

/// 利用 NSSortDescriptor 对对象数组，按照某一属性的升序降序排列
/// @param key target attribute
/// @param ascending Whether to sort in ascending order
- (NSArray *)zhh_sortDescriptorWithKey:(NSString *)key Ascending:(BOOL)ascending;

/// 利用 NSSortDescriptor 对对象数组，按照某些属性的升序降序排列
- (NSArray *)zhh_sortDescriptorWithKeys:(NSArray *)keys Ascendings:(NSArray *)ascendings;

/// 利用 NSSortDescriptor 对对象数组，取出 key 中匹配 value 的元素
/// @param key match condition, support sql syntax
/// @param value matching value
- (NSArray *)zhh_takeOutDatasWithKey:(NSString *)key Value:(NSString *)value;

/// 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
///  beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)，[c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd] 既又
- (NSArray *)zhh_takeOutDatasWithOperator:(NSString *)ope Key:(NSString *)key Value:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
