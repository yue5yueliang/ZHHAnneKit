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
            [self zhh_requestPhotoPermissionWithCompletion:completion];
            break;
        case ZHHPrivacyPermissionTypeCamera:
        case ZHHPrivacyPermissionTypeMicrophone:
            [self zhh_requestAVPermissionWithType:(type == ZHHPrivacyPermissionTypeCamera ? AVMediaTypeVideo : AVMediaTypeAudio) completion:completion];
            break;
        case ZHHPrivacyPermissionTypeMedia:
            [self zhh_requestMediaPermissionWithCompletion:completion];
            break;
        case ZHHPrivacyPermissionTypeLocation:
            [self zhh_requestLocationPermissionWithCompletion:completion];
            break;
        case ZHHPrivacyPermissionTypeBluetooth:
            [self zhh_requestBluetoothPermissionWithCompletion:completion];
            break;
        case ZHHPrivacyPermissionTypePushNotification:
            [self zhh_requestPushNotificationPermissionWithCompletion:completion];
            break;
        case ZHHPrivacyPermissionTypeSpeech:
            [self zhh_requestSpeechPermissionWithCompletion:completion];
            break;
        case ZHHPrivacyPermissionTypeEvent:
        case ZHHPrivacyPermissionTypeReminder:
            [self zhh_requestEntityPermission:(type == ZHHPrivacyPermissionTypeEvent ? EKEntityTypeEvent : EKEntityTypeReminder) completion:completion];
            break;
        case ZHHPrivacyPermissionTypeContact:
            [self zhh_requestContactPermissionWithCompletion:completion];
            break;
        default:
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusUnknown);
            break;
    }
}

#pragma mark - 权限处理方法

/// **相册权限**
- (void)zhh_requestPhotoPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            [self zhh_handlePhotoAuthorizationStatus:status completion:completion];
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self zhh_handlePhotoAuthorizationStatus:status completion:completion];
        }];
    }
}

/// **相册权限状态处理**
- (void)zhh_handlePhotoAuthorizationStatus:(PHAuthorizationStatus)status
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

/// **AV权限（相机/麦克风）**
- (void)zhh_requestAVPermissionWithType:(AVMediaType)type completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
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

/// **媒体库权限**
- (void)zhh_requestMediaPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
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

/// **定位权限**
- (void)zhh_requestLocationPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [manager requestWhenInUseAuthorization];
    } else {
        completion(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse, status == kCLAuthorizationStatusAuthorizedAlways ? ZHHPrivacyPermissionAuthorizationStatusLocationAlways : ZHHPrivacyPermissionAuthorizationStatusLocationWhenInUse);
    }
}

/// **蓝牙权限**
- (void)zhh_requestBluetoothPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
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

/// **推送通知权限**
- (void)zhh_requestPushNotificationPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
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

/// **语音识别权限**
- (void)zhh_requestSpeechPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
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

/// **日历/提醒事项权限**
- (void)zhh_requestEntityPermission:(EKEntityType)type completion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            completion(YES, ZHHPrivacyPermissionAuthorizationStatusAuthorized);
        } else {
            completion(NO, ZHHPrivacyPermissionAuthorizationStatusDenied);
        }
    }];
}

/// **通讯录权限**
- (void)zhh_requestContactPermissionWithCompletion:(void(^)(BOOL response, ZHHPrivacyPermissionAuthorizationStatus status))completion {
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
