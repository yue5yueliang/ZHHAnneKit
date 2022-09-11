//
//  UIView+Frame.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)
/*----------------------
 * Absolute coordinate *
 ----------------------*/
@property (nonatomic, assign) CGFloat zhh_x;
@property (nonatomic, assign) CGFloat zhh_y;
@property (nonatomic, assign) CGFloat zhh_width;
@property (nonatomic, assign) CGFloat zhh_height;

@property (nonatomic, assign, readonly) CGFloat zhh_maxX;
@property (nonatomic, assign, readonly) CGFloat zhh_maxY;

@property (nonatomic, assign) CGSize zhh_size;
@property (nonatomic, assign) CGPoint zhh_origin;
@property (nonatomic, assign) CGFloat zhh_originX;
@property (nonatomic, assign) CGFloat zhh_originY;
@property (nonatomic, assign) CGFloat zhh_centerX;
@property (nonatomic, assign) CGFloat zhh_centerY;

@property (nonatomic) CGFloat zhh_top;
@property (nonatomic) CGFloat zhh_bottom;
@property (nonatomic) CGFloat zhh_left;
@property (nonatomic) CGFloat zhh_right;

@property (nonatomic) CGPoint zhh_viewOrigin;
@property (nonatomic) CGSize  zhh_viewSize;

/*----------------------
 * Relative coordinate *
 ----------------------*/
@property (nonatomic, readonly) CGFloat zhh_middleX;
@property (nonatomic, readonly) CGFloat zhh_middleY;
@property (nonatomic, readonly) CGPoint zhh_middlePoint;

@end

NS_ASSUME_NONNULL_END
