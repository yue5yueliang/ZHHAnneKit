//
//  NSBundle+ZHHAppIcon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSBundle+ZHHAppIcon.h"

@implementation NSBundle (ZHHAppIcon)
- (NSString*)zhh_appIconPath {
    NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
    NSString* iconExtension = [iconFilename pathExtension] ;
    return [[NSBundle mainBundle] pathForResource:iconBasename ofType:iconExtension];
}

- (UIImage*)zhh_appIcon {
    UIImage*appIcon = [[UIImage alloc] initWithContentsOfFile:[self zhh_appIconPath]] ;
    return appIcon;
}
@end
