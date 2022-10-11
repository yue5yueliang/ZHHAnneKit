//
//  NSObject+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSObject+ZHHExtend.h"
#import <objc/runtime.h>

@implementation NSObject (ZHHExtend)
/// 代码执行时间处理，block当中执行代码
CFTimeInterval kDoraemonBoxExecuteTimeBlock(void(^block)(void)){
    if (block) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        block();
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"Linked in %f ms", linkTime * 1000.0);
        return linkTime * 1000;
    }
    return 0;
}
/// 延迟点击
void kDoraemonBoxAvoidQuickClick(float time){
    static BOOL canClick;
    if (canClick) return;
    canClick = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        canClick = NO;
    });
}

/// 获取 [to from] 之间的数据
+ (NSInteger)zhh_randomNumber:(NSInteger)from to:(NSInteger)to{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

/// 保存到相册
static char kSavePhotosKey;
- (void)zhh_saveImageToPhotosAlbum:(UIImage *)image complete:(void(^)(BOOL))complete{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    objc_setAssociatedObject(self, &kSavePhotosKey, complete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    void(^withBlock)(BOOL success) = objc_getAssociatedObject(self, &kSavePhotosKey);
    if (withBlock) withBlock(error == nil ? YES : NO);
}
@end
