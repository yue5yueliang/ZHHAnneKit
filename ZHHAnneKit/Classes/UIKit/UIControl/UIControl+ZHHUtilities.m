//
//  UIControl+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIControl+ZHHUtilities.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@interface UIControl ()
/** 是否忽略点击 */
@property(nonatomic)BOOL zhh_ignoreEvent;
@end

static char const * const zhh_kSoundsKey = "zhh_kSoundsKey";
@implementation UIControl (ZHHUtilities)

// 通过方法交换（Method Swizzling），替换系统的 `sendAction:to:forEvent:` 方法，来实现按钮防止重复点击
+ (void)load {
    // 获取系统的 `sendAction:to:forEvent:` 方法和自定义的 `zhh_sendAction:to:forEvent:` 方法
    Method sys_Method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method add_Method = class_getInstanceMethod(self, @selector(zhh_sendAction:to:forEvent:));
    
    // 交换方法的实现
    method_exchangeImplementations(sys_Method, add_Method);
}

// 自定义的事件处理方法，防止按钮重复点击
- (void)zhh_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    // 如果正在忽略事件，直接返回
    if (self.zhh_ignoreEvent) return;
    
    // 如果设置了防止重复点击的时间间隔
    if (self.zhh_acceptEventInterval > 0) {
        // 设置当前为忽略状态，防止重复点击
        self.zhh_ignoreEvent = YES;
        
        // 延迟一定时间后恢复按钮可点击状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.zhh_acceptEventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.zhh_ignoreEvent = NO;
        });
    }
    
    // 调用原始的 `sendAction:to:forEvent:` 方法，处理实际的事件
    [self zhh_sendAction:action to:target forEvent:event];
}

// 设置 `zhh_ignoreEvent` 属性
- (void)setZhh_ignoreEvent:(BOOL)zhh_ignoreEvent {
    objc_setAssociatedObject(self, @selector(zhh_ignoreEvent), @(zhh_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取 `zhh_ignoreEvent` 属性
- (BOOL)zhh_ignoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

// 设置 `zhh_acceptEventInterval` 属性
- (void)setZhh_acceptEventInterval:(NSTimeInterval)zhh_acceptEventInterval {
    objc_setAssociatedObject(self, @selector(zhh_acceptEventInterval), @(zhh_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取 `zhh_acceptEventInterval` 属性
- (NSTimeInterval)zhh_acceptEventInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}


/**
 *  @brief 为指定的控制事件绑定音效
 *
 *  @discussion
 *  这个方法为控件的特定控制事件（如点击事件）设置一个音效文件。每当该事件触发时，音效会被播放。
 *  如果之前已经为该事件设置了音效，则会移除旧的音效并设置新的音效。
 *
 *  注意：此方法设置音效时，会确保音效不会干扰其他正在播放的音频。
 *
 *  @param name 音效文件的名称，包含文件扩展名（如 "tapSound.wav"）。
 *  @param controlEvent 需要绑定音效的控件事件（如 UIControlEventTouchUpInside）。
 */
- (void)zhh_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent {
    
    // 移除旧的音效绑定
    NSString *oldSoundKey = [NSString stringWithFormat:@"%zd", controlEvent];
    AVAudioPlayer *oldSound = [self zhh_sounds][oldSoundKey];
    [self removeTarget:oldSound action:@selector(play) forControlEvents:controlEvent];
    
    // 设置音效类别，确保不干扰其他音频播放
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryAmbient" error:nil];
    
    // 获取音效文件的URL
    NSString *file = [name stringByDeletingPathExtension];
    NSString *extension = [name pathExtension];
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:file withExtension:extension];
    
    NSError *error = nil;
    
    // 创建并准备音效播放器
    AVAudioPlayer *tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
    // 如果创建音效播放器失败，输出错误信息并返回
    if (!tapSound) {
        NSLog(@"ZHHAnneKit 警告: 无法添加声音 - 错误: %@", error);
        return;
    }
    
    NSString *controlEventKey = [NSString stringWithFormat:@"%zd", controlEvent];
    NSMutableDictionary *sounds = [self zhh_sounds];
    [sounds setObject:tapSound forKey:controlEventKey];
    [tapSound prepareToPlay];
    
    // 为指定的控制事件添加音效播放操作
    [self addTarget:tapSound action:@selector(play) forControlEvents:controlEvent];
}

#pragma mark - Associated Objects Setters/Getters

/**
 *  设置音效字典
 *
 *  @param sounds 音效字典
 */
- (void)setZhh_sounds:(NSMutableDictionary *)sounds {
    objc_setAssociatedObject(self, zhh_kSoundsKey, sounds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  获取音效字典
 *
 *  @return 音效字典
 */
- (NSMutableDictionary *)zhh_sounds {
    NSMutableDictionary *sounds = objc_getAssociatedObject(self, zhh_kSoundsKey);
    
    // 如果字典还没有创建，则创建一个新的
    if (!sounds) {
        sounds = [[NSMutableDictionary alloc] initWithCapacity:2];
        [self setZhh_sounds:sounds];
    }
    return sounds;
}
@end
