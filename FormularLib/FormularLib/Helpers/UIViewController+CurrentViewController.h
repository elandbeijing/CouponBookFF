//
//  UIViewController+CurrentViewController.h
//  FormularLib
//
//  Created by 장재휴 on 12. 12. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CurrentViewController)
+ (UIViewController *)currentViewController;
+ (void)setCurrentViewController:(UIViewController *)currentViewController;
- (void)addMenuRevealButton;
@end
