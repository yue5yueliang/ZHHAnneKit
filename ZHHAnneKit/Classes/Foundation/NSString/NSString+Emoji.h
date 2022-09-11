//
//  NSString+Emoji.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Emoji)
/// 是否是表情
@property (nonatomic, assign, readonly) BOOL isEmoji;
/// 是否包含表情
@property (nonatomic, assign, readonly) BOOL isContainEmoji;

/// 删除Emoji
- (NSString *)zhh_removedEmojiString;
@end

NS_ASSUME_NONNULL_END
