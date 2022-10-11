//
//  NSString+ZHHEmojiRemove.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHEmojiRemove)
///移除所有emoji，以“”替换
- (NSString *)zhh_removingEmoji;
///移除所有emoji，以“”替换
- (NSString *)zhh_stringByRemovingEmoji;
///移除所有emoji，以string替换
- (NSString *)zhh_stringByReplaceingEmojiWithString:(NSString*)string;

///字符串是否包含emoji
- (BOOL)zhh_containsEmoji;
///字符串中包含的所有emoji unicode格式
- (NSArray<NSString *>*)zhh_allEmoji;
///字符串中包含的所有emoji
- (NSString *)zhh_allEmojiString;
///字符串中包含的所有emoji rang
- (NSArray<NSString *>*)zhh_allEmojiRanges;

///所有emoji表情
+ (NSString*)zhh_allSystemEmoji;
@end

@interface NSCharacterSet (ZHHEmojiCharacterSet)
+ (NSCharacterSet *)zhh_emojiCharacterSet;
@end
NS_ASSUME_NONNULL_END
