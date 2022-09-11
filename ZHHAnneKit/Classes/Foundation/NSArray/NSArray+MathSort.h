//
//  NSArray+MathSort.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (MathSort)
/// 二进制搜索，此方法适用于数据量较大的情况
- (NSInteger)zhh_binarySearchTarget:(NSInteger)target;
/// 冒泡排序
- (NSArray *)zhh_bubbleSort;
/// 直接插入排序
- (NSArray *)zhh_insertSort;
/// 选择排序
- (NSArray *)zhh_selectionSort;

/// 生成一组不重复的随机数
/// @param min minimum
/// @param max maximum
/// @param count Number of data
/// @return returns 随机数数组
- (NSArray *)zhh_noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger)max count:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
