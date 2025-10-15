//
//  ZHHCommonTools.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHFeedbackType) {
    ZHHFeedbackTypeLight = 0,       // 轻度点击反馈
    ZHHFeedbackTypeMedium = 1,     // 中度点击反馈
    ZHHFeedbackTypeHeavy = 2,      // 重度点击反馈
    ZHHFeedbackTypeSelection = 3   // 选择切换反馈
};

@interface ZHHCommonTools : NSObject
/// 获取设备上一像素的逻辑值
+ (CGFloat)zhh_pixelOne;
/// 随机生成16位字符串(数字和字母混合)
+ (NSString *)zhh_random16Text;
/// 随机数生成(比如:0~100之间的随机数)
/// @param from 随机数的最小值（包含）
/// @param to 随机数的最大值（包含）
/// @return 返回一个[from, to]区间的随机整数
+ (NSInteger)zhh_randomNumber:(NSInteger)from to:(NSInteger)to;
/**
 *  加载并解析指定文件名的 JSON 文件。
 *
 *  @param fileName JSON 文件的名称（不包括扩展名）。
 *  @return 返回解析后的 JSON 数据，可能是 NSDictionary 或 NSArray；若失败返回 nil。
 *
 *  @note
 *  1. 文件必须存储在主工程的 `Bundle` 中，并且扩展名必须是 `.json`。
 *  2. 如果文件未找到，或者解析失败，会在控制台打印相应的错误信息。
 *  3. 支持 JSON 数据解析为 `NSDictionary` 或 `NSArray`。
 *
 *  使用示例：
 *  ```objc
 *  id json = [ZHHCommonTools zhh_jsonWithFileName:@"example"];
 *  if ([json isKindOfClass:[NSDictionary class]]) {
 *      NSDictionary *dict = (NSDictionary *)json;
 *      // 处理字典数据
 *  } else if ([json isKindOfClass:[NSArray class]]) {
 *      NSArray *array = (NSArray *)json;
 *      // 处理数组数据
 *  }
 *  ```
 */
+ (id)zhh_jsonWithFileName:(NSString *)fileName;

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
+ (NSString *)zhh_formateDate:(NSString *)dateString formatter:(NSString *)formatter;

/// 将 JSON 格式的对象（NSArray 或 NSDictionary）转换为字符串
/// @param object 需要转换为 JSON 字符串的字典或数组
/// @return 返回 JSON 格式的字符串，如果转换失败则返回 nil
+ (NSString *)zhh_jsonStringWithObject:(id)object;
/// JSON字符串转换为对象（NSArray 或 NSDictionary）
/// @param jsonString 需要转换的 JSON 字符串
/// @return 返回解析后的对象（NSArray 或 NSDictionary），如果解析失败则返回 nil
+ (id)zhh_jsonObjectWithString:(NSString *)jsonString;

/// 根据图片名将图片保存到Documents目录下的ImageFile文件夹中
/// @param imageName 图片文件名
/// @return 返回图片保存的完整路径
+ (NSString *)zhh_saveImagePathWithName:(NSString *)imageName;

/// 计算两点之间的距离（单位：米）
/// @param startCoordinate 起点的经纬度
/// @param endCoordinate   终点的经纬度
/// @return 返回两点之间的距离，单位为米
+ (double)zhh_distanceBetweenCoordinates:(CLLocationCoordinate2D)startCoordinate endCoordinate:(CLLocationCoordinate2D)endCoordinate;

/// 检查设备的定位服务是否可用
/// @return YES 表示定位服务可用，NO 表示不可用
+ (BOOL)zhh_isLocationServiceEnabled;

/// 打开设置页面，引导用户开启定位服务
+ (void)zhh_openLocationSettings;
/**
 *  @brief  触发系统震动反馈
 *
 *  @param  type 反馈类型，枚举值 `ZHHFeedbackType`：
 *          - `ZHHFeedbackTypeLight`: 轻度点击反馈，适合轻微的操作提示。
 *          - `ZHHFeedbackTypeMedium`: 中度点击反馈，适合重要操作的确认提示。
 *          - `ZHHFeedbackTypeHeavy`: 重度点击反馈，适合非常重要的操作确认或警告提示。
 *          - `ZHHFeedbackTypeSelection`: 选择切换反馈，适合表单选项、切换按钮的反馈。
 *
 *  @discussion 该方法基于 Haptic Feedback 生成不同的触觉反馈，适用于支持 Haptic Engine 的设备。
 */
+ (void)zhh_triggerFeedbackWithType:(ZHHFeedbackType)type;

/// @brief 生成随机汉字
/// @param count 生成的汉字数量
/// @return 随机生成的汉字字符串
+ (NSString *)zhh_randomChineseWithCount:(NSInteger)count;

/// 生成一个新的 UUID 字符串
/// @return 一个新的 UUID，格式类似于 "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
+ (NSString *)zhh_uuid;

/// 获取App Store版本号和详情信息
/// @param appid App Store 的 AppID
/// @param details 获取的详情信息回调
/// @return App Store 的版本号（若获取失败，返回本地版本号）
+ (NSString *)zhh_getAppStoreVersionWithAppid:(NSString *)appid details:(void (^)(NSDictionary *details))details;

/// 对比版本号
/// @param version 要比较的目标版本号
/// @return 如果目标版本号比当前版本号高，返回 YES；否则返回 NO
+ (BOOL)zhh_comparisonVersion:(NSString *)version;

/// 跳转到指定 URL
/// @param URL 支持 NSString 或 NSURL 类型
+ (void)zhh_openURL:(id)URL;

/// 跳转到 App Store
/// @param appid App 的唯一标识符
+ (void)zhh_skipToAppStoreWithAppid:(NSString *)appid;

/// 使用系统浏览器 Safari 打开指定 URL
/// @param urlString 要打开的 URL
+ (void)zhh_skipToSafariWithURLString:(NSString *)urlString;

/// 使用系统邮件客户端
/// @param email 收件人邮箱地址
+ (void)zhh_skipToMailWithEmail:(NSString *)email;
/// 切换扬声器模式
/// @param loudspeaker 是否切换为扬声器模式
+ (void)zhh_changeLoudspeaker:(BOOL)loudspeaker;

/// 切换手电筒状态
/// @param light 是否开启手电筒
+ (void)zhh_changeFlashlight:(BOOL)light;

/// 检查是否开启代理，防止Charles抓包
/// @param url 可选的测试URL，默认为 https://www.baidu.com
/// @return 是否开启代理
+ (BOOL)zhh_checkOpenProxy:(NSString * _Nullable)url;

/// 系统自带分享图片
/// @param image 要分享的图片
/// @param complete 分享完成的回调（成功或失败）
/// @return 返回创建的 UIActivityViewController 实例
+ (UIActivityViewController *)zhh_shareSystemImage:(UIImage *)image complete:(void(^)(BOOL))complete;

/// 生成启动图
/// @param portrait 是否竖屏
/// @param dark 是否暗黑模式
/// @return 返回生成的启动图
+ (UIImage *)zhh_launchImageWithPortrait:(BOOL)portrait dark:(BOOL)dark;

/// 生成启动图
/// @param name LaunchScreen.storyboard 文件的名称
/// @param portrait 是否竖屏
/// @param dark 是否暗黑模式
/// @return 返回生成的启动图
+ (UIImage *)zhh_launchImageWithStoryboard:(NSString *)name portrait:(BOOL)portrait dark:(BOOL)dark;

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
+ (void)zhh_forceDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/// @brief 检测是否支持横屏显示
/// 检查应用的 `Info.plist` 中是否配置支持横屏方向。
/// @return 是否支持横屏，`YES` 表示支持，`NO` 表示不支持。
+ (BOOL)zhh_supportHorizontalScreen;
@end

NS_ASSUME_NONNULL_END
