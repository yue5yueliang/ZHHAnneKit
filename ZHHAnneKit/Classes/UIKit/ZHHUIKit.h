//
//  ZHHUIKit.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#ifndef ZHHUIKit_h
#define ZHHUIKit_h

#if __has_include(<ZHHAnneKit/ZHHUIKit.h>)
#import <ZHHAnneKit/UIApplication+ZHHUtilities.h>
#import <ZHHAnneKit/UIBarButtonItem+ZHHUtilities.h>
#import <ZHHAnneKit/UIBarButtonItem+UINavigationButton.h>

#import <ZHHAnneKit/UIButton+ZHHContentLayout.h>
#import <ZHHAnneKit/UIButton+ZHHEmitter.h>
#import <ZHHAnneKit/UIButton+ZHHCommon.h>
#import <ZHHAnneKit/UIButton+ZHHIndicator.h>
#import <ZHHAnneKit/UIButton+ZHHUtilities.h>

#import <ZHHAnneKit/UICollectionView+ZHHUtilities.h>
#import <ZHHAnneKit/UICollectionViewCell+ZHHUtilities.h>
#import <ZHHAnneKit/UIColor+ZHHUtilities.h>
#import <ZHHAnneKit/UIControl+ZHHUtilities.h>

#import <ZHHAnneKit/UIDevice+ZHHUtilities.h>
#import <ZHHAnneKit/UIDevice+ZHHHardware.h>

#import <ZHHAnneKit/UIImage+ZHHAlpha.h>
#import <ZHHAnneKit/UIImage+ZHHBetterFace.h>
#import <ZHHAnneKit/UIImage+ZHHCapture.h>
#import <ZHHAnneKit/UIImage+ZHHColor.h>
#import <ZHHAnneKit/UIImage+ZHHCommon.h>
#import <ZHHAnneKit/UIImage+ZHHCompress.h>
#import <ZHHAnneKit/UIImage+ZHHCut.h>
#import <ZHHAnneKit/UIImage+ZHHMask.h>
#import <ZHHAnneKit/UIImage+ZHHMerge.h>
#import <ZHHAnneKit/UIImage+ZHHOrientation.h>
#import <ZHHAnneKit/UIImage+ZHHQRCode.h>
#import <ZHHAnneKit/UIImage+ZHHResize.h>
#import <ZHHAnneKit/UIImage+ZHHUtilities.h>

#import <ZHHAnneKit/UIImageView+ZHHUtilities.h>

#import <ZHHAnneKit/UILabel+ZHHUtilities.h>
#import <ZHHAnneKit/UINavigationBar+ZHHUtilities.h>

#import <ZHHAnneKit/UINavigationController+ZHHUtilities.h>

#import <ZHHAnneKit/UINavigationItem+ZHHUtilities.h>
#import <ZHHAnneKit/UIScrollView+ZHHUtilities.h>
#import <ZHHAnneKit/UISlider+ZHHUtilities.h>
#import <ZHHAnneKit/UISplitViewController+ZHHUtilities.h>

#import <ZHHAnneKit/UITabBarItem+ZHHUtilities.h>

#import <ZHHAnneKit/UITableView+ZHHUtilities.h>
#import <ZHHAnneKit/UITableViewCell+ZHHUtilities.h>
#import <ZHHAnneKit/UITableViewHeaderFooterView+ZHHUtilities.h>

#import <ZHHAnneKit/UITextField+ZHHCommon.h>
#import <ZHHAnneKit/UITextField+ZHHUtilities.h>

#import <ZHHAnneKit/UITextView+ZHHCommon.h>
#import <ZHHAnneKit/UITextView+ZHHUtilities.h>

#import <ZHHAnneKit/UIView+ZHHBlockGesture.h>
#import <ZHHAnneKit/UIView+ZHHCustomBorder.h>
#import <ZHHAnneKit/UIView+ZHHFrame.h>
#import <ZHHAnneKit/UIView+ZHHRectCorner.h>
#import <ZHHAnneKit/UIView+ZHHScreenshot.h>
#import <ZHHAnneKit/UIView+ZHHShake.h>
#import <ZHHAnneKit/UIView+ZHHUtilities.h>

#import <ZHHAnneKit/UIViewController+ZHHCommon.h>
#import <ZHHAnneKit/UIViewController+ZHHUtilities.h>
#import <ZHHAnneKit/UIViewController+ZHHDismissible.h>

#import <ZHHAnneKit/UIWindow+ZHHUtilities.h>

#else
#import "UIApplication+ZHHUtilities.h"
#import "UIBarButtonItem+ZHHUtilities.h"
#import "UIBarButtonItem+UINavigationButton.h"

#import "UIButton+ZHHContentLayout.h"
#import "UIButton+ZHHEmitter.h"
#import "UIButton+ZHHCommon.h"
#import "UIButton+ZHHIndicator.h"
#import "UIButton+ZHHUtilities.h"

#import "UICollectionView+ZHHUtilities.h"
#import "UICollectionViewCell+ZHHUtilities.h"
#import "UIColor+ZHHUtilities.h"
#import "UIControl+ZHHUtilities.h"

#import "UIDevice+ZHHUtilities.h"
#import "UIDevice+ZHHHardware.h"

#import "UIImage+ZHHAlpha.h"
#import "UIImage+ZHHBetterFace.h"
#import "UIImage+ZHHCapture.h"
#import "UIImage+ZHHColor.h"
#import "UIImage+ZHHCommon.h"
#import "UIImage+ZHHCompress.h"
#import "UIImage+ZHHCut.h"
#import "UIImage+ZHHMask.h"
#import "UIImage+ZHHMerge.h"
#import "UIImage+ZHHOrientation.h"
#import "UIImage+ZHHQRCode.h"
#import "UIImage+ZHHResize.h"
#import "UIImage+ZHHUtilities.h"

#import "UIImageView+ZHHUtilities.h"

#import "UILabel+ZHHUtilities.h"
#import "UINavigationBar+ZHHUtilities.h"

#import "UINavigationController+ZHHUtilities.h"

#import "UINavigationItem+ZHHUtilities.h"
#import "UIScrollView+ZHHUtilities.h"
#import "UISlider+ZHHUtilities.h"
#import "UISplitViewController+ZHHUtilities.h"

#import "UITabBarItem+ZHHUtilities.h"

#import "UITableView+ZHHUtilities.h"
#import "UITableViewCell+ZHHUtilities.h"
#import "UITableViewHeaderFooterView+ZHHUtilities.h"

#import "UITextField+ZHHCommon.h"
#import "UITextField+ZHHUtilities.h"

#import "UITextView+ZHHCommon.h"
#import "UITextView+ZHHUtilities.h"

#import "UIView+ZHHBlockGesture.h"
#import "UIView+ZHHCustomBorder.h"
#import "UIView+ZHHFrame.h"
#import "UIView+ZHHRectCorner.h"
#import "UIView+ZHHScreenshot.h"
#import "UIView+ZHHShake.h"
#import "UIView+ZHHUtilities.h"

#import "UIViewController+ZHHCommon.h"
#import "UIViewController+ZHHUtilities.h"
#import "UIViewController+ZHHDismissible.h"

#import "UIWindow+ZHHUtilities.h"
#endif

#endif /* ZHHUIKit_h */
