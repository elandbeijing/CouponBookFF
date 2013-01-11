//
//  CBDeviceRegViewController.h
//  CouponBookFF
//
//  Created by ElandApple02 on 13. 1. 8..
//  Copyright (c) 2013년 ElandApple02. All rights reserved.
//


#import <FormularLib/FormularLib.h>

@interface CBDeviceRegViewController : UIViewController
- (IBAction)register:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)leavefocus:(id)sender;
@end
