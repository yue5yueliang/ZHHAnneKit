//
//  NSString+ZHHPasswordLevel.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// Password strength level
typedef NS_ENUM(NSUInteger, ZHHPasswordLevel) {
    ZHHPasswordLevelEasy = 0,
    ZHHPasswordLevelMidium,
    ZHHPasswordLevelStrong,
    ZHHPasswordLevelVeryStrong,
    ZHHPasswordLevelExtremelyStrong,
};

@interface NSString (ZHHPasswordLevel)
/// 确定字符串中的每个字符是否相等
- (BOOL)zhh_isCharEqual;

/// Password strength level
- (ZHHPasswordLevel)zhh_passwordLevel;

#pragma mark-Chinese character related processing

/// 将汉字转换为拼音
@property (nonatomic, strong, readonly) NSString *pinYin;
/// 随机汉字
extern NSString * kRandomChinese(NSInteger count);
/// 按字母顺序
extern NSArray * kDoraemonBoxAlphabetSort(NSArray<NSString *> * array);

/// 查找数据
/// @param array 数据源
/// @return returns 找到的数据的索引，并返回“-1”，表示尚未找到该数据
- (NSInteger)zhh_searchArray:(NSArray<NSString *> *)array;
@end

NS_ASSUME_NONNULL_END
