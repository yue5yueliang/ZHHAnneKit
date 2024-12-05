//
//  NSBundle+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ZHHUtilities)
/// 获取应用程序图标的文件路径
/// @return 应用图标的完整文件路径，如果未找到图标则返回 nil
- (NSString *)zhh_appIconPath;
/// 获取应用程序的图标图像
/// @return 应用图标的 UIImage 对象，如果未找到图标则返回 nil
- (UIImage *)zhh_appIcon;

/// 加载主包中的图片
/// @param imageName 图片名称（不需要后缀）
/// UIImage *image = [NSBundle zhh_imageNamed:@"exampleImage"];
+ (UIImage * _Nullable)zhh_imageNamed:(NSString * _Nonnull)imageName;

/// 加载主包中的文本文件内容
/// @param fileName 文件名（不需要后缀）
/// @param type 文件扩展名
/// NSString *fileContent = [NSBundle zhh_textFileNamed:@"example" ofType:@"txt"];
+ (NSString * _Nullable)zhh_textFileNamed:(NSString * _Nonnull)fileName ofType:(NSString * _Nonnull)type;

/// 加载主包中的文件路径
/// @param fileName 文件名（不需要后缀）
/// @param type 文件扩展名
/// NSString *filePath = [NSBundle zhh_filePathNamed:@"example" ofType:@"mp3"];
+ (NSString * _Nullable)zhh_filePathNamed:(NSString * _Nonnull)fileName ofType:(NSString * _Nonnull)type;

/// 加载自定义 Bundle 中的图片
/// @param imageName 图片名称（不需要后缀）
/// @param bundleName Bundle 文件名（需要包含后缀）
/// @return 加载的 UIImage，失败返回 nil
/// UIImage *customImage = [NSBundle zhh_imageNamed:@"exampleImage" inBundle:@"CustomBundle.bundle"];
+ (UIImage * _Nullable)zhh_imageNamed:(NSString * _Nonnull)imageName inBundle:(NSString * _Nonnull)bundleName;

@end

NS_ASSUME_NONNULL_END
