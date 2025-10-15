//
//  ZHHPrivacyPermissionManager.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHPrivacyPermissionManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UserNotifications/UserNotifications.h>
#import <Speech/Speech.h>
#import <EventKit/EventKit.h>
#import <Contacts/Contacts.h>

@implementation ZHHPrivacyPermissionManager

#pragma mark - 单例实现
+ (instancetype)sharedInstance {
    static ZHHPrivacyPermissionManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 请求权限主方法

- (void)zhh_requestPrivacyPermissionWithType:(ZHHPrivacyPermissionType)type
                                  completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    switch (type) {
        case ZHHPrivacyPermissionTypePhoto:
            [self requestPhotoPermissionWithCompletion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeCamera:
            [self requestAVPermissionWithType:AVMediaTypeVideo completion:completion];
            break;

        case ZHHPrivacyPermissionTypeMicrophone:
            [self requestAVPermissionWithType:AVMediaTypeAudio completion:completion];
            break;

        case ZHHPrivacyPermissionTypeMedia:
            [self requestMediaPermissionWithCompletion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeLocation:
            [self requestLocationPermissionWithCompletion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeBluetooth:
            [self requestBluetoothPermissionWithCompletion:completion];
            break;
            
        case ZHHPrivacyPermissionTypePushNotification:
            [self requestPushNotificationPermissionWithCompletion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeSpeech:
            [self requestSpeechPermissionWithCompletion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeEvent:
            [self requestEntityPermission:EKEntityTypeEvent completion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeReminder:
            [self requestEntityPermission:EKEntityTypeReminder completion:completion];
            break;
            
        case ZHHPrivacyPermissionTypeContact:
            [self requestContactPermissionWithCompletion:completion];
            break;
            
        default:
            if (completion) {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusUnknown);
            }
            break;
    }
}

#pragma mark - 权限处理方法

/// 相册权限
- (void)requestPhotoPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            [self handlePhotoAuthorizationStatus:status completion:completion];
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self handlePhotoAuthorizationStatus:status completion:completion];
        }];
    }
}

/// 相册权限状态处理
- (void)handlePhotoAuthorizationStatus:(PHAuthorizationStatus)status
                                completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        case PHAuthorizationStatusLimited:
            // 已授权或限时授权
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
            break;
        case PHAuthorizationStatusDenied:
            // 被拒绝
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
            break;
        case PHAuthorizationStatusRestricted:
            // 受限
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusRestricted);
            break;
        default:
            // 未确定（首次请求）
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusNotDetermined);
            break;
    }
}

/// AV权限（相机/麦克风）
- (void)requestAVPermissionWithType:(AVMediaType)type completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {
        if (granted) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:type];
            if (status == AVAuthorizationStatusDenied) {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
            } else {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusNotDetermined);
            }
        }
    }];
}

/// 媒体库权限
- (void)requestMediaPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else if (status == MPMediaLibraryAuthorizationStatusDenied) {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        } else {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusNotDetermined);
        }
    }];
}

/// 定位权限
- (void)requestLocationPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            // 首次请求权限
            [manager requestWhenInUseAuthorization];
            // 注意：这里不会立即回调，需要在实际的 CLLocationManagerDelegate 中处理
            if (completion) {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusNotDetermined);
            }
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (completion) {
                completion(YES, ZHHPrivacyPermissionAuthorizationStatusLocationWhenInUse);
            }
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            if (completion) {
                completion(YES, ZHHPrivacyPermissionAuthorizationStatusLocationAlways);
            }
            break;
            
        case kCLAuthorizationStatusDenied:
            if (completion) {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
            }
            break;
            
        case kCLAuthorizationStatusRestricted:
            if (completion) {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusRestricted);
            }
            break;
            
        default:
            if (completion) {
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusUnknown);
            }
            break;
    }
}

/// 蓝牙权限
- (void)requestBluetoothPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    if (@available(iOS 13.1, *)) {
        CBManagerAuthorization authorization = [CBManager authorization];
        switch (authorization) {
            case CBManagerAuthorizationAllowedAlways:
                // 蓝牙权限已授权
                completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
                break;
            case CBManagerAuthorizationDenied:
                // 蓝牙权限被拒绝
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
                break;
            case CBManagerAuthorizationRestricted:
                // 蓝牙权限受限
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusRestricted);
                break;
            default:
                // 未决定或未知状态
                completion(NO, ZHHPrivacyPermissionAuthorizationStatusNotDetermined);
                break;
        }
    } else {
        // iOS 13 以下版本的蓝牙权限状态检查
        CBCentralManager *centralManager = [[CBCentralManager alloc] init];
        CBManagerState state = [centralManager state];
        if (state == CBManagerStateUnauthorized) {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        } else if (state == CBManagerStateUnsupported || state == CBManagerStateUnknown) {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusRestricted);
        } else {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        }
    }
}

/// 推送通知权限
- (void)requestPushNotificationPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        }
    }];
}

/// 语音识别权限
- (void)requestSpeechPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else if (status == SFSpeechRecognizerAuthorizationStatusDenied) {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        } else {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusNotDetermined);
        }
    }];
}

/// 日历/提醒事项权限
- (void)requestEntityPermission:(EKEntityType)type completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        }
    }];
}

/// 通讯录权限
- (void)requestContactPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        }
    }];
}
@end
