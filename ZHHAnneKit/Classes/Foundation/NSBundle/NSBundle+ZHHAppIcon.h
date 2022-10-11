//
//  NSBundle+ZHHAppIcon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ZHHAppIcon)
- (NSString*)zhh_appIconPath;
- (UIImage*)zhh_appIcon;
@end

NS_ASSUME_NONNULL_END
