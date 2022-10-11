//
//  NSIndexPath+ZHHOffset.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (ZHHOffset)
/**
 *  Compute previous row indexpath
 */
- (NSIndexPath *)zhh_previousRow;
/**
 *  Compute next row indexpath
 */
- (NSIndexPath *)zhh_nextRow;
/**
 *  Compute previous item indexpath
 */
- (NSIndexPath *)zhh_previousItem;
/**
 *  Compute next item indexpath
 */
- (NSIndexPath *)zhh_nextItem;
/**
 *  Compute next section indexpath
 */
- (NSIndexPath *)zhh_nextSection;
/**
 *  Compute previous section indexpath
 */
- (NSIndexPath *)zhh_previousSection;
@end

NS_ASSUME_NONNULL_END
