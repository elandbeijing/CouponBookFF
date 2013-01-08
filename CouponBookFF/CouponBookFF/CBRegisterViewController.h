//
//  CBRegisterViewController.h
//  CouponBookFF
//
//  Created by ElandApple02 on 13. 1. 7..
//  Copyright (c) 2013년 ElandApple02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FormularLib/FormularLib.h>

@interface CBRegisterViewController : UIViewController
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtNickName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)leaveFocus:(id)sender;

@end
