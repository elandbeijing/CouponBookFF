//
//  FFAccountManagerTests.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFAccountManagerTests.h"

@interface FFAccountManagerTests(){
    BOOL _isDone;
}

@end

@implementation FFAccountManagerTests

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize accountManager = _accountManager;

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}
-(id<FFAccountManagerProtocol>)accountManager
{
    if(!_accountManager)
        _accountManager = [NSClassFromString(self.environmentInformationManager.accountManagerClassName) accountManager];
    return _accountManager;
}

//-(void)testSetMenuInfo
//{
//    STAssertNotNil(self.accountManager, @"accountManager is not set");
//
//    [NSRunLoop currentRunLoop];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMenuInfoTest:) name:@"setMenuInfoTest" object:self];
//    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:@"setMenuInfoTest" object:self]postingStyle:NSPostWhenIdle];
//    
//    while (!_isDone)
//    {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
//    }
//}

- (void) setMenuInfoTest:(NSNotification*)notification;
{
    [self.accountManager setMenuInfo:^(void){
        STAssertNotNil(self.accountManager.menuSections, @"menu information is not set");
        STAssertTrue(self.accountManager.menuSections.count >= 1, @"Fail");
        NSLog(@"\n===========MENU===========\n%@",self.accountManager.menuSections);
        
        _isDone = YES;
    }failure:^(NSError *error){
        
    }];
    
}

@end
