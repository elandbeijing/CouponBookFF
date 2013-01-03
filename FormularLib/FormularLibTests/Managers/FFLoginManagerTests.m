//
//  FFLoginManagerTests.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFLoginManagerTests.h"

@implementation FFLoginManagerTests

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize loginManager = _loginManager;

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(id<FFLoginManagerProtocol>)loginManager
{
    if(!_loginManager)
        _loginManager = [NSClassFromString(self.environmentInformationManager.loginManagerClassName) loginManager];
    return _loginManager;
}

-(void)testLogin
{
//    STAssertTrue([self.loginManager login], @"login is failed");
}

@end
