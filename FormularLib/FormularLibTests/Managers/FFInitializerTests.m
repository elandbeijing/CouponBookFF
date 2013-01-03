//
//  FFInitializerTests.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFInitializerTests.h"
#import "FFSimpleAccountManager.h"
#import "FFSimpleLoginManager.h"
#import "FFSimpleNotificationManager.h"

@interface FFInitializerTests(){
    BOOL _isDone;    
}

@end

@implementation FFInitializerTests

@synthesize initializer = _initializer;

-(FFInitializer *)initializer
{
    if(!_initializer)
        _initializer = [[FFInitializer alloc]init];
    return _initializer;
}

-(void)setUp
{
    [FFSimpleAccountManager accountManager];
    [FFSimpleLoginManager loginManager];
    [FFSimpleNotificationManager notificationManager];
    [super setUp];
}

//-(void)testInitialize
//{
//    STAssertNotNil(self.initializer.accountManager, @"accountManager is not set");
//    STAssertNotNil(self.initializer.loginManager, @"loginManager is not set");
//    STAssertNotNil(self.initializer.notificationManager, @"notificationManager is not set");
//
//    [NSRunLoop currentRunLoop];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeTest:) name:@"initializeTest" object:self];
//    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:@"initializeTest" object:self]postingStyle:NSPostWhenIdle];
//    
//    while (!_isDone)
//    {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
//    }
//}

- (void) initializeTest:(NSNotification*)notification;
{
    [self.initializer initialize:^(void){
        _isDone = YES;
    }];        
}

@end
