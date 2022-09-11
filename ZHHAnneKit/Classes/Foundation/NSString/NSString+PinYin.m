//
//  NSString+PinYin.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSString+PinYin.h"

@implementation NSString (PinYin)
- (NSString *)zhh_pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)zhh_pinyinInitial{
    if (self.length == 0) {
        return nil;
    }
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    
    return initial;
}

- (NSString *)zhh_chineseStringTransformToPinYin {
    
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    // 转为带声调的拉丁文
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    // 去掉声调
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, NO);
    return mutableString;
}


- (NSString *)zhh_fisrtUppercasePinYin {
    NSString *str = [self zhh_chineseStringTransformToPinYin];
    return  [[str uppercaseString] substringToIndex:1];
}


- (BOOL)zhh_isContainChinese {
    for (int i = 0; i<self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
