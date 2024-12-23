//
//  ZHHAnneKit.h
//  ZHHAnneKit
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

// 在这个头文件中导入框架的所有公共头文件
// 使用 #import <ZHHAnneKit/ZHH*.h> 来导入公共头文件
#import <ZHHAnneKit/ZHHUIKit.h>
#import <ZHHAnneKit/ZHHBadgeView.h>
#import <ZHHAnneKit/ZHHCommonKit.h>
#import <ZHHAnneKit/ZHHFoundation.h>
#import <ZHHAnneKit/ZHHQuartzCore.h>

#else

// 如果不能使用框架导入，则使用本地路径的导入方式
#import "ZHHUIKit.h"
#import "ZHHBadgeView.h"
#import "ZHHCommonKit.h"
#import "ZHHFoundation.h"
#import "ZHHQuartzCore.h"

#endif

#endif /* ZHHAnneKit_h */
