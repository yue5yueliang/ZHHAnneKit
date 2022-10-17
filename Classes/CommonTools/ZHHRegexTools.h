//
//  ZHHRegexTools.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHRegexTools : NSObject
/** 邮箱正则判断 */
+ (BOOL)zhh_checkEmail:(NSString *)email;
@end

NS_ASSUME_NONNULL_END
