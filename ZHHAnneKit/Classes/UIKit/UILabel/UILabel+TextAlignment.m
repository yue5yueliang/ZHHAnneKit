//
//  UILabel+TextAlignment.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UILabel+TextAlignment.h"
#import <objc/runtime.h>

@implementation UILabel (TextAlignment)
- (ZHHLabelTextAlignmentType)zhh_customTextAlignment{
    return (ZHHLabelTextAlignmentType)[objc_getAssociatedObject(self, @selector(zhh_customTextAlignment)) integerValue];
}

- (void)setZhh_customTextAlignment:(ZHHLabelTextAlignmentType)zhh_customTextAlignment{
    objc_setAssociatedObject(self, @selector(zhh_customTextAlignment), @(zhh_customTextAlignment), OBJC_ASSOCIATION_ASSIGN);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(drawTextInRect:)),
                                       class_getInstanceMethod(self.class, @selector(zhh_drawTextInRect:)));
    });
    switch (zhh_customTextAlignment) {
        case ZHHLabelTextAlignmentTypeRight:
        case ZHHLabelTextAlignmentTypeRightTop:
        case ZHHLabelTextAlignmentTypeRightBottom:
            self.textAlignment = NSTextAlignmentRight;
            break;
        case ZHHLabelTextAlignmentTypeLeft:
        case ZHHLabelTextAlignmentTypeLeftTop:
        case ZHHLabelTextAlignmentTypeLeftBottom:
            self.textAlignment = NSTextAlignmentLeft;
            break;
        case ZHHLabelTextAlignmentTypeCenter:
        case ZHHLabelTextAlignmentTypeTopCenter:
        case ZHHLabelTextAlignmentTypeBottomCenter:
            self.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
}
- (void)zhh_drawTextInRect:(CGRect)rect{
    switch (self.zhh_customTextAlignment) {
        case ZHHLabelTextAlignmentTypeRight:
        case ZHHLabelTextAlignmentTypeLeft:
        case ZHHLabelTextAlignmentTypeCenter:
            [self zhh_drawTextInRect:rect];
            break;
        case ZHHLabelTextAlignmentTypeBottomCenter:
        case ZHHLabelTextAlignmentTypeLeftBottom:
        case ZHHLabelTextAlignmentTypeRightBottom:{
            CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
            textRect.origin = CGPointMake(textRect.origin.x, -CGRectGetMaxY(textRect)+rect.size.height);
            [self zhh_drawTextInRect:textRect];
        } break;
        default:{
            CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
            [self zhh_drawTextInRect:textRect];
        } break;
    }
}

#pragma mark - 长按复制功能
- (BOOL)zhh_copyable{
    return [objc_getAssociatedObject(self, @selector(zhh_copyable)) boolValue];
}

- (void)setZhh_copyable:(BOOL)zhh_copyable{
    objc_setAssociatedObject(self, @selector(zhh_copyable), @(zhh_copyable), OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
}

/// 移除拷贝长按手势
- (void)zhh_removeCopyLongPressGestureRecognizer{
    [self removeGestureRecognizer:self.copyGesture];
}

- (void)attachTapHandler{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:self.copyGesture];
}

- (void)handleTap:(UIGestureRecognizer*)recognizer{
    [self becomeFirstResponder];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"复制", nil) action:@selector(zhh_copyText)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

// 复制时执行的方法
- (void)zhh_copyText{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if (objc_getAssociatedObject(self, @"expectedText")) {
        board.string = objc_getAssociatedObject(self, @"expectedText");
    } else {
        if (self.text) {
            board.string = self.text;
        } else {
            board.string = self.attributedText.string;
        }
    }
}

- (BOOL)canBecomeFirstResponder{
    return [objc_getAssociatedObject(self, @selector(zhh_copyable)) boolValue];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(zhh_copyText));
}

#pragma mark - lazzing
- (UILongPressGestureRecognizer*)copyGesture{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, @selector(copyGesture));
    if (gesture == nil) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        objc_setAssociatedObject(self, @selector(copyGesture), gesture, OBJC_ASSOCIATION_RETAIN);
    }
    return gesture;
}
@end
