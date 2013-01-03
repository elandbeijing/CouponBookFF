//
//  FFInitViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFInitViewController.h"
#import "FFInitializer.h"
#import "FFNotificationManagerProtocol.h"
#import "FFMenuViewController.h"
#import "NSBundle+Extension.h"

@interface FFInitViewController (){
    UIImageView *imageView;
    UIActivityIndicatorView *activityInticatorView;
    BOOL isCompleteInitAction;
}
@property (nonatomic, strong) FFInitializer *initializer;
@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, strong) id<FFNotificationManagerProtocol> notificationManager;
@end

@implementation FFInitViewController
@synthesize initializer = _initializer;
@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize notificationManager = _notificationManager;

-(FFInitializer *)initializer
{
    if(!_initializer)
        _initializer = [[FFInitializer alloc]init];
    return _initializer;
}

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(id<FFNotificationManagerProtocol>)notificationManager
{
    if(!_notificationManager)
        _notificationManager = [NSClassFromString(self.environmentInformationManager.notificationManagerClassName) notificationManager];
    return _notificationManager;
}

#pragma mark - ViewController Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = nil;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
        if (screenBounds.size.height == 568)
            image = [UIImage imageNamed:@"Default-568h@2x.png"];
        else
            image = [UIImage imageNamed:@"Default@2x.png"];

    } else {
        image = [UIImage imageNamed:@"Default.png"];
    }
    imageView = [[UIImageView alloc]initWithFrame:screenBounds];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    activityInticatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityInticatorView.center = self.view.center;
    [self.view addSubview:activityInticatorView];
    [activityInticatorView startAnimating];

    // initialize
    [self.initializer initialize:^(void){
        [self start];
    }];
}

#pragma mark - setup application


-(void)start
{
    NSLog(@"start");
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle resourceBundle]];
        UIViewController *revealViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"RevealViewController"];
        revealViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:revealViewController animated:YES completion:^(void){
            if(self.notificationManager.isStartAppWithRemoteNotification)
                [self.notificationManager receiveRemoteNotification:UIApplicationStateInactive];
        }];
    }
    else{
        NSLog(@"ipad init complete");
        UISplitViewController *splitViewController = (UISplitViewController *)self.presentingViewController;
        [(FFMenuViewController *)[[splitViewController.viewControllers objectAtIndex:0] topViewController] setupMenu];
        NSLog(@"ipad menu setup complete");
        [self dismissViewControllerAnimated:YES completion:^(void){
            NSLog(@"dismiss initViewController");
            if(self.notificationManager.isStartAppWithRemoteNotification){
                NSLog(@"isStartAppWithRemoteNotification");
                [self.notificationManager receiveRemoteNotification:UIApplicationStateInactive];
            }
        }];
    }
    
}

@end
