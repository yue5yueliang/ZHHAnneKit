//
//  NSString+ZHHPinYin.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHPinYin)
- (NSString *)zhh_pinyin;
- (NSString *)zhh_pinyinInitial;
/**
 * 汉字转为拼音
 */
- (NSString*)zhh_chineseStringTransformToPinYin;

/**
 *  获取汉字的首字的首字母大写
 *
 *  @return 汉字的首字的首字母大写
 */
- (NSString*)zhh_fisrtUppercasePinYin;

@end

NS_ASSUME_NONNULL_END
