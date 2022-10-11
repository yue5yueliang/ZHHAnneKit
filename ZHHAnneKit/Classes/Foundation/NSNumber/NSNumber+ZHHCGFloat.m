//
//  NSNumber+ZHHCGFloat.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSNumber+ZHHCGFloat.h"

@implementation NSNumber (ZHHCGFloat)
- (CGFloat)zhh_CGFloatValue {
#if (CGFLOAT_IS_DOUBLE == 1)
    CGFloat result = [self doubleValue];
#else
    CGFloat result = [self floatValue];
#endif
    return result;
}

- (id)initWithZHHCGFloat:(CGFloat)value {
#if (CGFLOAT_IS_DOUBLE == 1)
    self = [self initWithDouble:value];
#else
    self = [self initWithFloat:value];
#endif
    return self;
}

+ (NSNumber *)zhh_numberWithCGFloat:(CGFloat)value {
    NSNumber *result = [[self alloc] initWithZHHCGFloat:value];
    return result;
}
@end
