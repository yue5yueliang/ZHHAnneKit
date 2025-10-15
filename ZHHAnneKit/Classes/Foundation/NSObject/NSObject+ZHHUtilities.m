//
//  NSObject+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSObject+ZHHUtilities.h"
#import <objc/runtime.h>

static char commonCallbackKey;

@implementation NSObject (ZHHUtilities)

/// 获取当前窗口的安全区域内边距
/// @return UIEdgeInsets 表示窗口的安全区域内边距
- (UIEdgeInsets)zhh_safeAreaInsets {
    // 获取主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    // 确保 keyWindow 存在
    if (keyWindow) {
        return keyWindow.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

/// 获取状态栏的高度
/// @return CGFloat 表示状态栏的高度
- (CGFloat)zhh_statusBarHeight {
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    if (keyWindow) {
        // 通过 statusBarManager 获取状态栏高度
        return keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    }
    return 0;
}

/// 判断当前设备是否为 iPhone X 及以上型号
/// @return BOOL 表示是否为 iPhone X 或更新的刘海屏设备
- (BOOL)zhh_isIPhoneX {
    // 判断安全区域底部内边距是否大于 0，以此区分是否为刘海屏设备
    return self.zhh_safeAreaInsets.bottom > 0;
}


/// 设置通用回调 Block
- (void)setZhh_commonCallback:(nullable ZHHCommonBlock)zhh_commonCallback {
    objc_setAssociatedObject(self, &commonCallbackKey, zhh_commonCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/// 获取通用回调 Block
- (nullable ZHHCommonBlock)zhh_commonCallback {
    return objc_getAssociatedObject(self, &commonCallbackKey);
}

/// 触发通用回调，并传递一个值
- (void)zhh_triggerCommonCallbackWithValue:(nullable id)value {
    if (self.zhh_commonCallback) {
        self.zhh_commonCallback(value);
    }
}

+ (CFTimeInterval)zhh_measureExecutionTimeOfBlock:(void(^)(void))block {
    if (!block) {
        return 0;
    }
    // 获取开始时间
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    // 执行代码块
    block();
    // 计算执行时间（以秒为单位，转换为毫秒）
    CFAbsoluteTime executionTime = CFAbsoluteTimeGetCurrent() - startTime;
    // 输出执行时间
    NSLog(@"ZHHAnneKit 信息: 执行时间: %.3f 毫秒", executionTime * 1000.0);
    return executionTime * 1000;  // 返回执行时间，单位为毫秒
}

+ (void)zhh_preventQuickClick:(float)time {
    static NSMutableSet *clickingObjects = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clickingObjects = [[NSMutableSet alloc] init];
    });
    
    // 使用对象地址作为唯一标识符
    NSString *objectKey = [NSString stringWithFormat:@"%p", self];
    
    // 如果对象正在点击中，直接返回
    if ([clickingObjects containsObject:objectKey]) {
        return;
    }
    
    // 标记对象为点击中
    [clickingObjects addObject:objectKey];
    
    // 延迟指定时间后允许再次点击
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [clickingObjects removeObject:objectKey];
    });
}

static char kSavePhotosKey;

/**
 *  @brief 保存图片到相册
 *
 *  @param image    要保存的图片
 *  @param complete 保存完成后的回调，返回保存是否成功
 */
+ (void)zhh_saveImageToPhotosAlbum:(UIImage *)image complete:(void(^)(BOOL success))complete {
    // 调用 UIImageWriteToSavedPhotosAlbum 方法保存图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    // 将回调 block 关联到当前对象，使用 runtime 动态存储
    objc_setAssociatedObject(self, &kSavePhotosKey, complete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  @brief 保存图片完成后的回调方法
 *
 *  @param image      保存的图片
 *  @param error      保存时出现的错误，如果没有错误则为 nil
 *  @param contextInfo 上下文信息
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 获取并执行保存完成后的回调
    void(^completeBlock)(BOOL success) = objc_getAssociatedObject(self, &kSavePhotosKey);
    // 判断保存是否成功并执行回调
    if (completeBlock) {
        completeBlock(error == nil);  // 如果没有错误则成功，否则失败
    }
}

/// 归档封装
/// 使用 KVC 获取实例的属性，并通过 NSKeyedArchiver 归档对象
/// @param encoder 编码器，负责将对象编码成存储格式
- (void)zhh_runtimeEncode:(NSCoder *)encoder {
    // 获取当前类的所有实例变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    // 遍历所有实例变量并进行归档
    for (int i = 0; i < count; i++) {
        // 获取实例变量的名称
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [NSString stringWithUTF8String:name]; // 转换为 NSString
        
        // 使用 KVC 获取实例变量的值
        id value = [self valueForKey:key];
        // 使用归档器将该值存储
        if (value) {
            [encoder encodeObject:value forKey:key];
        }
    }
    // 释放实例变量列表内存
    free(ivars);
}

/// 解档封装
/// 使用 KVC 设置实例的属性，并通过 NSKeyedUnarchiver 解档对象
/// @param decoder 解码器，负责将存储格式的对象解码还原
- (void)zhh_runtimeInitCoder:(NSCoder *)decoder {
    // 获取当前类的所有实例变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    // 遍历所有实例变量并进行解档
    for (int i = 0; i < count; i++) {
        // 获取实例变量的名称
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [NSString stringWithUTF8String:name]; // 转换为 NSString
        
        // 使用解码器解码属性值
        id value = [decoder decodeObjectForKey:key];
        // 使用 KVC 将解码的值设置到对象的对应属性中
        if (value) {
            [self setValue:value forKey:key];
        }
    }
    
    // 释放实例变量列表内存
    free(ivars);
}

#pragma mark - NSCopying 协议实现
/// 快速实现 NSCopying 协议
/// @param zone 分配的内存区域
/// @return 拷贝后的新对象
/// @discussion 调用内部方法 `zhh_copyPropertiesToObject:` 将属性从当前对象拷贝到新分配的对象。
- (id)zhh_setCopyingWithZone:(NSZone *)zone {
    // 创建新对象，并将当前对象的属性拷贝到新对象
    id newObject = [[[self class] allocWithZone:zone] init];
    [self zhh_copyPropertiesToObject:newObject];
    return newObject;
}

#pragma mark - 属性拷贝
/// 拷贝当前对象的实例变量到指定对象
/// @param obj 目标对象
/// @discussion 仅拷贝实例变量 (`ivar`)，如果变量支持深拷贝 (`copyWithZone:`)，则执行深拷贝。
- (void)zhh_copyPropertiesToObject:(id)obj {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        // 深拷贝（如果支持 copyWithZone:），否则直接赋值
        if ([value respondsToSelector:@selector(copyWithZone:)]) {
            [obj setValue:[value copy] forKey:key];
        } else {
            [obj setValue:value forKey:key];
        }
    }
    free(ivars);
}

#pragma mark - 拷贝指定类的属性
/// 拷贝指定类的属性
/// @param clazz 指定类
/// @param zone 分配的内存区域
/// @return 拷贝后的对象
/// @discussion 拷贝指定类的属性（不包含父类属性）到新对象，通常用于限制拷贝范围。
- (instancetype)zhh_copyPropertiesOfClass:(Class)clazz zone:(NSZone *)zone {
    id newObject = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [newObject setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return newObject;
}

#pragma mark - 拷贝全部属性（包括父类）
/// 拷贝对象的所有属性（包括父类属性）
/// @param zone 分配的内存区域
/// @return 拷贝后的对象
/// @discussion 遍历类及其父类的所有属性，并将其值拷贝到新对象。
- (instancetype)zhh_copyAllPropertiesWithZone:(NSZone *)zone {
    id newObject = [[[self class] allocWithZone:zone] init];
    Class clazz = [self class];
    while (clazz != [NSObject class]) {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            id value = [self valueForKey:propertyName];
            if (value) {
                [newObject setValue:value forKey:propertyName];
            }
        }
        free(properties);
        clazz = [clazz superclass];
    }
    return newObject;
}

@end
