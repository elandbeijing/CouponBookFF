//
//  FFRevealViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFRevealViewController.h"
#import "NSBundle+Extension.h"

@interface FFRevealViewController ()

@end

@implementation FFRevealViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        // left view, right view 셋팅
        UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle resourceBundle]];
        UIViewController *rearViewController = [stroyBoard instantiateViewControllerWithIdentifier:@"LeftNavigationController"];
        UIViewController *frontViewController = [stroyBoard instantiateViewControllerWithIdentifier:@"RightNavigationController"];
        self.frontViewController = frontViewController;
        self.rearViewController = rearViewController;
        [self performSelector:@selector(_loadDefaultConfiguration)];
    }
    return self;
}

-(void)hideRearViewController
{
    if (FrontViewPositionRight == self.currentFrontViewPosition)
        [self revealToggle:self];
}

-(void)showRearViewController
{
    if (FrontViewPositionLeft == self.currentFrontViewPosition)
        [self revealToggle:self];
}

@end
