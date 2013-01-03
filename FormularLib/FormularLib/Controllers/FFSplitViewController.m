//
//  FFSplitViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 20..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFSplitViewController.h"
#import "FFInitializer.h"
#import "FFMenuViewController.h"

@interface FFSplitViewController ()<UISplitViewControllerDelegate>{
    BOOL isCompleteInitialize;
}
@property (nonatomic, strong) FFInitializer *initializer;
@end

@implementation FFSplitViewController
@synthesize initializer = _initializer;

-(FFInitializer *)initializer
{
    if(!_initializer)
        _initializer = [[FFInitializer alloc]init];
    return _initializer;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // UISplitViewControllerDelegate를 self로 설정
    self.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isCompleteInitialize){
        [self performSegueWithIdentifier:@"InitView" sender:self];
        isCompleteInitialize = YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    UIViewController *rootViewController = [[[self.viewControllers lastObject] viewControllers] objectAtIndex:0];
    [rootViewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    //    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UIViewController *rootViewController = [[[self.viewControllers lastObject] viewControllers] objectAtIndex:0];
    [rootViewController.navigationItem setLeftBarButtonItem:nil animated:YES];
    //    self.masterPopoverController = nil;
}

@end
