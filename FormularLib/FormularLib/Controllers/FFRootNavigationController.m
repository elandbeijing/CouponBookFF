//
//  FFRootNavigationController.m
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFRootNavigationController.h"

@interface FFRootNavigationController ()

@end

@implementation FFRootNavigationController

@synthesize orientation = _orientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSString *deviceOrientation = self.orientation;
    
    if ([deviceOrientation isEqualToString:@"all"]) {
//        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
//            self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.height - MF_SLIDE_LEFT_MENU_WIDTH;
//        } else {
//            self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.width - MF_SLIDE_LEFT_MENU_WIDTH;
//        }
        return UIInterfaceOrientationMaskAll;
        
    } else if ([deviceOrientation isEqualToString:@"portrait_all"]) {
//        self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.width - MF_SLIDE_LEFT_MENU_WIDTH;
        return UIInterfaceOrientationMaskPortraitUpsideDown;
        
    } else if ([deviceOrientation isEqualToString:@"landscape"]) {
//        self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.height - MF_SLIDE_LEFT_MENU_WIDTH;
        return UIInterfaceOrientationMaskLandscape;
        
    } else if ([deviceOrientation isEqualToString:@"both"]) {
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
//            self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.height - MF_SLIDE_LEFT_MENU_WIDTH;
        } else {
//            self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.width - MF_SLIDE_LEFT_MENU_WIDTH;
        }
        return UIInterfaceOrientationMaskAllButUpsideDown;
        
    } else { // portrait
//        self.viewDeckController.leftLedge = [[UIScreen mainScreen] bounds].size.width - MF_SLIDE_LEFT_MENU_WIDTH;
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
