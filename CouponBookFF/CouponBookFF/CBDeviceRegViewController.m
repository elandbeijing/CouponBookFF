//
//  CBDeviceRegViewController.m
//  CouponBookFF
//
//  Created by ElandApple02 on 13. 1. 8..
//  Copyright (c) 2013년 ElandApple02. All rights reserved.
//

#import "CBDeviceRegViewController.h"
#import "CBJSONResult.h"
#import "CBNetworkHelper.h"
#import "CBPropertyList.h"



@interface CBDeviceRegViewController ()

@end

@implementation CBDeviceRegViewController

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
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(changePage)];
    [[self navigationItem] setRightBarButtonItem:barButton animated:YES];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)changePage
{
   [self dismissModalViewControllerAnimated:YES];
    
                   // [[self navigationController] dis :YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 

- (IBAction)register:(id)sender {
    
    [[self txtName] resignFirstResponder];
    [[self txtPassword] resignFirstResponder];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[FFURLHelper getFullUrl:@"Account/RegisterDevice"]]];
    [request setHTTPMethod:@"POST"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [self txtName].text,@"userID",
                               [self txtPassword].text,@"password",
                               [CBNetworkHelper macAddress], @"deviceId",
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
               UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"tip" message:@"save success" delegate:self
            cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                [alert show];
                
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
- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}

- (IBAction)leavefocus:(id)sender {
    
    [[self txtName] resignFirstResponder];
    [[self txtPassword] resignFirstResponder];
}
@end
