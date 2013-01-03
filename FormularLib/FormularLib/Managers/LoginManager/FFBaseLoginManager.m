//
//  FFBaseLoginManager.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 15..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFBaseLoginManager.h"

@implementation FFBaseLoginManager

static id<FFLoginManagerProtocol> _loginManager;
+(id<FFLoginManagerProtocol>)loginManager
{
    @synchronized(self){
        if(!_loginManager)
            _loginManager = [[self alloc]init];
    }
    return _loginManager;
}

-(NSString *)loginId
{
    return NSLocalizedString(@"Guest", @"Guest");
}

- (void)firstLogin:(void (^)())success failure:(void (^)(NSError *error))failure
{
    [self login:success failure:failure];
}

-(void)login:(void (^)())success failure:(void (^)(NSError *))failure
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
