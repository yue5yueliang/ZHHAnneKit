//
//  UIButton+Position.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIButton+Position.h"
#import <objc/runtime.h>

static char * const kButtonUserID = "kButtonUserID";

@implementation UIButton (Position)
- (NSObject *)zhh_userid {
    return objc_getAssociatedObject(self, &kButtonUserID);
}

- (void)setZhh_userid:(NSObject *)value {
    objc_setAssociatedObject(self, &kButtonUserID, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)zhh_setButtonImageWithUrl:(NSString *)imageURL {
    NSURL *url = [NSURL URLWithString:imageURL];
    // 根据图片的url下载图片数据
    dispatch_queue_t ttQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
    dispatch_async(ttQueue, ^{
        // 异步下载图片
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:img forState:UIControlStateNormal];
        });
    });
}
@end

@implementation UIButton (ImagePosition)
- (void)zhh_setButtonTitleWithImageEdgeInsets:(kImagePosition)postion spacing:(CGFloat)spacing {
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    switch (postion) {
        case kImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
        case kImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
        case kImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
        case kImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        default:
            break;
    }
}
@end

@implementation UIButton (Gradient)
- (UIButton *)zhh_gradientButtonWithSize:(CGSize)size colorArr:(NSArray *)colorArr percentArr:(NSArray *)percentArr gradientType:(ZHHGradientType)type{
    UIImage *image = [[UIImage alloc] zhh_imageGradientWithSize:size colorArr:colorArr percentArr:percentArr gradientType:type];
    
    [self setBackgroundImage:image forState:UIControlStateNormal];
    
    return self;
}
@end

@implementation UIButton (Block)

static NSString * const _Nonnull DoraemonBoxEventsStringMap[] = {
    [UIControlEventTouchDown]        = @"kDoraemonBoxUIControlEventTouchDown",
    [UIControlEventTouchDownRepeat]  = @"kDoraemonBoxUIControlEventTouchDownRepeat",
    [UIControlEventTouchDragInside]  = @"kDoraemonBoxUIControlEventTouchDragInside",
    [UIControlEventTouchDragOutside] = @"kDoraemonBoxUIControlEventTouchDragOutside",
    [UIControlEventTouchDragEnter]   = @"kDoraemonBoxUIControlEventTouchDragEnter",
    [UIControlEventTouchDragExit]    = @"kDoraemonBoxUIControlEventTouchDragExit",
    [UIControlEventTouchUpInside]    = @"kDoraemonBoxUIControlEventTouchUpInside",
    [UIControlEventTouchUpOutside]   = @"kDoraemonBoxUIControlEventTouchUpOutside",
    [UIControlEventTouchCancel]      = @"kDoraemonBoxUIControlEventTouchCancel",
};
#define kDoraemonBoxButtonAction(name) \
- (void)zhh_action##name{ \
    ZHHButtonBlock block = objc_getAssociatedObject(self, _cmd);\
    if (block) block(self);\
}
/// 事件响应方法
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchDown);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchDownRepeat);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchDragInside);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchDragOutside);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchDragEnter);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchDragExit);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchUpInside);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchUpOutside);
kDoraemonBoxButtonAction(kDoraemonBoxUIControlEventTouchCancel);


/// 添加点击事件，默认UIControlEventTouchUpInside
- (void)zhh_addAction:(void(^)(UIButton * kButton))block{
    [self zhh_addAction:block forControlEvents:UIControlEventTouchUpInside];
}
/// 添加事件
- (void)zhh_addAction:(ZHHButtonBlock)block forControlEvents:(UIControlEvents)controlEvents{
    if (block == nil || controlEvents > (1<<8)) return;
    if (controlEvents != UIControlEventTouchDown && (controlEvents&1)) return;
    NSString *actionName = [@"zhh_action" stringByAppendingFormat:@"%@",DoraemonBoxEventsStringMap[controlEvents]];
    SEL selector = NSSelectorFromString(actionName);
    objc_setAssociatedObject(self, selector, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:selector forControlEvents:controlEvents];
}

@end

