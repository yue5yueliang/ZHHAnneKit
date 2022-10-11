//
//  UITableView+ZHHiOS7Style.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//
// http://stackoverflow.com/questions/18822619/ios-7-tableview-like-in-settings-app-on-ipad

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZHHiOS7Style)
/**
 *  @brief  iOS 7 设置页面的 UITableViewCell 样式
 *
 *  @param cell      cell
 *  @param indexPath indexPath
 */
- (void)zhh_applyiOS7SettingsStyleGrouping:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
