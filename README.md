# ZHHAnneKit

[![CI Status](https://img.shields.io/travis/ningxiaomo0516/ZHHAnneKit.svg?style=flat)](https://travis-ci.org/ningxiaomo0516/ZHHAnneKit)
[![Version](https://img.shields.io/cocoapods/v/ZHHAnneKit.svg?style=flat)](https://cocoapods.org/pods/ZHHAnneKit)
[![License](https://img.shields.io/cocoapods/l/ZHHAnneKit.svg?style=flat)](https://cocoapods.org/pods/ZHHAnneKit)
[![Platform](https://img.shields.io/cocoapods/p/ZHHAnneKit.svg?style=flat)](https://cocoapods.org/pods/ZHHAnneKit)

ZHHAnneKit 是一套轻量化、实用的工具库，包含常用的分类和工具类，帮助开发者提升效率、优化代码复用性，同时简化日常开发工作。

## 特性

- 🚀 **高性能**: 优化的内存管理和 Core Foundation 对象处理，移除 iOS 13.0 以下兼容性代码
- 🛡️ **安全可靠**: 完善的参数验证和错误处理，统一的中文警告信息
- 📱 **iOS 13+**: 充分利用最新的 iOS 特性，支持动态颜色、多场景等
- 🎨 **UI 增强**: 丰富的 UIView 扩展方法，支持手势、动画、绘制等
- 🔧 **工具齐全**: 涵盖 Foundation、UIKit、QuartzCore、BadgeView 等模块
- 📚 **文档完善**: 详细的方法注释和使用示例，代码注释中文化
- ⚡ **性能优化**: 线程安全、内存优化、约束管理优化
- 🎯 **代码质量**: 统一的错误处理、参数验证、日志格式

## 模块介绍

### Foundation 扩展
- **NSString**: 拼音转换、文本计算、安全截取、HTML解析、JSON转换等
- **NSObject**: 运行时操作、属性拷贝、性能测量、防快速点击等
- **NSArray/NSDictionary**: 常用数据处理方法、数组运算、筛选排序等
- **NSDate**: 日期格式化、计算、比较等
- **NSNumber**: 数值转换、类型安全等

### UIKit 扩展
- **UIView**: 圆角、阴影、动画、绘制、手势、加载指示器等
- **UIButton**: 按钮状态管理、图片处理、音效等
- **UIImage**: 图片处理、滤镜、压缩、截图、二维码等
- **UILabel**: 文本布局、富文本处理等
- **UIColor**: 动态颜色、渐变、随机颜色、十六进制转换等
- **UINavigationBar**: 外观配置、阴影效果、主题设置等
- **UIViewController**: 导航控制、分享功能、手势管理等

### 其他模块
- **BadgeView**: 徽章视图组件，支持多种显示模式
- **CommonTools**: 通用工具类，包含倒计时、权限管理、钥匙串等
- **QuartzCore**: 动画和图形处理，CALayer 扩展等

## 安装

### CocoaPods

在你的 `Podfile` 中添加：

```ruby
pod 'ZHHAnneKit'
```

### 子模块安装

你也可以只安装需要的子模块：

```ruby
# 只安装 Foundation 扩展
pod 'ZHHAnneKit/Core/Foundation'

# 只安装 UIKit 扩展
pod 'ZHHAnneKit/Core/UIKit'

# 只安装特定子模块
pod 'ZHHAnneKit/Core/Foundation/NSString'
pod 'ZHHAnneKit/Core/UIKit/UIView'
```

## 使用示例

### NSString 扩展

```objc
// 拼音转换
NSString *pinyin = [@"你好" zhh_pinyin]; // 返回 "nihao"
NSString *initials = [@"张三" zhh_pinyinInitial]; // 返回 "ZS"

// 文本尺寸计算
CGSize size = [@"Hello World" zhh_sizeWithFont:[UIFont systemFontOfSize:16] maxWidth:200];

// 安全截取
NSString *substring = [@"Hello World" zhh_safeSubstringToIndex:5]; // 返回 "Hello"
```

### UIView 扩展

```objc
// 创建带背景色的视图
UIView *view = [UIView zhh_viewWithColor:[UIColor redColor]];

// 设置圆角和边框
[view zhh_cornerRadius:10 borderWidth:2 color:[UIColor blueColor]];

// 添加阴影
[view zhh_shadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 2) opacity:0.5 radius:10 cornerRadius:10];

// 绘制图形
[view zhh_drawLineWithPoint:CGPointMake(0, 0) toPoint:CGPointMake(100, 100) lineColor:[UIColor redColor] lineWidth:2.0];

// 添加手势
[view zhh_addTapActionWithBlock:^(UIGestureRecognizer *gesture) {
    NSLog(@"视图被点击了");
}];

// 显示加载指示器
[view zhh_showLoadingIndicator];
```

### NSObject 扩展

```objc
// 性能测量
CFTimeInterval time = [NSObject zhh_measureExecutionTimeOfBlock:^{
    // 你的代码
}];

// 防止快速点击（支持多对象并发）
[NSObject zhh_preventQuickClick:1.0];

// 属性拷贝
MyObject *newObject = [originalObject zhh_copyAllPropertiesWithZone:nil];
```

### UIColor 扩展

```objc
// 动态颜色（支持深色模式）
UIColor *dynamicColor = [UIColor colorWithLightColor:[UIColor whiteColor] 
                                           darkColor:[UIColor blackColor]];

// 十六进制颜色
UIColor *hexColor = [UIColor zhh_colorWithHexString:@"#FF6B6B"];

// 渐变颜色
UIColor *gradientColor = [UIColor zhh_colorWithGradientColor1:[UIColor redColor] 
                                                      color2:[UIColor blueColor] 
                                                      height:100];

// 随机颜色
UIColor *randomColor = [UIColor zhh_randomColorWithAlpha:0.8];
```

### UINavigationBar 扩展

```objc
// 配置导航栏
[navigationBar zhh_configureWithBlock:^(UINavigationBar *bar) {
    bar.zhh_titleColor = [UIColor whiteColor];
    bar.zhh_backgroundColor = [UIColor systemBlueColor];
    bar.zhh_hideBottomLine = YES;
}];

// 添加阴影效果
[navigationBar zhh_navigationBarShadowWithType:ZHHNavigationBarShadowTypeMedium];
```

## 系统要求

- iOS 13.0+
- Xcode 12.0+

## 示例项目

要运行示例项目，请先克隆此仓库，然后进入 Example 目录运行：

```bash
cd Example
pod install
```

## 更新日志

### v0.2.2
- 🚀 **性能优化**: 移除 iOS 13.0 以下兼容性代码，提升运行效率
- 🛡️ **安全增强**: 完善参数验证和错误处理，统一中文警告信息
- ⚡ **内存优化**: 优化 Core Foundation 对象管理，防止内存泄漏
- 🔧 **功能改进**: 改进防快速点击机制，支持多对象并发
- 🎨 **UI 增强**: 新增手势处理、加载指示器、导航栏配置等功能
- 📚 **文档完善**: 代码注释中文化，完善使用示例
- 🎯 **代码质量**: 统一错误处理、参数验证、日志格式
- 🔄 **线程安全**: 优化倒计时管理器等组件的线程安全性

### v0.2.1
- 初始版本发布

## 作者

桃色三岁  
邮箱: 136769890@qq.com

## 许可证

ZHHAnneKit 遵循 MIT 许可证。详细信息请查看 [LICENSE](LICENSE) 文件。

## 优化亮点

### 🚀 性能提升
- **移除兼容性代码**: 清理 iOS 13.0 以下代码，减少运行时开销
- **内存管理优化**: 完善 Core Foundation 对象生命周期管理
- **约束管理优化**: 使用 NSPredicate 提升约束查找效率
- **数组运算优化**: 使用 NSMutableSet 的 intersectSet 方法

### 🛡️ 安全可靠
- **参数验证**: 所有关键方法都添加了完善的参数检查
- **错误处理**: 统一的中文警告信息，便于调试
- **线程安全**: 倒计时管理器等组件使用串行队列保护
- **边界检查**: 防止数组越界、空值访问等异常

### 🎯 代码质量
- **统一规范**: 一致的命名、注释、错误处理方式
- **模块化设计**: 清晰的模块划分和职责分离
- **文档完善**: 详细的方法注释和使用示例
- **可维护性**: 代码结构清晰，易于理解和扩展

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目！

希望本工具库能助您开发更高效！如果您有任何建议或问题，欢迎通过 Issue 或邮件与我联系。 😊
