//
//  UIImageView+ZHHUtilities.m
//  Pods
//
//  Created by 桃色三岁 on 2024/11/19.
//

#import "UIImageView+ZHHUtilities.h"
#import <objc/runtime.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

// 黄金比例常量，用于调整图片裁剪后的显示位置，确保视觉效果最佳。
// GOLDEN_RATIO 定义为 0.618（1:0.618 的比例），广泛应用于美学和设计领域。
static const CGFloat GOLDEN_RATIO = 0.618;

// 全局静态变量，用于缓存 CIDetector 对象，避免频繁创建
static CIDetector *detector;

// 定义用于标识自定义图层名称的静态字符串
static NSString *const BETTER_LAYER_NAME = @"com.zhh.betterface.layer";

@implementation UIImageView (ZHHUtilities)

// 交换 UIImageView 的 setImage: 方法，用于插入人脸检测的逻辑
void hack_uiimageview_bf(void){
    Method oriSetImgMethod = class_getInstanceMethod([UIImageView class], @selector(setImage:));
    Method newSetImgMethod = class_getInstanceMethod([UIImageView class], @selector(_setBetterFaceImage:));
    method_exchangeImplementations(newSetImgMethod, oriSetImgMethod);
}

// 设置带有人脸检测优化的图片
- (void)setBetterFaceImage:(UIImage *)image{
    [self setImage:image];// 调用原始的 setImage: 方法
    if (![self needsBetterFace]) {// 判断是否需要进行人脸优化
        return;
    }
    
    [self faceDetect:image];// 进行人脸检测
}

// 交换后的 setImage: 方法实现
- (void)_setBetterFaceImage:(UIImage *)image {
    [self _setBetterFaceImage:image]; // 调用原始的 setImage: 方法
    if (![self needsBetterFace]) { // 判断是否需要进行人脸优化
        return;
    }
    [self faceDetect:image]; // 进行人脸检测
}

// 存储是否需要人脸优化的属性值
char nbfKey;
- (void)setNeedsBetterFace:(BOOL)needsBetterFace{
    objc_setAssociatedObject(self, &nbfKey, [NSNumber numberWithBool:needsBetterFace], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取是否需要人脸优化的属性值
- (BOOL)needsBetterFace{
    NSNumber *associatedObject = objc_getAssociatedObject(self, &nbfKey);
    return [associatedObject boolValue];
}

// 存储是否使用快速模式的属性值
char fastSpeedKey;
- (void)setFast:(BOOL)fast{
    objc_setAssociatedObject(self, &fastSpeedKey, [NSNumber numberWithBool:fast], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取是否使用快速模式的属性值
- (BOOL)fast{
    NSNumber *associatedObject = objc_getAssociatedObject(self, &fastSpeedKey);
    return [associatedObject boolValue];
}

// 存储 CIDetector 对象
char detectorKey;
- (void)setDetector:(CIDetector *)detector{
    objc_setAssociatedObject(self, &detectorKey, detector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 获取 CIDetector 对象
- (CIDetector *)detector{
    return objc_getAssociatedObject(self, &detectorKey);
}

// 人脸检测的核心方法
- (void)faceDetect:(UIImage *)aImage {
    // 创建一个异步队列，避免阻塞主线程
    dispatch_queue_t queue = dispatch_queue_create("com.croath.betterface.queue", NULL);
    dispatch_async(queue, ^{
        CIImage* image = aImage.CIImage;// 从 UIImage 获取 CIImage
        if (image == nil) { // 如果 UIImage 的 CIImage 为空，则从 CGImage 转换
            image = [CIImage imageWithCGImage:aImage.CGImage];
        }
        if (detector == nil) {// 如果 CIDetector 未创建，则根据模式初始化
            NSDictionary  *opts = [NSDictionary dictionaryWithObject:[self fast] ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
            detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
        }
        
        // 检测人脸特征
        NSArray* features = [detector featuresInImage:image];
        
        if ([features count] == 0) {// 如果未检测到人脸
            NSLog(@"no faces");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self imageLayer] removeFromSuperlayer];// 移除人脸检测相关的图层
            });
        } else {// 检测成功
            NSLog(@"succeed %lu faces", (unsigned long)[features count]);
            [self markAfterFaceDetect:features size:CGSizeMake(CGImageGetWidth(aImage.CGImage), CGImageGetHeight(aImage.CGImage))];
        }
    });
}

// 根据检测到的人脸特征调整图片
- (void)markAfterFaceDetect:(NSArray *)features size:(CGSize)size{
    CGRect fixedRect = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);// 初始化检测区域
    CGFloat rightBorder = 0, bottomBorder = 0;// 初始化边界
    for (CIFaceFeature *f in features){
        CGRect oneRect = f.bounds;// 获取人脸特征的边界
        oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height;// 修正 Y 坐标
        
        // 更新检测区域
        fixedRect.origin.x = MIN(oneRect.origin.x, fixedRect.origin.x);
        fixedRect.origin.y = MIN(oneRect.origin.y, fixedRect.origin.y);
        rightBorder = MAX(oneRect.origin.x + oneRect.size.width, rightBorder);
        bottomBorder = MAX(oneRect.origin.y + oneRect.size.height, bottomBorder);
    }
    
    // 计算最终区域和中心点
    fixedRect.size.width = rightBorder - fixedRect.origin.x;
    fixedRect.size.height = bottomBorder - fixedRect.origin.y;
    CGPoint fixedCenter = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0, fixedRect.origin.y + fixedRect.size.height / 2.0);
    
    CGPoint offset = CGPointZero; // 初始化偏移
    CGSize finalSize = size; // 初始化最终大小
    
    // 根据图片比例调整偏移和大小
    if (size.width / size.height > self.bounds.size.width / self.bounds.size.height) {
        finalSize.height = self.bounds.size.height;
        finalSize.width = size.width/size.height * finalSize.height;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.x = fixedCenter.x - self.bounds.size.width * 0.5;
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x + self.bounds.size.width > finalSize.width) {
            offset.x = finalSize.width - self.bounds.size.width;
        }
        offset.x = - offset.x;
    } else {
        finalSize.width = self.bounds.size.width;
        finalSize.height = size.height/size.width * finalSize.width;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.y = fixedCenter.y - self.bounds.size.height * (1-GOLDEN_RATIO);
        if (offset.y < 0) {
            offset.y = 0;
        } else if (offset.y + self.bounds.size.height > finalSize.height){
            offset.y = finalSize.height - self.bounds.size.height;
        }
        offset.y = - offset.y;
    }
    
    // 在主线程更新图层
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *layer = [self imageLayer];
        layer.frame = CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height);
        layer.contents = (id)self.image.CGImage;
    });
}

// 获取或创建用于显示的图层
- (CALayer *)imageLayer {
    for (CALayer *layer in [self.layer sublayers]) {
        if ([[layer name] isEqualToString:BETTER_LAYER_NAME]) {
            return layer;
        }
    }
    
    CALayer *layer = [CALayer layer];
    [layer setName:BETTER_LAYER_NAME];
    layer.actions = @{@"contents": [NSNull null],
                      @"bounds": [NSNull null],
                      @"position": [NSNull null]};
    [self.layer addSublayer:layer];
    return layer;
}
@end
