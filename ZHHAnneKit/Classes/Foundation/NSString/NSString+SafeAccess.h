//
//  NSString+SafeAccess.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/25.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SafeAccess)
/// 从字符串的起始处提取到某个位置结束
- (NSString *)zhh_substringToIndexSafe:(NSUInteger)to;

/// 从字符串的某个位置开始提取直到字符串的末尾
- (NSString *)zhh_substringFromIndexSafe:(NSInteger)from;

/// 删除字符串中的首字符
- (NSString *)zhh_deleteFirstCharacter;

/// 删除字符串中的末尾字符
- (NSString *)zhh_deleteLastCharacter;
@end

NS_ASSUME_NONNULL_END
