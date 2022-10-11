//
//  NSArray+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZHHExtend)
/// 它是空的吗
@property (nonatomic, assign, readonly) BOOL isEmpty;

/// 转换为json字符串
@property (nonatomic, strong, readonly) NSString *zhh_jsonString;
/**
 *  通过给出的索引在安全的情况下获取一个对象(如果数组本身为空或者索引超出了范围则返回nil)
 *
 *  @param index 索引
 *
 *  @return 返回在安全的情况下通过索引获取的对象(如果数组本身为空或者索引超出了范围则返回nil)
 */
- (id _Nullable)zhh_safeObjectAtIndex:(NSUInteger)index;
/// 加载json数据
+ (NSArray *)zhh_loadJSONDataWithFileName:(NSString *)fileName;
/**
 *  倒序排列
 */
- (NSArray * _Nonnull)zhh_reverseArray;
/// 移动对象元素位置
/// @param index 移动下标
/// @param toIndex 移动位置
- (NSArray *)zhh_moveIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
/// 移动元素
/// @param object to move the element, it needs to be unique otherwise it will cause problems
/// @param toIndex move position
- (NSArray *)zhh_moveObject:(id)object toIndex:(NSInteger)toIndex;
/// 交换位置
/// @param index exchange elements
/// @param toIndex exchange position
- (NSArray *)zhh_exchangeIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
/// 筛选数据
- (id)zhh_detectArray:(BOOL(^)(id object, int index))block;
/// 多维数组筛选数据
- (id)zhh_detectManyDimensionArray:(BOOL(^)(id object, BOOL * stop))recurse;
/// 归纳对比选择，最终返回经过对比之后的数据
/// @param object 要比较的数据
/// @param comparison contrast callback
/// @return returns 比较后的数据
- (id)zhh_reduceObject:(id)object comparison:(id(^)(id obj1, id obj2))comparison;
/// 查找数据，返回-1表示未查询到
- (NSInteger)zhh_searchObject:(id)object;

/// 映射
- (NSArray *)zhh_mapArray:(id(^)(id object))map;
/// 映射，是否倒序
/// @param map mapping callback
/// @param reverse 是否颠倒顺序
- (NSArray *)zhh_mapArray:(id(^)(id object))map reverse:(BOOL)reverse;
/// 映射和过滤数据
/// @param map Map and filter events, return the mapped data, return nil to filter the data
/// @param repetition does it need to be repetitive
- (NSArray *)zhh_mapArray:(id _Nullable(^)(id object))map repetition:(BOOL)repetition;

/// 包含数据
- (BOOL)zhh_containsObject:(BOOL(^)(id object, NSUInteger index))contains;
/// 指定位置之后是否包含数据
/// @param index specifies the position and returns the corresponding position of the data
/// @param contains callback event, return yes to include the data
/// @return returns whether the data is included
- (BOOL)zhh_containsFromIndex:(inout NSInteger * _Nonnull)index contains:(BOOL(^)(id object))contains;
/// 替换数组指定元素
/// @param object replacement element
/// @param operation callback event, return yes to replace the data, stop controls whether to replace all
/// @return returns the array after replacement
- (NSArray *)zhh_replaceObject:(id)object operation:(BOOL(^)(id object, NSUInteger index, BOOL * stop))operation;
/// 插入数据到目的位置
/// @param object 要插入的元素
/// @param aim 回调事件，返回yes以插入数据
/// @return returns 插入后的阵列
- (NSArray *)zhh_insertObject:(id)object aim:(BOOL(^)(id object, int index))aim;

/// 判断两个数组包含元素是否一致
- (BOOL)zhh_isEqualOtherArray:(NSArray *)otherArray;

/// 随机打乱数组
- (NSArray *)zhh_disorganizeArray;
/// 删除数组当中的相同元素
- (NSArray *)zhh_deleteArrayEquelObject;
/// 随机数组当中一条数据
- (nullable id)zhh_randomObject;
/// 数组剔除器
/// @param array 需要剔除的数据
- (NSArray *)zhh_pickArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
