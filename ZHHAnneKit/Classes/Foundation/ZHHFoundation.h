//
//  ZHHFoundation.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#ifndef ZHHFoundation_h
#define ZHHFoundation_h

#if __has_include(<ZHHAnneKit/ZHHFoundation.h>)
#import <ZHHAnneKit/NSArray+ZHHExtend.h>
#import <ZHHAnneKit/NSArray+ZHHMathSort.h>
#import <ZHHAnneKit/NSArray+ZHHPredicate.h>
#import <ZHHAnneKit/NSAttributedString+ZHHExtend.h>
#import <ZHHAnneKit/NSBundle+ZHHAppIcon.h>
#import <ZHHAnneKit/NSData+ZHHAPNSToken.h>
#import <ZHHAnneKit/NSData+ZHHDataCache.h>
#import <ZHHAnneKit/NSData+ZHHEncrypt.h>
#import <ZHHAnneKit/NSData+ZHHGzip.h>
#import <ZHHAnneKit/NSData+ZHHHash.h>
#import <ZHHAnneKit/NSDate+ZHHDayWeek.h>
#import <ZHHAnneKit/NSDate+ZHHFormat.h>
#import <ZHHAnneKit/NSDate+ZHHExtend.h>
#import <ZHHAnneKit/NSDecimalNumber+ZHHExtend.h>
#import <ZHHAnneKit/NSDictionary+ZHHExtend.h>
#import <ZHHAnneKit/NSDictionary+ZHHMerge.h>
#import <ZHHAnneKit/NSDictionary+ZHHXML.h>
#import <ZHHAnneKit/NSDictionary+ZHHURL.h>
#import <ZHHAnneKit/NSException+ZHHTrace.h>
#import <ZHHAnneKit/NSFileManager+ZHHExtend.h>
#import <ZHHAnneKit/NSIndexPath+ZHHOffset.h>
#import <ZHHAnneKit/NSNotification+ZHHExtend.h>
#import <ZHHAnneKit/NSNotificationCenter+ZHHMainThread.h>
#import <ZHHAnneKit/NSNumber+ZHHCGFloat.h>
#import <ZHHAnneKit/NSNumber+ZHHRomanNumerals.h>
#import <ZHHAnneKit/NSNumber+ZHHRound.h>
#import <ZHHAnneKit/NSObject+ZHHGCDBox.h>
#import <ZHHAnneKit/NSObject+ZHHRunLoop.h>
#import <ZHHAnneKit/NSObject+ZHHRuntime.h>
#import <ZHHAnneKit/NSObject+ZHHExtend.h>
#import <ZHHAnneKit/NSString+ZHHDeviceModelName.h>
#import <ZHHAnneKit/NSString+ZHHCommon.h>
#import <ZHHAnneKit/NSString+ZHHContains.h>
#import <ZHHAnneKit/NSString+ZHHDictionaryValue.h>
#import <ZHHAnneKit/NSString+ZHHEmoji.h>
#import <ZHHAnneKit/NSString+ZHHEmojiRemove.h>
#import <ZHHAnneKit/NSString+ZHHExtend.h>
#import <ZHHAnneKit/NSString+ZHHHash.h>
#import <ZHHAnneKit/NSString+ZHHMath.h>
#import <ZHHAnneKit/NSString+ZHHMIME.h>
#import <ZHHAnneKit/NSString+ZHHPasswordLevel.h>
#import <ZHHAnneKit/NSString+ZHHPinYin.h>
#import <ZHHAnneKit/NSString+ZHHRegex.h>
#import <ZHHAnneKit/NSString+ZHHSafeAccess.h>
#import <ZHHAnneKit/NSString+ZHHSize.h>
#import <ZHHAnneKit/NSString+ZHHTrims.h>
#import <ZHHAnneKit/NSString+ZHHURL.h>
#import <ZHHAnneKit/NSString+ZHHVerify.h>
#import <ZHHAnneKit/NSTimer+ZHHExtend.h>
#import <ZHHAnneKit/NSURL+ZHHParam.h>
#else
#import "NSArray+ZHHExtend.h"
#import "ZHHAnneKit/NSArray+ZHHMathSort.h"
#import "ZHHAnneKit/NSArray+ZHHPredicate.h"
#import "ZHHAnneKit/NSAttributedString+ZHHExtend.h"
#import "ZHHAnneKit/NSBundle+ZHHAppIcon.h"
#import "ZHHAnneKit/NSData+ZHHAPNSToken.h"
#import "ZHHAnneKit/NSData+ZHHDataCache.h"
#import "ZHHAnneKit/NSData+ZHHEncrypt.h"
#import "ZHHAnneKit/NSData+ZHHGzip.h"
#import "ZHHAnneKit/NSData+ZHHHash.h"
#import "ZHHAnneKit/NSDate+ZHHDayWeek.h"
#import "ZHHAnneKit/NSDate+ZHHFormat.h"
#import "ZHHAnneKit/NSDate+ZHHExtend.h"
#import "ZHHAnneKit/NSDecimalNumber+ZHHExtend.h"
#import "ZHHAnneKit/NSDictionary+ZHHExtend.h"
#import "ZHHAnneKit/NSDictionary+ZHHMerge.h"
#import "ZHHAnneKit/NSDictionary+ZHHXML.h"
#import "ZHHAnneKit/NSDictionary+ZHHURL.h"
#import "ZHHAnneKit/NSException+ZHHTrace.h"
#import "ZHHAnneKit/NSFileManager+ZHHExtend.h"
#import "ZHHAnneKit/NSIndexPath+ZHHOffset.h"
#import "ZHHAnneKit/NSNotification+ZHHExtend.h"
#import "ZHHAnneKit/NSNotificationCenter+ZHHMainThread.h"
#import "ZHHAnneKit/NSNumber+ZHHCGFloat.h"
#import "ZHHAnneKit/NSNumber+ZHHRomanNumerals.h"
#import "ZHHAnneKit/NSNumber+ZHHRound.h"
#import "ZHHAnneKit/NSObject+ZHHGCDBox.h"
#import "ZHHAnneKit/NSObject+ZHHRunLoop.h"
#import "ZHHAnneKit/NSObject+ZHHRuntime.h"
#import "ZHHAnneKit/NSObject+ZHHExtend.h"
#import "ZHHAnneKit/NSString+ZHHCommon.h"
#import "ZHHAnneKit/NSString+ZHHContains.h"
#import "ZHHAnneKit/NSString+ZHHDictionaryValue.h"
#import "ZHHAnneKit/NSString+ZHHEmoji.h"
#import "ZHHAnneKit/NSString+ZHHEmojiRemove.h"
#import "ZHHAnneKit/NSString+ZHHExtend.h"
#import "ZHHAnneKit/NSString+ZHHHash.h"
#import "ZHHAnneKit/NSString+ZHHMath.h"
#import "ZHHAnneKit/NSString+ZHHMIME.h"
#import "ZHHAnneKit/NSString+ZHHPasswordLevel.h"
#import "ZHHAnneKit/NSString+ZHHPinYin.h"
#import "ZHHAnneKit/NSString+ZHHRegex.h"
#import "ZHHAnneKit/NSString+ZHHSafeAccess.h"
#import "ZHHAnneKit/NSString+ZHHSize.h"
#import "ZHHAnneKit/NSString+ZHHTrims.h"
#import "ZHHAnneKit/NSString+ZHHURL.h"
#import "ZHHAnneKit/NSString+ZHHVerify.h"
#import "ZHHAnneKit/NSTimer+ZHHExtend.h"
#import "ZHHAnneKit/NSURL+ZHHParam.h"
#endif

#endif /* ZHHFoundation_h */
