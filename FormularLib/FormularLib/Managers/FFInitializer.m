//
//  FFInitializer.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFInitializer.h"
#import "FFNotificationManagerProtocol.h"
#import "FFEnvironmentInformationManager.h"

@interface FFInitializer()
@end

@implementation FFInitializer

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize accountManager = _accountManager;
@synthesize loginManager = _loginManager;

#pragma mark - setter/getter

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(id<FFAccountManagerProtocol>)accountManager
{
    if(!_accountManager){
        _accountManager = [NSClassFromString(self.environmentInformationManager.accountManagerClassName) accountManager];
    }
    return _accountManager;
}

-(id<FFLoginManagerProtocol>)loginManager
{
    if(!_loginManager)
        _loginManager = [NSClassFromString(self.environmentInformationManager.loginManagerClassName) loginManager];
    return _loginManager;
}



#pragma mark - public method

-(void)initialize:(next_action_block)nextAction
{   
    // 1. login
    [self firstLogin:^(void){
        
        // 2. set menu info
        [self setMenuInfo:^(void) {
            
            // 3. next action
            nextAction();
        }];
    }];
    

}

#pragma mark - private method

// 1. login
-(void)firstLogin:(next_action_block)nextAction
{
    [self.loginManager firstLogin:^(void){
        nextAction();
    } failure:^(NSError *error){
        NSLog(@"<<ERRROR>> \nCurrentAction:%@ \nErrorInfo:%@",@"login", error);
    }];
}

// 2. set menu info
-(void)setMenuInfo:(next_action_block)nextAction
{
    [self.accountManager setMenuInfo:^(void){
        nextAction();
    } failure:^(NSError *error){
        NSLog(@"<<ERRROR>> \nCurrentAction:%@ \nErrorInfo:%@",@"setMenuInfo", error);
    }];
}

@end
