//
//  ZHHAnneKit.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/11.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#ifndef ZHHAnneKit_h
#define ZHHAnneKit_h


#if __has_include(<ZHHAnneKit/ZHHAnneKit.h>)
FOUNDATION_EXPORT double ZHHAnneKitVersionNumber;
//! Project version string for ZHHAnneKit.
FOUNDATION_EXPORT const unsigned char ZHHAnneKitVersionString[];
// In this header, you should import all the public headers of your framework using statements like #import <ZHHAnneKit/PublicHeader.h>
// 在这个头中，您应该导入框架的所有公共头
// 使用#import<ZHHAnneKit/ZHHAnneKit.h>等语句
// 或@import-ZHHAnneKits;
#import <ZHHAnneKit/ZHHUIKit.h>
#import <ZHHAnneKit/ZHHCommonKit.h>
#import <ZHHAnneKit/ZHHQuartzCore.h>
#import <ZHHAnneKit/ZHHFoundation.h>
#else
#import "ZHHUIKit.h"
#import "ZHHCommonKit.h"
#import "ZHHQuartzCore.h"
#import "ZHHFoundation.h"
#endif

#endif /* ZHHAnneKit_h */
