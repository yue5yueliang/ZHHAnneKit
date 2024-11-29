//
//  NSObject+ZHHRuntime.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHHRuntime)
/// 获取对象的所有属性（仅限当前类）
@property (nonatomic, strong, readonly) NSArray<NSString *> *zhh_propertyList;
/// 获取对象的实例变量列表（仅限当前类）
@property (nonatomic, strong, readonly) NSArray<NSString *> *zhh_ivarList;
/// 获取对象的方法列表（仅限当前类）
@property (nonatomic, strong, readonly) NSArray<NSString *> *zhh_methodList;
/// 获取对象遵循的协议列表（仅限当前类）
@property (nonatomic, strong, readonly) NSArray<NSString *> *zhh_protocolList;
/// 获取对象的所有属性，无论它是否包含父类的属性
@property (nonatomic, strong, readonly) NSArray<NSString *> *(^zhh_allProperties)(BOOL includeSuperclass);

/// 交换实例方法
/// @param originalSel 原始方法的选择器
/// @param swizzledSel 替换方法的选择器
+ (void)zhh_swizzleInstanceMethod:(SEL)originalSel withMethod:(SEL)swizzledSel;

/// 交换类方法
/// @param originalSel 原始类方法的选择器
/// @param swizzledSel 替换类方法的选择器
+ (void)zhh_swizzleClassMethod:(SEL)originalSel withMethod:(SEL)swizzledSel;

#pragma mark - 动态继承
/// 动态继承，慎用（一旦修改后续调用的都是该子类）
/// @param clazz 子类类型
/// @discussion 修改对象的 `isa` 指针使其指向指定的子类，从而可以动态地使用子类的方法。需谨慎使用，可能引发不可预测的行为。
- (void)zhh_dynamicInheritChildClass:(Class)clazz;

#pragma mark - 获取类名
/// 获取对象的类名
/// @return 类名字符串
/// @discussion 通过 `runtime` 方法动态获取对象的类名。
- (NSString *)zhh_runtimeClassName;

#pragma mark - 判断属性存在性
/// 判断对象是否有指定属性
/// @param traversal 遍历回调，提供属性名及一个 `stop` 参数，用于停止遍历
/// @discussion 遍历对象的属性列表并回调属性名；通过 `stop` 参数可控制是否提前停止遍历。
- (void)zhh_runtimeHaveProperty:(void(^)(NSString *propertyName, BOOL *stop))traversal;

@end


/**
 
 示例 1：拦截 UIViewController 的 viewWillAppear 方法
 目标：在每次 viewWillAppear 调用时，插入自定义日志。

 @implementation UIViewController (SwizzlingExample)

 + (void)load {
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         // 交换实例方法 viewWillAppear: 和 swizzled_viewWillAppear:
         [self zhh_swizzleInstanceMethod:@selector(viewWillAppear:) withMethod:@selector(swizzled_viewWillAppear:)];
     });
 }

 // 替换方法的实现
 - (void)swizzled_viewWillAppear:(BOOL)animated {
     // 调用原始方法实现（即原始的 viewWillAppear:）
     [self swizzled_viewWillAppear:animated];
     
     // 添加自定义行为
     NSLog(@"[ZHH] %@ will appear", NSStringFromClass([self class]));
 }
 UIViewController *vc = [[UIViewController alloc] init];
 [vc viewWillAppear:YES];

 // 控制台输出：
 // [ZHH] UIViewController will appear
 
 @end
 
 示例 2
 @interface ExampleClass : NSObject
 + (void)classMethodA;
 + (void)classMethodB;
 - (void)methodA;
 - (void)methodB;
 @end

 @implementation ExampleClass

 + (void)classMethodA {
     NSLog(@"Original Class Method A");
 }

 + (void)classMethodB {
     NSLog(@"Swizzled Class Method B");
 }

 - (void)methodA {
     NSLog(@"Original methodA implementation");
 }

 - (void)methodB {
     NSLog(@"Original methodB implementation");
 }

 + (void)load {
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         // 交换类方法
         [self zhh_swizzleClassMethod:@selector(classMethodA) withMethod:@selector(classMethodB)];
         // 交换实例方法
         [self zhh_swizzleInstanceMethod:@selector(methodA) withMethod:@selector(methodB)];
     });
 }

 // 测试类方法交换
 [ExampleClass classMethodA]; // 输出：Swizzled Class Method B
 [ExampleClass classMethodB]; // 输出：Original Class Method A

 // 测试实例方法交换
 ExampleClass *obj = [[ExampleClass alloc] init];
 [obj methodA]; // 输出：Original methodB implementation
 [obj methodB]; // 输出：Original methodA implementation
 @end
 */
NS_ASSUME_NONNULL_END
