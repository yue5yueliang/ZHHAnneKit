//
//  UIDevice+ZHHExtend.h
//  ZHHAnneKit
//
//  Created by 宁小陌 on 2022/9/24.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ZHHExtend)
/// 确定应用程序是否支持水平屏幕
@property (nonatomic,assign,class) BOOL zhh_supportHorizontalScreen;
/// System startup map cache path
@property (nonatomic,strong,class) NSString *zhh_launchImageCachePath;
/// Boot map backup file path
@property (nonatomic,strong,class) NSString *zhh_launchImageBackupPath;
/// 输入要强制转屏的方向
/// @param interfaceOrientation 转屏的方向
+ (void)zhh_deviceMandatoryLandscapeWithNewOrientation:(UIInterfaceOrientation)interfaceOrientation;
/// 生成启动图，默认情况下在LaunchScreen中获得
/// @param portrait Whether the screen is vertical
/// @param dark is it dark
/// @return Return to the startup diagram
+ (UIImage *)zhh_launchImageWithPortrait:(BOOL)portrait dark:(BOOL)dark;

/// 生成启动图
/// @param name LaunchScreen name
/// @param portrait 屏幕是否垂直
/// @param dark is it dark
/// @return Return 至启动图
+ (UIImage *)zhh_launchImageWithStoryboard:(NSString *)name portrait:(BOOL)portrait dark:(BOOL)dark;

/// 比较版本号
+ (BOOL)zhh_comparisonVersion:(NSString *)version;

/// 获取AppStore版本号和详情信息
/// @param appid 应用商店版本帐户
/// @param details data information
/// @return returns AppStore版本号
+ (NSString *)zhh_getAppStoreVersionWithAppid:(NSString *)appid details:(void(^)(NSDictionary * userInfo))details;

/// 跳转到指定的URL
+ (void)zhh_openURL:(id)URL;
/// 呼叫 AppStore
+ (void)zhh_skipToAppStoreWithAppid:(NSString *)appid;
/// 呼叫 内置浏览器safari
+ (void)zhh_skipToSafari;
/// 呼叫 你自己的邮件
+ (void)zhh_skipToMail;
/// 是否切换到扬声器
+ (void)zhh_changeLoudspeaker:(BOOL)loudspeaker;
/// 是否打开手电筒
+ (void)zhh_changeFlashlight:(BOOL)light;

/// 是否启用代理以防止Charles捕获数据包
/// @param url test URL, the default Baidu URL
+ (BOOL)zhh_checkOpenProxy:(NSString * _Nullable)url;

/// 该系统附带共享图片
/// @param image share
/// @param complete callback for success or failure of sharing
+ (UIActivityViewController *)zhh_shareSystemImage:(UIImage *)image complete:(void(^)(BOOL success))complete;
@end

NS_ASSUME_NONNULL_END
