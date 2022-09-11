//
//  NSString+Verify.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Verify)
/// 是否为纯字母
@property (nonatomic, assign, readonly) BOOL isPureLetter;
/// 是否为大写字母
@property (nonatomic, assign, readonly) BOOL isCapitalLetter;
/// 是否为小写字母
@property (nonatomic, assign, readonly) BOOL isLowercaseLetter;
/// 是否为纯汉字
@property (nonatomic, assign, readonly) BOOL isChineseCharacter;
/// 是否包含字母
@property (nonatomic, assign, readonly) BOOL isContainLetter;
/// 是否仅包含字母和数字
@property (nonatomic, assign, readonly) BOOL isLetterAndNumber;
/// 是否以字母开头
@property (nonatomic, assign, readonly) BOOL isLettersBegin;
/// 是否以汉字开头
@property (nonatomic, assign, readonly) BOOL isChineseBegin;

/// 过滤空格
- (NSString *)zhh_filterSpace;

/// 过滤特殊字符
/// @param character filter character
- (NSString *)zhh_removeSpecialCharacter:(NSString * _Nullable)character;

/// 检测字符串中是否有特殊字符
- (BOOL)zhh_validateHaveSpecialCharacter;

/// 验证手机号码是否有效
- (BOOL)zhh_validateMobileNumber;

/// 验证邮箱格式是否正确
- (BOOL)zhh_validateEmail;

/// 判断身份证是否是真实的
- (BOOL)zhh_validateIDCardNumber;

///验证银行卡
- (BOOL)zhh_validateBankCardNumber;

/// 验证IP地址
- (BOOL)zhh_validateIPAddress;
@end

NS_ASSUME_NONNULL_END
