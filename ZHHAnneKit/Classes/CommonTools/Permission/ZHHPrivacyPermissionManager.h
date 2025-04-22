//
//  ZHHPrivacyPermissionManager.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 权限类型枚举
typedef NS_ENUM(NSUInteger, ZHHPrivacyPermissionType) {
    ZHHPrivacyPermissionTypePhoto = 0,            ///< 相册权限
    ZHHPrivacyPermissionTypeCamera,               ///< 相机权限
    ZHHPrivacyPermissionTypeMedia,                ///< 媒体库权限
    ZHHPrivacyPermissionTypeMicrophone,           ///< 麦克风权限
    ZHHPrivacyPermissionTypeLocation,             ///< 定位权限
    ZHHPrivacyPermissionTypeBluetooth,            ///< 蓝牙权限
    ZHHPrivacyPermissionTypePushNotification,     ///< 推送通知权限
    ZHHPrivacyPermissionTypeSpeech,               ///< 语音识别权限
    ZHHPrivacyPermissionTypeEvent,                ///< 日历事件权限
    ZHHPrivacyPermissionTypeContact,              ///< 通讯录权限
    ZHHPrivacyPermissionTypeReminder              ///< 提醒事项权限
};

/// 权限状态枚举
typedef NS_ENUM(NSUInteger, ZHHPrivacyPermissionAuthorizationStatus) {
    ZHHPrivacyPermissionAuthorizationStatusAuthorized = 0,       ///< 已授权
    ZHHPrivacyPermissionAuthorizationStatusDenied,               ///< 已拒绝
    ZHHPrivacyPermissionAuthorizationStatusNotDetermined,        ///< 未确定（首次请求）
    ZHHPrivacyPermissionAuthorizationStatusRestricted,           ///< 受限制
    ZHHPrivacyPermissionAuthorizationStatusLocationAlways,       ///< 定位始终允许
    ZHHPrivacyPermissionAuthorizationStatusLocationWhenInUse,    ///< 定位仅使用时允许
    ZHHPrivacyPermissionAuthorizationStatusUnknown               ///< 未知状态
};

/// 权限工具类：用于统一管理各种隐私权限的申请与状态查询
@interface ZHHPrivacyPermissionManager : NSObject
/// 单例模式：获取类的唯一实例
+ (instancetype)sharedInstance;

/// 请求隐私权限
/// @param type 权限类型（通过枚举选择）
/// @param completion 回调方法，返回权限结果（是否授权）和权限状态
- (void)zhh_requestPrivacyPermissionWithType:(ZHHPrivacyPermissionType)type
                                  completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion;

@end

NS_ASSUME_NONNULL_END
