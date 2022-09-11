//
//  NSString+SafeAccess.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/25.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSString+SafeAccess.h"

@implementation NSString (SafeAccess)
- (NSString *)zhh_substringToIndexSafe:(NSUInteger)to {
    if (self == nil || [self isEqualToString:@""]) {
        return @"";
    }
    if (to > self.length - 1) {
        return @"";
    }
    return  [self substringToIndex:to];
}

- (NSString *)zhh_substringFromIndexSafe:(NSInteger)from {
    if (self == nil || [self isEqualToString:@""]) {
        return @"";
    }
    if (from > self.length - 1) {
        return @"";
    }
    return  [self substringFromIndex:from];
}

- (NSString *)zhh_deleteFirstCharacter {
    return [self zhh_substringFromIndexSafe:1];
}

- (NSString *)zhh_deleteLastCharacter {
    return [self zhh_substringToIndexSafe:self.length - 1];
}
@end
