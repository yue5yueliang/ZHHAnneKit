//
//  NSString+ZHHURL.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHURL)

/**
 *  中文转义
 *
 *  @return 转以后的字符
 */
+ (NSString *)zhh_encodedURLString:(NSString *)URLString;
@end

NS_ASSUME_NONNULL_END
