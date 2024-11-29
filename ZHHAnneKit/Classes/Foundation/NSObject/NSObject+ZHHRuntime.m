//
//  NSObject+ZHHRuntime.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSObject+ZHHRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (ZHHRuntime)

// 获取当前类的所有属性
- (NSArray<NSString *> *)zhh_propertyList {
    return [self zhh_copyPropertyNamesForClass:[self class]];
}

// 获取当前类的实例变量列表
- (NSArray<NSString *> *)zhh_ivarList {
    return [self zhh_copyIvarNamesForClass:[self class]];
}

// 获取当前类的方法列表
- (NSArray<NSString *> *)zhh_methodList {
    return [self zhh_copyMethodNamesForClass:[self class]];
}

// 获取当前类遵循的协议列表
- (NSArray<NSString *> *)zhh_protocolList {
    return [self zhh_copyProtocolNamesForClass:[self class]];
}

// 获取对象的所有属性（包括父类的属性）
- (NSArray<NSString *> *(^)(BOOL))zhh_allProperties {
    // 闭包，返回根据是否包含父类属性来获取属性的不同实现
    return ^NSArray<NSString *> *(BOOL includeSuperclass){
        // 如果需要包含父类属性
        if (includeSuperclass) {
            NSMutableArray *allProperties = [NSMutableArray array];  // 创建一个可变数组来存储属性名
            Class clazz = [self class];  // 获取当前类
            
            // 遍历当前类及父类的属性
            while (clazz != [NSObject class]) {
                // 获取当前类的属性列表
                [allProperties addObjectsFromArray:[self zhh_copyPropertyNamesForClass:clazz]];
                clazz = [clazz superclass];  // 获取父类
            }
            // 返回所有属性的不可变副本
            return [allProperties copy];
        } else {
            // 如果不需要父类属性，直接返回当前类的属性
            return [self zhh_propertyList];
        }
    };
}

// 通用方法：获取类的属性名
- (NSArray<NSString *> *)zhh_copyPropertyNamesForClass:(Class)clazz {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(clazz, &count);  // 获取类的属性列表
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:count];  // 创建一个可变数组来存储属性名
    
    for (int i = 0; i < count; i++) {
        // 获取每个属性的名称
        const char *propertyName = property_getName(properties[i]);
        if (propertyName) {
            // 将属性名称转换为字符串并加入数组
            [propertyNames addObject:[NSString stringWithUTF8String:propertyName]];
        }
    }
    free(properties);  // 释放内存
    return [propertyNames copy];  // 返回不可变数组
}

// 通用方法：获取类的实例变量名
- (NSArray<NSString *> *)zhh_copyIvarNamesForClass:(Class)clazz {
    unsigned int count;
    Ivar *ivars = class_copyIvarList(clazz, &count);  // 获取类的实例变量列表
    NSMutableArray *ivarNames = [NSMutableArray arrayWithCapacity:count];  // 创建一个可变数组来存储实例变量名
    
    for (int i = 0; i < count; i++) {
        // 获取每个实例变量的名称
        const char *ivarName = ivar_getName(ivars[i]);
        if (ivarName) {
            // 将实例变量名称转换为字符串并加入数组
            [ivarNames addObject:[NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
        }
    }
    free(ivars);  // 释放内存
    return [ivarNames copy];  // 返回不可变数组
}

// 通用方法：获取类的方法名
- (NSArray<NSString *> *)zhh_copyMethodNamesForClass:(Class)clazz {
    unsigned int count;
    Method *methods = class_copyMethodList(clazz, &count);  // 获取类的方法列表
    NSMutableArray *methodNames = [NSMutableArray arrayWithCapacity:count];  // 创建一个可变数组来存储方法名
    
    for (int i = 0; i < count; i++) {
        // 获取每个方法的名称
        NSString *methodName = NSStringFromSelector(method_getName(methods[i]));
        if (methodName) {
            // 将方法名称加入数组
            [methodNames addObject:methodName];
        }
    }
    free(methods);  // 释放内存
    return [methodNames copy];  // 返回不可变数组
}

// 通用方法：获取类遵循的协议名
- (NSArray<NSString *> *)zhh_copyProtocolNamesForClass:(Class)clazz {
    unsigned int count;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(clazz, &count);  // 获取类遵循的协议列表
    NSMutableArray *protocolNames = [NSMutableArray arrayWithCapacity:count];  // 创建一个可变数组来存储协议名
    
    for (int i = 0; i < count; i++) {
        // 获取每个协议的名称
        const char *protocolName = protocol_getName(protocols[i]);
        if (protocolName) {
            // 将协议名称转换为字符串并加入数组
            [protocolNames addObject:[NSString stringWithCString:protocolName encoding:NSUTF8StringEncoding]];
        }
    }
    free(protocols);  // 释放内存
    return [protocolNames copy];  // 返回不可变数组
}

/// 交换实例方法
/// @param originalSel 原始方法的选择器
/// @param swizzledSel 替换方法的选择器
/// @discussion 通过 Runtime 修改方法实现的指针，以实现方法交换。
+ (void)zhh_swizzleInstanceMethod:(SEL)originalSel withMethod:(SEL)swizzledSel {
    Class clazz = [self class]; // 获取当前类
    Method originalMethod = class_getInstanceMethod(clazz, originalSel); // 获取原始方法
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSel); // 获取替换方法
    
    // 尝试将替换方法添加为原始方法的实现
    BOOL didAddMethod = class_addMethod(clazz, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        // 如果添加成功，则将原始方法实现替换为替换方法
        class_replaceMethod(clazz, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        // 如果添加失败，说明原始方法已存在，直接交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 交换类方法
/// @param originalSel 原始类方法的选择器
/// @param swizzledSel 替换类方法的选择器
/// @discussion 修改元类的方法实现指针，以实现类方法的交换。
+ (void)zhh_swizzleClassMethod:(SEL)originalSel withMethod:(SEL)swizzledSel {
    Class metaclass = object_getClass([self class]); // 获取元类
    Method originalMethod = class_getClassMethod(metaclass, originalSel); // 获取原始类方法
    Method swizzledMethod = class_getClassMethod(metaclass, swizzledSel); // 获取替换类方法
    
    // 尝试将替换方法添加为原始方法的实现
    BOOL didAddMethod = class_addMethod(metaclass, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        // 如果添加成功，则将原始方法实现替换为替换方法
        class_replaceMethod(metaclass, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        // 如果添加失败，说明原始方法已存在，直接交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 动态继承
/// 动态继承，慎用（一旦修改后续调用的都是该子类）
/// @param clazz 子类类型
/// @discussion 修改对象的 `isa` 指针使其指向指定的子类，从而可以动态地使用子类的方法。需谨慎使用，可能引发不可预测的行为。
- (void)zhh_dynamicInheritChildClass:(Class)clazz {
    // 动态继承修改自身对象的isa指针使其指向子类
    object_setClass(self, clazz);
}

#pragma mark - 获取类名
/// 获取对象的类名
/// @return 类名字符串
/// @discussion 通过 `runtime` 方法动态获取对象的类名。
- (NSString *)zhh_runtimeClassName {
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

#pragma mark - 判断属性存在性
/// 判断对象是否有指定属性
/// @param traversal 遍历回调，提供属性名及一个 `stop` 参数，用于停止遍历
/// @discussion 遍历对象的属性列表并回调属性名；通过 `stop` 参数可控制是否提前停止遍历。
- (void)zhh_runtimeHaveProperty:(void(^)(NSString *propertyName, BOOL *stop))traversal {
    for (NSString *name in self.zhh_propertyList) {
        BOOL stop = NO;
        traversal(name, &stop);
        if (stop) return; // 如果 stop 为 YES，提前终止遍历
    }
}

@end
