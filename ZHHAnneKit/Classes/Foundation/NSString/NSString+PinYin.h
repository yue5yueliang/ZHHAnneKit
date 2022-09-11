//
//  NSString+PinYin.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PinYin)
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



/**
 *  是否包含中文
 *
 *  @return BOOL值
 */
- (BOOL)zhh_isContainChinese;
@end

NS_ASSUME_NONNULL_END
