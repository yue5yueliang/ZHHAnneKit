//
//  NSString+URL.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
/**
 *  中文转义
 *
 *  @return 转以后的字符
 */
+ (NSString *)zhh_encodedURLString:(NSString *)URLString{
    NSString *encodedURLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedURLString;
}
@end
