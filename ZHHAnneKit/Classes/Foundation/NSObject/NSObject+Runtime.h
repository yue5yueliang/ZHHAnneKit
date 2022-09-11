//
//  NSObject+Runtime.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Runtime)
/// 获取对象的所有属性
@property (nonatomic, strong, readonly) NSArray<NSString *> *propertyTemps;
/// 实例变量列表
@property (nonatomic, strong, readonly) NSArray<NSString *> *ivarTemps;
/// 方法列表
@property (nonatomic, strong, readonly) NSArray<NSString *> *methodTemps;
/// 遵循的协议列表
@property (nonatomic, strong, readonly) NSArray<NSString *> *protocolTemps;
/// 获取对象的所有属性，无论它是否包含父类的属性
@property (nonatomic, strong, readonly) NSArray<NSString *> *(^objectProperties)(BOOL containSuper);

/// 归档封装
- (void)zhh_runtimeEncode:(NSCoder *)encoder;
/// 解档封装
- (void)zhh_runtimeInitCoder:(NSCoder *)decoder;
/// NSCopying协议快捷设置
- (id)zhh_setCopyingWithZone:(NSZone *)zone;
/// 拷贝obj属性
- (void)zhh_copyingObject:(id)obj;

/// 拷贝指定类属性
- (instancetype)zhh_appointCopyPropertyClass:(Class)clazz Zone:(NSZone *)zone;
/// 拷贝全部属性（包括父类）
- (instancetype)zhh_copyPropertyWithZone:(NSZone *)zone;

/// 交换实例方法
FOUNDATION_EXPORT void kRuntimeMethodSwizzling(Class clazz, SEL original, SEL swizzled);
/// 交换类方法
FOUNDATION_EXPORT void kRuntimeClassMethodSwizzling(Class clazz, SEL original, SEL swizzled);

/// 动态继承，慎用（一旦修改后面使用的都是该子类）
- (void)zhh_dynamicInheritChildClass:(Class)clazz;

/// 获取对象类名
- (NSString *)zhh_runtimeClassName;

/// 判断对象是否有该属性
- (void)zhh_runtimeHaveProperty:(void(^)(NSString * property, BOOL * stop))traversal;

@end

NS_ASSUME_NONNULL_END
