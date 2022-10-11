//
//  NSIndexPath+ZHHOffset.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSIndexPath+ZHHOffset.h"

@implementation NSIndexPath (ZHHOffset)
#pragma mark - Offset
- (NSIndexPath *)zhh_previousRow {
    return [NSIndexPath indexPathForRow:self.row - 1 inSection:self.section];
}

- (NSIndexPath *)zhh_nextRow {
    return [NSIndexPath indexPathForRow:self.row + 1 inSection:self.section];
}

- (NSIndexPath *)zhh_previousItem {
    return [NSIndexPath indexPathForItem:self.item - 1 inSection:self.section];
}

- (NSIndexPath *)zhh_nextItem {
    return [NSIndexPath indexPathForItem:self.item + 1 inSection:self.section];
}

- (NSIndexPath *)zhh_nextSection {
    return [NSIndexPath indexPathForRow:self.row inSection:self.section + 1];
}

- (NSIndexPath *)zhh_previousSection {
    return [NSIndexPath indexPathForRow:self.row inSection:self.section - 1];
}
@end
