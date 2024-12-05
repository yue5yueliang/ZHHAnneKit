//
//  NSObject+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 通用回调 Block 类型
typedef void (^ZHHCommonBlock)(id _Nullable value);

@interface NSObject (ZHHUtilities)

/// 获取当前窗口的安全区域内边距
/// @return UIEdgeInsets 表示窗口的安全区域内边距
- (UIEdgeInsets)zhh_safeAreaInsets;

/// 获取状态栏的高度
/// @return CGFloat 表示状态栏的高度
- (CGFloat)zhh_statusBarHeight;

/// 判断当前设备是否为 iPhone X 及以上型号
/// @return BOOL 表示是否为 iPhone X 或更新的刘海屏设备
- (BOOL)zhh_isIPhoneX;

/// 设置通用回调 Block
@property (nonatomic, copy, nullable) ZHHCommonBlock zhh_commonCallback;

/// 触发通用回调，并传递一个值
/// @param value 回调时传递的值
- (void)zhh_triggerCommonCallbackWithValue:(nullable id)value;

/**
 *  @brief  测量代码块的执行时间
 *
 *  @param block  需要执行的代码块
 *  @return 执行时间（单位：毫秒）
 */
+ (CFTimeInterval)zhh_measureExecutionTimeOfBlock:(void(^)(void))block;

/**
 *  @brief  防止快速点击（设置延迟）
 *
 *  @param time 延迟时间（单位：秒），防止短时间内多次点击
 */
+ (void)zhh_preventQuickClick:(float)time;

/**
 *  @brief 保存图片到相册
 *
 *  @param image    要保存的图片
 *  @param complete 保存完成后的回调，返回保存是否成功
 */
+ (void)zhh_saveImageToPhotosAlbum:(UIImage *)image complete:(void(^)(BOOL success))complete;

#pragma MARK: - 归档与解档封装
/// 归档对象的实例变量
/// @param encoder 编码器，用于将对象编码
- (void)zhh_runtimeEncode:(NSCoder *)encoder;

/// 解档对象的实例变量
/// @param decoder 解码器，用于将存储格式的对象解码
- (void)zhh_runtimeInitCoder:(NSCoder *)decoder;

/// 快速实现 NSCopying 协议
/// @param zone 分配的内存区域
/// @return 拷贝后的新对象
- (id)zhh_setCopyingWithZone:(NSZone *)zone;

/// 拷贝当前对象的实例变量到指定对象
/// @param obj 目标对象
/// @discussion 仅拷贝实例变量 (`ivar`)，如果变量支持深拷贝 (`copyWithZone:`)，则执行深拷贝。
- (void)zhh_copyPropertiesToObject:(id)obj;

/// 拷贝指定类的属性
/// @param clazz 指定类
/// @param zone 分配的内存区域
/// @return 拷贝后的对象
/// @discussion 拷贝指定类的属性（不包含父类属性）到新对象。
- (instancetype)zhh_copyPropertiesOfClass:(Class)clazz zone:(NSZone *)zone;

/// 拷贝对象的所有属性（包括父类属性）
/// @param zone 分配的内存区域
/// @return 拷贝后的对象
/// @discussion 遍历类及其父类的所有属性，并将其值拷贝到新对象。
- (instancetype)zhh_copyAllPropertiesWithZone:(NSZone *)zone;
@end

NS_ASSUME_NONNULL_END
