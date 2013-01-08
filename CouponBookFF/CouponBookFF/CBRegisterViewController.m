//
//  CBRegisterViewController.m
//  CouponBookFF
//
//  Created by ElandApple02 on 13. 1. 7..
//  Copyright (c) 2013년 ElandApple02. All rights reserved.
//

#import "CBRegisterViewController.h"
#import "CBJSONResult.h"
#import "CBNetworkHelper.h"
#import "CBPropertyList.h"
#import "CBDeviceRegViewController.h"

@interface CBRegisterViewController ()

@end

@implementation CBRegisterViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtNickName:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}
- (IBAction)register:(id)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[FFURLHelper getFullUrl:@"Account/RegisterUser"]]];
    [request setHTTPMethod:@"POST"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    //    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
    //                           [self txtName],@"userID",
    //                           [self txtPassword],@"password",
    //                           [CBNetworkHelper macAddress], @"deviceId",
    //                          nil];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [self txtName],@"userID",
                           [self txtPassword],@"password",
                          [self txtPassword],@"userName",
                          nil];
    
    
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"C8:AA:21:CD:B0:13", @"deviceId",
//                           nil];
    [request setHTTPBody:[[param urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        
        if([response statusCode] == 200) {
            CBJSONResult *json = [[CBJSONResult alloc] initWithJSON:JSON];
            if([json.result isEqualToString:@"success"]) {
                //save success
                CBDeviceRegViewController *deviceController=[[CBDeviceRegViewController alloc] initWithNibName:@"CBDeviceRegViewController" bundle:nil];
                [self presentModalViewController:deviceController animated:YES];
            } else if([json.result isEqualToString:@"failure"]) {
                [details setValue:json.msg
                           forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                     code:CBRequestResultCodeCustomError
                                                 userInfo:details];
                //failure(error);
            } else {
                [details setValue:@"json format exception"
                           forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                     code:CBRequestResultCodeJsonError
                                                 userInfo:details];
               // failure(error);
            }
            
        } else {
            [details setValue:[JSON objectForKey:@"data"] forKey:@"data"];
            [details setValue:[NSString stringWithFormat:@"%d %@", [response statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]]
                       forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                 code:CBRequestResultCodeServerError
                                             userInfo:details];
           // failure(error);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[error.userInfo valueForKey:NSLocalizedDescriptionKey]
                   forKey:NSLocalizedDescriptionKey];
       // failure(error);
    }];
    [operation start];
    
    
}
@end
