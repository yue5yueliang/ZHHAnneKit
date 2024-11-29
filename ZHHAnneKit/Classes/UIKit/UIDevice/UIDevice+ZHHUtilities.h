//
//  UIDevice+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 宁小陌 on 2022/9/24.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ZHHUtilities)
/// @brief 获取启动图缓存路径
/// 根据当前系统版本，返回存储启动图的缓存路径。如果路径不存在，返回 `nil`。
///@return 启动图缓存路径字符串，若不存在则返回 `nil`。
+ (NSString *)zhh_launchImageCachePath;
/**
 * @brief 获取启动图备份路径
 *
 * @discussion 返回存储启动图备份的路径。如果路径不存在，会自动创建。
 *
 * @return 启动图备份文件夹的完整路径。
 */
+ (NSString *)zhh_launchImageBackupPath;
@end

NS_ASSUME_NONNULL_END
