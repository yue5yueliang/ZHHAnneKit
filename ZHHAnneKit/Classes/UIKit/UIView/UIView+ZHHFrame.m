//
//  UIView+ZHHFrame.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHFrame.h"

@implementation UIView (ZHHFrame)

- (void)setZhh_x:(CGFloat)zhh_x {
    CGRect frame = self.frame;
    frame.origin.x = zhh_x;
    self.frame = frame;
}

- (CGFloat)zhh_x {
    return self.frame.origin.x;
}

- (void)setZhh_y:(CGFloat)zhh_y {
    CGRect frame = self.frame;
    frame.origin.y = zhh_y;
    self.frame = frame;
}

- (CGFloat)zhh_y {
    return self.frame.origin.y;
}

- (void)setZhh_width:(CGFloat)zhh_width {
    CGRect frame = self.frame;
    frame.size.width = zhh_width;
    self.frame = frame;
}

- (CGFloat)zhh_width {
    return self.frame.size.width;
}

- (void)setZhh_height:(CGFloat)zhh_height {
    CGRect frame = self.frame;
    frame.size.height = zhh_height;
    self.frame = frame;
}

- (CGFloat)zhh_height {
    return self.frame.size.height;
}

- (CGFloat)zhh_maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)zhh_maxX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setZhh_size:(CGSize)zhh_size {
    CGRect frame = self.frame;
    frame.size = zhh_size;
    self.frame = frame;
}

- (CGSize)zhh_size {
    return self.frame.size;
}

- (void)setZhh_origin:(CGPoint)zhh_origin {
    CGRect frame = self.frame;
    frame.origin = zhh_origin;
    self.frame = frame;
}

- (CGPoint)zhh_origin {
    return self.frame.origin;
}

- (void)setZhh_originY:(CGFloat)zhh_originY {
    self.frame = CGRectMake(self.frame.origin.x, zhh_originY, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)zhh_originY {
    return self.frame.origin.y;
}

- (void)setZhh_originX:(CGFloat)zhh_originX {
    self.frame = CGRectMake(zhh_originX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)zhh_originX {
    return self.frame.origin.x;
}

- (void)setZhh_centerX:(CGFloat)zhh_centerX {
    CGPoint center = self.center;
    center.x = zhh_centerX;
    self.center = center;
}

- (CGFloat)zhh_centerX {
    return self.center.x;
}

- (void)setZhh_centerY:(CGFloat)zhh_centerY {
    CGPoint center = self.center;
    center.y = zhh_centerY;
    self.center = center;
}

- (CGFloat)zhh_centerY {
    return self.center.y;
}

- (void)setZhh_left:(CGFloat)zhh_left {
    CGRect frame = self.frame;
    frame.origin.x = zhh_left;
    self.frame = frame;
}

- (CGFloat)zhh_left {
    return self.frame.origin.x;
}

- (void)setZhh_top:(CGFloat)zhh_top {
    CGRect frame = self.frame;
    frame.origin.y = zhh_top;
    self.frame = frame;
}

- (CGFloat)zhh_top {
    return self.frame.origin.y;
}

- (void)setZhh_right:(CGFloat)zhh_right {
    CGRect frame = self.frame;
    frame.origin.x = zhh_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)zhh_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setZhh_bottom:(CGFloat)zhh_bottom {
    CGRect frame = self.frame;
    frame.origin.y = zhh_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)zhh_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setZhh_viewOrigin:(CGPoint)zhh_viewOrigin {
    CGRect frame = self.frame;
    frame.origin = zhh_viewOrigin;
    self.frame = frame;
}

- (CGPoint)zhh_viewOrigin {
    return self.frame.origin;
}

- (void)setZhh_viewSize:(CGSize)zhh_viewSize {
    CGRect frame = self.frame;
    frame.size = zhh_viewSize;
    self.frame = frame;
}

- (CGSize)zhh_viewSize {
    return self.frame.size;
}

- (CGFloat)zhh_middleX {
    return CGRectGetWidth(self.bounds) / 2.f;
}

- (CGFloat)zhh_middleY {
    return CGRectGetHeight(self.bounds) / 2.f;
}

- (CGPoint)zhh_middlePoint {
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}

@end
