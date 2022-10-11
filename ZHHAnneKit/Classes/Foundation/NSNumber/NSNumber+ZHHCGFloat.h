//
//  NSNumber+ZHHCGFloat.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (ZHHCGFloat)
- (CGFloat)zhh_CGFloatValue;

- (id)initWithZHHCGFloat:(CGFloat)value;

+ (NSNumber *)zhh_numberWithCGFloat:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
