//
//  UIView+ZHHGradient.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//[btn zhh_viewGradientBackgroundWithColors:@[[UIColor redColor],[UIColor orangeColor]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
@interface UIView (ZHHGradient)

/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */
@property(nullable, copy) NSArray *colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */
@property(nullable, copy) NSArray<NSNumber *> *locations;

/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

@property CGPoint startPoint;
@property CGPoint endPoint;

+ (UIView *_Nullable)zhh_viewGradientWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)zhh_viewGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end

NS_ASSUME_NONNULL_END
