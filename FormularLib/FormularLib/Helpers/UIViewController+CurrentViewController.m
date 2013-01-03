//
//  UIViewController+CurrentViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 12. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "UIViewController+CurrentViewController.h"
#import "NSBundle+Extension.h"

@implementation UIViewController (CurrentViewController)

static UIViewController *_currentViewController;

+ (UIViewController *)currentViewController
{
    return _currentViewController;
}

+ (void)setCurrentViewController:(UIViewController *)currentViewController
{
    _currentViewController = currentViewController;
}

- (void)addMenuRevealButton;
{
    // Reveal Button Action 셋팅
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
    {
        UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
        UIImage *image = [UIImage imageNamed:@"icons.bundle/menu_icon"];
        if(image)
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
        else
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTableInBundle(@"MENU_BUTTON", nil, [NSBundle resourceBundle], nil) style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
    }
    
}

@end
