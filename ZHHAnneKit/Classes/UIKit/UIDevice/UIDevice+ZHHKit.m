//
//  UIDevice+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIDevice+ZHHKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIDevice (ZHHKit)
@dynamic zhh_appVersion,zhh_appName,zhh_appIcon,zhh_deviceID;

+ (NSString *)zhh_appVersion{
    static NSString * version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    return version;
}

+ (NSString *)zhh_appName{
    static NSString * name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    });
    return name;
}

+ (NSString *)zhh_deviceID{
    static NSString * identifier;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    });
    return identifier;
}

+ (UIImage *)zhh_appIcon{
    static UIImage * image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
        NSString *name = [iconFilename stringByDeletingPathExtension];
        image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:[iconFilename pathExtension]]];
    });
    return image;
}

@dynamic zhh_launchImage;
+ (UIImage *)zhh_launchImage{
    UIImage *lauchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight){
        viewOrientation = @"Landscape";
    } else {
        viewOrientation = @"Portrait";
    }
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}

@dynamic zhh_cameraAvailable;
+ (BOOL)zhh_cameraAvailable{
    NSArray *temps = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakeVideo = NO;
    for (NSString *mediaType in temps) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            canTakeVideo = YES;
            break;
        }
    }
    return canTakeVideo;
}

@end


@implementation UIDevice (System)

@dynamic zhh_supportHorizontalScreen;
+ (BOOL)zhh_supportHorizontalScreen{
    NSArray *temp = [NSBundle.mainBundle.infoDictionary objectForKey:@"UISupportedInterfaceOrientations"];
    if ([temp containsObject:@"UIInterfaceOrientationLandscapeLeft"] ||
        [temp containsObject:@"UIInterfaceOrientationLandscapeRight"]) {
        return YES;
    } else {
        return NO;
    }
}

@dynamic zhh_launchImageCachePath,zhh_launchImageBackupPath;
+ (NSString *)launchImageCachePath{
    NSString *bundleID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    NSString *path = nil;
    if (@available(iOS 13.0, *)) {
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        path = [NSString stringWithFormat:@"%@/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", libraryDirectory, bundleID];
    } else {
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        path = [[cachesDirectory stringByAppendingPathComponent:@"Snapshots"] stringByAppendingPathComponent:bundleID];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}

+ (NSString *)zhh_launchImageBackupPath{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesDirectory stringByAppendingPathComponent:@"ll_launchImage_backup"];
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    return path;
}

/// 输入要强制转屏的方向
///@param interfaceOrientation 转屏的方向
+ (void)zhh_deviceMandatoryLandscapeWithNewOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    // 将输入的转屏方向（枚举）转换成Int类型
    int orientation = (int)interfaceOrientation;
    // 对象包装
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
    // 实现横竖屏旋转
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

/// 生成启动图
+ (UIImage *)zhh_launchImageWithPortrait:(BOOL)portrait dark:(BOOL)dark{
    return [self zhh_launchImageWithStoryboard:@"LaunchScreen" portrait:portrait dark:dark];
}

/// 生成启动图，根据LaunchScreen名称、是否竖屏、是否暗黑
+ (UIImage *)zhh_launchImageWithStoryboard:(NSString *)name portrait:(BOOL)portrait dark:(BOOL)dark{
    if (@available(iOS 13.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        window.overrideUserInterfaceStyle = dark?UIUserInterfaceStyleDark:UIUserInterfaceStyleLight;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIView *__view = storyboard.instantiateInitialViewController.view;
    __view.frame = [UIScreen mainScreen].bounds;
    CGFloat w = __view.frame.size.width;
    CGFloat h = __view.frame.size.height;
    if (portrait) {
        if (w > h) __view.frame = CGRectMake(0, 0, h, w);
    } else {
        if (w < h) __view.frame = CGRectMake(0, 0, h, w);
    }
    [__view setNeedsLayout];
    [__view layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(__view.frame.size, NO, [UIScreen mainScreen].scale);
    [__view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *launchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return launchImage;
}

/// 对比版本号
+ (BOOL)zhh_comparisonVersion:(NSString *)version{
    NSString *appCurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([version compare:appCurrentVersion] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

/// 获取AppStore版本号和详情信息
+ (NSString *)zhh_getAppStoreVersionWithAppid:(NSString *)appid details:(void(^)(NSDictionary *))details{
    __block NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (appid == nil) return appVersion;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary * dict = [json[@"results"] firstObject];
            appVersion = dict[@"version"];
            if (details) details(dict);
            dispatch_semaphore_signal(semaphore);
        }] resume];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return appVersion;
}

/// 跳转到指定URL
+ (void)zhh_openURL:(id)URL{
    if (URL == nil) return;
    if (![URL isKindOfClass:[NSURL class]]) {
        URL = [NSURL URLWithString:URL];
    }
    if ([[UIApplication sharedApplication] canOpenURL:URL]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }
}
/// 调用AppStore
+ (void)zhh_skipToAppStoreWithAppid:(NSString *)appid{
    NSString * appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *urlString = [@"http://itunes.apple.com/" stringByAppendingFormat:@"%@?id=%@",appName,appid];
    [self zhh_openURL:urlString];
}
/// 调用自带浏览器safari
+ (void)zhh_skipToSafari{
    [self zhh_openURL:@"http://www.abt.com"];
}
/// 调用自带Mail
+ (void)zhh_skipToMail{
    [self zhh_openURL:@"mailto://admin@abt.com"];
}
/// 是否切换为扬声器
+ (void)zhh_changeLoudspeaker:(BOOL)loudspeaker{
    if (loudspeaker) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}

/// 是否开启手电筒
+ (void)zhh_changeFlashlight:(BOOL)light{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![captureDevice hasTorch]) return;
    if (light) {
        NSError *error = nil;
        if ([captureDevice lockForConfiguration:&error]) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
        }
    } else {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOff];
    }
    [captureDevice unlockForConfiguration];
}

/// 是否开启代理，防止Charles抓包
+ (BOOL)zhh_checkOpenProxy:(NSString * _Nullable)url{
    NSDictionary * dict = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSURL * URL = [NSURL URLWithString:url ?: @"https://www.baidu.com"];
    NSArray *proxies = (__bridge NSArray*)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)(URL),
                                                                      (__bridge CFDictionaryRef _Nonnull)(dict)));
    if (proxies.count) {
        NSDictionary * settings = proxies[0];
        if ([[settings objectForKey:(NSString*)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

/// 系统自带分享图片
/// @param image 分享
/// @param complete 分享成功与否回调
+ (UIActivityViewController *)zhh_shareSystemImage:(UIImage *)image complete:(void(^)(BOOL))complete{
    NSArray * items = @[UIImagePNGRepresentation(image)];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    } else if (@available(iOS 9.0, *)) {
        vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks];
    } else {
        vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock =
    ^(UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError) {
        if (complete) complete(completed);
    };
    vc.completionWithItemsHandler = itemsBlock;
    
    UIViewController * __autoreleasing topvc = kDeviceTopViewController();
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        vc.popoverPresentationController.sourceView = topvc.view;
        CGSize size = [UIScreen mainScreen].bounds.size;
        vc.popoverPresentationController.sourceRect = CGRectMake(size.width/2, size.height, 0, 0);
    }
    [topvc presentViewController:vc animated:YES completion:nil];
    return vc;
}

/// 顶部控制器
NS_INLINE UIViewController * kDeviceTopViewController(void){
    UIViewController *result = nil;
    UIWindow *window = ({
        UIWindow *window;
        if (@available(iOS 13.0, *)) {
            window = [UIApplication sharedApplication].windows.firstObject;
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }
        window;
    });
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)vc;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result = nav.childViewControllers.lastObject;
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)vc;
        result = nav.childViewControllers.lastObject;
    } else {
        result = vc;
    }
    return result;
}
@end
