//
//  ZHHCommonTools.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHCommonTools.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZHHCommonTools
+ (CGFloat)zhh_pixelOne {
    static CGFloat pixelOne = -1.0f; // 声明为 static，确保值在整个生命周期内保持
    static dispatch_once_t onceToken; // 使用 GCD 的 dispatch_once 保证线程安全和只初始化一次
    dispatch_once(&onceToken, ^{
        pixelOne = 1.0 / [UIScreen mainScreen].scale; // 获取屏幕比例
    });
    return pixelOne;
}

/// 生成随机16位字符串（包含字母和数字）
/// @return 一个长度为16的随机字符串
+ (NSString *)zhh_random16Text {
    // 初始化一个空字符串
    NSString *str = @"";
    
    // 循环生成16位字符
    for (int i = 0; i < 16; i++) {
        // 随机选择字母或数字
        switch (arc4random() % 3) {
            case 0: // 生成数字字符
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random() % 10]];
                break;
            case 1: // 生成小写字母字符
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%c", arc4random() % 26 + 97]]; // ASCII 'a' 起始值为 97
                break;
            case 2: // 生成大写字母字符
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%c", arc4random() % 26 + 65]]; // ASCII 'A' 起始值为 65
                break;
        }
    }
    return str;
}

/// 随机数生成
/// @param from 随机数的最小值（包含）
/// @param to 随机数的最大值（包含）
/// @return 返回一个[from, to]区间的随机整数
+ (NSInteger)zhh_randomNumber:(NSInteger)from to:(NSInteger)to {
    // 确保参数有效，避免 `to < from` 的情况
    if (to < from) {
        NSInteger temp = from;
        from = to;
        to = temp;
    }
    // 使用 `arc4random` 生成指定区间的随机数
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

/// 加载并解析指定文件名的 JSON 文件。
+ (id)zhh_jsonWithFileName:(NSString *)fileName {
    // 获取 JSON 文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];

    if (!path) {
        NSLog(@"ZHHAnneKit 警告: JSON文件未找到");
        return nil;
    }

    // 读取文件内容
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSError *error;
    
    // 解析 JSON 数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"ZHHAnneKit 警告: JSON解析错误: %@", error.localizedDescription);
    } else {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonDict = (NSDictionary *)jsonObject;
            NSLog(@"ZHHAnneKit 信息: JSON字典: %@", jsonDict);
            return jsonObject;
        } else if ([jsonObject isKindOfClass:[NSArray class]]) {
            NSArray *jsonArray = (NSArray *)jsonObject;
            NSLog(@"ZHHAnneKit 信息: JSON数组: %@", jsonArray);
            return jsonObject;
        }
    }
    return nil;
}

/**
 * 将时间字符串格式化为相对时间描述
 *
 * 与当前时间比较：
 * 1) 1分钟以内 显示：刚刚
 * 2) 1小时以内 显示：x分钟前
 * 3) 24小时以内 显示：x小时前
 * 4) 48小时以内 显示：昨天 09:30
 * 5) 7天内 显示：x天前
 * 6) 30天内 显示：x周前
 * 7) 6个月 显示：x个月前
 * 8) 同一年但超过6个月 显示：MM月dd日 HH:mm
 * 9) 不同年 显示：yyyy-MM-dd HH:mm
 *
 * @param dateString 要格式化的时间字符串，例如 @"2016-04-04 20:21:22"
 * @param formatter 时间字符串的格式，例如 @"yyyy-MM-dd HH:mm:ss"
 * @return 格式化后的时间字符串
 */
+ (NSString *)zhh_formateDate:(NSString *)dateString formatter:(NSString *)formatter {
    @try {
        // 设置日期格式化
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatter];
        
        // 获取当前时间和需要格式化的时间
        NSDate *endDate = [NSDate date];
        NSDate *startDate = [dateFormatter dateFromString:dateString];
        
        // 如果日期字符串不合法，则返回空字符串
        if (!startDate) {
            return @"";
        }
        
        NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
        
        // 计算时间差
        NSInteger minutes = time / 60;
        NSInteger hours = time / (60 * 60);
        NSInteger days = time / (60 * 60 * 24);
        NSInteger weeks = days / 7;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:startDate toDate:endDate options:0];
        NSInteger months = components.month;
        
        NSString *dateStr = @"";
        NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:endDate];
        NSInteger targetYear = [calendar component:NSCalendarUnitYear fromDate:startDate];
        
        // 1 分钟以内
        if (time < 60) {
            dateStr = @"刚刚";
        }
        // 1 小时以内
        else if (minutes < 60) {
            dateStr = [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
        }
        // 24 小时以内
        else if (hours < 24) {
            dateStr = [NSString stringWithFormat:@"%ld小时前", (long)hours];
        }
        // 24-48 小时
        else if (hours < 48) {
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            dateStr = [dateFormatter stringFromDate:startDate];
        }
        // 7 天以内
        else if (days < 7) {
            dateStr = [NSString stringWithFormat:@"%ld天前", (long)days];
        }
        // 30 天以内
        else if (days < 30) {
            dateStr = [NSString stringWithFormat:@"%ld周前", (long)weeks];
        }
        // 6 个月以内
        else if (months < 6) {
            dateStr = [NSString stringWithFormat:@"%ld个月前", (long)months];
        }
        // 同一年但超过 6 个月
        else if (currentYear == targetYear) {
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            dateStr = [dateFormatter stringFromDate:startDate];
        }
        // 不同年
        else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            dateStr = [dateFormatter stringFromDate:startDate];
        }
        
        return dateStr;
    } @catch (NSException *exception) {
        return @"";
    }
}

#pragma mark ------------ json或字符串的解析 ----------------------------
/** 将 JSON 格式的对象（字典或数组）转换为字符串
 @param object 需要转换为 JSON 字符串的字典或数组
 @return 返回 JSON 格式的字符串，如果转换失败则返回 nil
 */
+ (NSString *)zhh_jsonStringWithObject:(id)object {
    // 检查对象类型是否为 NSDictionary 或 NSArray
    if (![object isKindOfClass:[NSDictionary class]] && ![object isKindOfClass:[NSArray class]]) {
        return nil; // 仅支持字典和数组
    }
    // 将对象转化为 JSON 数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    // 如果转换失败则返回 nil
    if (!jsonData) {
        return nil;
    }
    // 将 JSON 数据转换为字符串
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 去除字符串中的空格和换行符
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonStr;
}

/** JSON字符串转为对象（NSArray 或 NSDictionary） */
+ (id)zhh_jsonObjectWithString:(NSString *)jsonString{
    if (jsonString.length == 0) {
        NSLog(@"需要解析的 JSON 字符串不能为空");
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"JSON解析失败：%@", error);
        return nil;
    }
    return json;
}

/// 根据图片名将图片保存到Documents目录下的ImageFile文件夹中
/// @param imageName 图片文件名
/// @return 返回图片保存的完整路径
+ (NSString *)zhh_saveImagePathWithName:(NSString *)imageName {
    // 获取Documents目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    // 获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 指定ImageFile文件夹路径
    NSString *imageFilePath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    // 创建ImageFile文件夹（如果不存在）
    if (![fileManager fileExistsAtPath:imageFilePath]) {
        [fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 返回保存图片的路径（图片保存在ImageFile文件夹下）
    return [imageFilePath stringByAppendingPathComponent:imageName];
}

/// 计算两点之间的距离（单位：米）
/// @param startCoordinate 起点的经纬度
/// @param endCoordinate   终点的经纬度
/// @return 返回两点之间的距离，单位为米
+ (double)zhh_distanceBetweenCoordinates:(CLLocationCoordinate2D)startCoordinate endCoordinate:(CLLocationCoordinate2D)endCoordinate {
    // 地球的半径，单位：米
    double earthRadius = 6378137;
    double distance = 0;

    // 获取起点和终点的经纬度
    double startLongitude = startCoordinate.longitude;
    double startLatitude = startCoordinate.latitude;

    double endLongitude = endCoordinate.longitude;
    double endLatitude = endCoordinate.latitude;

    // 将经纬度转换为弧度
    double startLatitudeRad = startLatitude * M_PI / 180.0;
    double endLatitudeRad = endLatitude * M_PI / 180.0;

    // 计算纬度和经度的差值
    double latitudeDiff = fabs(startLatitudeRad - endLatitudeRad);
    double longitudeDiff = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);

    // 使用 Haversine 公式计算两点之间的球面距离
    double haversineFormula = pow(sin(latitudeDiff / 2), 2) +
                              cos(startLatitudeRad) * cos(endLatitudeRad) *
                              pow(sin(longitudeDiff / 2), 2);

    // 计算中心角（弧度）
    double centralAngle = 2 * atan2(sqrt(haversineFormula), sqrt(1 - haversineFormula));

    // 根据中心角计算两点之间的距离
    distance = earthRadius * centralAngle;

    // 返回距离，单位为米，保留四位小数
    return round(distance * 10000) / 10000;
}

/// 检查定位服务是否可用
/// @return 返回定位服务是否可用的状态
+ (BOOL)zhh_isLocationServiceEnabled {
    // 检查定位服务是否启用
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        // 判断授权状态是否为允许使用定位
        if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
            authStatus == kCLAuthorizationStatusAuthorizedAlways ||
            authStatus == kCLAuthorizationStatusNotDetermined) {
            return YES; // 定位功能可用
        }
    }
    return NO; // 定位不可用（包括授权被拒绝）
}

/// 打开设置页面，引导用户开启定位服务
+ (void)zhh_openLocationSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

+ (void)zhh_triggerFeedbackWithType:(ZHHFeedbackType)type {
    switch (type) {
        case ZHHFeedbackTypeLight: {
            // 轻度点击反馈
            UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [impactLight impactOccurred];
            break;
        }
        case ZHHFeedbackTypeMedium: {
            // 中度点击反馈
            UIImpactFeedbackGenerator *impactMedium = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [impactMedium impactOccurred];
            break;
        }
        case ZHHFeedbackTypeHeavy: {
            // 重度点击反馈
            UIImpactFeedbackGenerator *impactHeavy = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
            [impactHeavy impactOccurred];
            break;
        }
        case ZHHFeedbackTypeSelection: {
            // 选择切换反馈
            UISelectionFeedbackGenerator *feedbackSelection = [[UISelectionFeedbackGenerator alloc] init];
            [feedbackSelection selectionChanged];
            break;
        }
        default: {
            // 无效反馈类型
            NSLog(@"ZHHAnneKit 警告: 无效的反馈类型: %ld", (long)type);
            break;
        }
    }
}

/// @brief 生成随机汉字
/// @param count 生成的汉字数量
/// @return 随机生成的汉字字符串
+ (NSString *)zhh_randomChineseWithCount:(NSInteger)count {
    if (count <= 0) {
        return @"";
    }
    
    NSMutableString *randomString = [NSMutableString stringWithString:@""];
    
    // 使用更现代的汉字范围：常用汉字范围 0x4E00-0x9FFF
    for (NSInteger i = 0; i < count; i++) {
        // 生成常用汉字范围内的随机码点
        NSInteger randomCodePoint = 0x4E00 + arc4random() % (0x9FFF - 0x4E00 + 1);
        
        // 将码点转换为Unicode字符
        unichar character = (unichar)randomCodePoint;
        NSString *chineseChar = [NSString stringWithCharacters:&character length:1];
        
        // 拼接汉字
        [randomString appendString:chineseChar];
    }
    
    return randomString.copy;
}

/// 生成一个新的 UUID 字符串
/// @return 一个新的 UUID，格式类似于 "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
+ (NSString *)zhh_uuid {
    // 创建一个新的 UUID
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    // 将 UUID 转换为字符串
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    // 释放 UUID 引用
    CFRelease(uuid);
    // 将 CFString 转换为 NSString 并自动管理内存
    return (__bridge_transfer NSString *)string;
}

/// 获取App Store版本号和详情信息
/// @param appid App Store 的 AppID
/// @param details 获取的详情信息回调
/// @return App Store 的版本号（若获取失败，返回本地版本号）
+ (NSString *)zhh_getAppStoreVersionWithAppid:(NSString *)appid details:(void (^)(NSDictionary *details))details {
    // 获取本地应用版本号作为默认值
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // 如果 AppID 为空，直接返回本地版本号
    if (appid == nil || appid.length == 0) return localVersion;
    
    // 拼接请求 URL
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 使用信号量实现同步等待
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSString *appStoreVersion = localVersion; // 默认值为本地版本号

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                NSDictionary *result = [json[@"results"] firstObject];
                if (result) {
                    // 提取 App Store 版本号
                    appStoreVersion = result[@"version"];
                    // 回调详情信息
                    if (details) details(result);
                }
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    
    // 等待网络请求完成
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return appStoreVersion;
}

/// 对比版本号
/// @param version 要比较的目标版本号
/// @return 如果目标版本号比当前版本号高，返回 YES；否则返回 NO
+ (BOOL)zhh_comparisonVersion:(NSString *)version {
    // 获取当前应用的版本号
    NSString *appCurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // 比较版本号，NSOrderedDescending 表示目标版本号更大
    return [version compare:appCurrentVersion options:NSNumericSearch] == NSOrderedDescending;
}

/// 跳转到指定 URL
/// @param URL 支持 NSString 或 NSURL 类型
+ (void)zhh_openURL:(id)URL {
    // 检查 URL 是否为空
    if (!URL) return;
    
    // 如果不是 NSURL 类型，尝试转换为 NSURL
    if (![URL isKindOfClass:[NSURL class]]) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", URL]];
    }
    
    // 确保 URL 是有效的 NSURL 对象
    if (!URL) return;
    
    // 检查是否能打开该 URL
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        // 使用 iOS 13.0 及以上的方式打开 URL
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
}

/// 跳转到 App Store
/// @param appid App 的唯一标识符
+ (void)zhh_skipToAppStoreWithAppid:(NSString *)appid {
    // 检查 AppID 是否为空
    if (!appid.length) return;

    // 拼接 App Store URL
    NSString *urlString = [NSString stringWithFormat:@"https://apps.apple.com/app/id%@", appid];

    // 使用统一的 URL 打开方法
    [self zhh_openURL:urlString];
}

/// 使用系统浏览器 Safari 打开指定 URL
/// @param urlString 要打开的 URL
+ (void)zhh_skipToSafariWithURLString:(NSString *)urlString {
    // 默认 URL
    if (!urlString.length) {
        urlString = @"http://www.example.com"; // 可修改为默认网址
    }

    // 使用统一的 URL 打开方法
    [self zhh_openURL:urlString];
}

/// 使用系统邮件客户端
/// @param email 收件人邮箱地址
+ (void)zhh_skipToMailWithEmail:(NSString *)email {
    // 默认邮箱
    if (!email.length) {
        email = @"admin@example.com"; // 可修改为默认邮箱
    }

    // 拼接邮件 URL
    NSString *urlString = [NSString stringWithFormat:@"mailto:%@", email];

    // 使用统一的 URL 打开方法
    [self zhh_openURL:urlString];
}

/// 切换扬声器模式
/// @param loudspeaker 是否切换为扬声器模式
+ (void)zhh_changeLoudspeaker:(BOOL)loudspeaker {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    // 配置音频会话类别
    if (loudspeaker) {
        [audioSession setCategory:AVAudioSessionCategoryPlayback
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                            error:&error];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                            error:&error];
    }
    
    // 激活音频会话
    if (!error) {
        [audioSession setActive:YES error:&error];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"切换扬声器模式失败: %@", error.localizedDescription);
    }
}

/// 切换手电筒状态
/// @param light 是否开启手电筒
+ (void)zhh_changeFlashlight:(BOOL)light {
    // 获取视频设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 检查设备是否支持手电筒
    if (!captureDevice || ![captureDevice hasTorch]) {
        NSLog(@"设备不支持手电筒功能");
        return;
    }
    
    NSError *error = nil;
    // 尝试锁定设备配置
    if ([captureDevice lockForConfiguration:&error]) {
        // 设置手电筒状态
        if (light) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
        } else {
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
        }
        [captureDevice unlockForConfiguration];
    } else {
        // 错误处理
        NSLog(@"无法配置手电筒: %@", error.localizedDescription);
    }
}

/// 检查是否开启代理，防止Charles抓包
/// @param url 可选的测试URL，默认为 https://www.baidu.com
/// @return 是否开启代理
+ (BOOL)zhh_checkOpenProxy:(NSString * _Nullable)url {
    // 获取系统代理设置
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    if (!proxySettings) return NO; // 未能获取系统代理设置时，默认无代理

    NSDictionary *proxyDict = (__bridge_transfer NSDictionary *)proxySettings;

    // 如果未提供URL，使用默认URL
    NSURL *testURL = [NSURL URLWithString:url ?: @"https://www.baidu.com"];
    if (!testURL) return NO; // 如果URL无效，默认返回NO

    // 获取指定URL的代理设置
    CFArrayRef proxyArrayRef = CFNetworkCopyProxiesForURL((__bridge CFURLRef)testURL, (__bridge CFDictionaryRef)proxyDict);
    if (!proxyArrayRef) return NO;

    NSArray *proxyArray = (__bridge_transfer NSArray *)proxyArrayRef;
    if (proxyArray.count == 0) return NO; // 无代理时返回NO

    // 检查代理类型
    NSDictionary *proxySettingsForURL = proxyArray.firstObject;
    NSString *proxyType = proxySettingsForURL[(NSString *)kCFProxyTypeKey];

    // 判断代理类型是否为None
    return ![proxyType isEqualToString:(NSString *)kCFProxyTypeNone];
}

/// 系统自带分享图片
/// @param image 要分享的图片
/// @param complete 分享完成的回调（成功或失败）
/// @return 返回创建的 UIActivityViewController 实例
+ (UIActivityViewController *)zhh_shareSystemImage:(UIImage *)image complete:(void(^)(BOOL))complete {
    // 将图片数据添加到分享项
    NSArray *items = @[UIImagePNGRepresentation(image)];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    // 排除不需要的分享类型
    vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    
    // 分享完成后的回调处理
    vc.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (complete) {
            complete(completed);
        }
    };
    
    // 获取当前显示的顶层视图控制器
    UIViewController *topViewController = [self zhh_topViewController];
    
    // 处理 iPad 弹窗问题
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        vc.popoverPresentationController.sourceView = topViewController.view;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        vc.popoverPresentationController.sourceRect = CGRectMake(screenSize.width / 2.0, screenSize.height, 0, 0);
    }
    
    // 显示分享视图控制器
    [topViewController presentViewController:vc animated:YES completion:nil];
    return vc;
}

/// 获取当前显示在屏幕上的顶部控制器
+ (UIViewController *)zhh_topViewController {
    UIWindow *keyWindow = UIApplication.sharedApplication.windows.firstObject;

    // 确保查找的是普通级别的 window
    if (keyWindow.windowLevel != UIWindowLevelNormal) {
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                keyWindow = window;
                break;
            }
        }
    }

    // 从根控制器递归查找顶部控制器
    UIViewController *topViewController = keyWindow.rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }

    // 如果是 TabBar 或 NavigationController，继续查找
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)topViewController;
        UINavigationController *selectedNav = (UINavigationController *)tabBarController.selectedViewController;
        topViewController = selectedNav.viewControllers.lastObject ?: selectedNav;
    } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)topViewController;
        topViewController = navController.viewControllers.lastObject;
    }

    return topViewController;
}

/// 生成启动图
+ (UIImage *)zhh_launchImageWithPortrait:(BOOL)portrait dark:(BOOL)dark{
    return [self zhh_launchImageWithStoryboard:@"LaunchScreen" portrait:portrait dark:dark];
}

/// 生成启动图
/// @param name LaunchScreen.storyboard 文件的名称
/// @param portrait 是否竖屏
/// @param dark 是否暗黑模式
/// @return 返回生成的启动图
+ (UIImage *)zhh_launchImageWithStoryboard:(NSString *)name portrait:(BOOL)portrait dark:(BOOL)dark {
    // 1. 设置窗口的用户界面风格（暗黑模式或浅色模式）
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    window.overrideUserInterfaceStyle = dark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;

    // 2. 加载指定名称的 Storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIView *view = storyboard.instantiateInitialViewController.view;
    view.frame = [UIScreen mainScreen].bounds;
    
    // 3. 调整视图的方向（竖屏或横屏）
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    if (portrait) {
        if (width > height) {
            view.frame = CGRectMake(0, 0, height, width);
        }
    } else {
        if (width < height) {
            view.frame = CGRectMake(0, 0, height, width);
        }
    }
    
    // 4. 触发布局更新
    [view setNeedsLayout];
    [view layoutIfNeeded];
    
    // 5. 开始图形上下文，渲染视图层
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 6. 获取生成的图片
    UIImage *launchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return launchImage;
}

/**
 * @brief 强制改变设备屏幕方向
 *
 * @discussion 该方法通过修改 `UIDevice` 的 `orientation` 属性，强制改变屏幕的显示方向。
 *             适用于某些场景需要临时强制设置设备的横竖屏方向，例如播放全屏视频或某些固定方向的内容。
 *
 * @param interfaceOrientation 要强制设置的屏幕方向，枚举类型 `UIInterfaceOrientation`。
 *                              例如：`UIInterfaceOrientationPortrait` 表示竖屏，
 *                                   `UIInterfaceOrientationLandscapeLeft` 表示横屏（左侧）。
 *
 * @note 使用该方法时，请确保视图控制器的 `supportedInterfaceOrientations` 和
 *       `shouldAutorotate` 方法能够正确配合旋转方向，否则可能会导致意外行为。
 * @warning 该方法使用了 KVC 技术修改私有属性，可能存在潜在的审核风险，请谨慎使用。
 */
+ (void)zhh_forceDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // 重置设备方向为未知，以确保后续旋转生效
    NSNumber *resetOrientationTarget = @(UIInterfaceOrientationUnknown);
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    // 将目标方向设置为指定的方向
    NSNumber *orientationTarget = @(interfaceOrientation);
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

/// @brief 检测是否支持横屏显示
/// 检查应用的 `Info.plist` 中是否配置支持横屏方向。
/// @return 是否支持横屏，`YES` 表示支持，`NO` 表示不支持。
+ (BOOL)zhh_supportHorizontalScreen {
    // 获取支持的屏幕方向配置
    NSArray *supportedOrientations = [NSBundle.mainBundle.infoDictionary objectForKey:@"UISupportedInterfaceOrientations"];
    // 检查是否支持横屏方向
    return [supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeLeft"] ||
           [supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeRight"];
}
@end
