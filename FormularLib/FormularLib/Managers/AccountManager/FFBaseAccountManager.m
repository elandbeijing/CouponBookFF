//
//  FFBaseAccountManager.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 15..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFBaseAccountManager.h"

@implementation FFBaseAccountManager

static id<FFAccountManagerProtocol> _accountManager;
+(id<FFAccountManagerProtocol>) accountManager
{
    @synchronized(self){
        if(!_accountManager)
            _accountManager = [[self alloc]init];
    }
    return _accountManager;
}

-(void)setMenuInfo:(void (^)())success failure:(void (^)(NSError *))failure
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(NSOrderedSet *)menuSections
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

-(NSString *)name
{
    return NSLocalizedString(@"Guest", @"Guest");
}

-(UIImage *)profileImage
{
    return [UIImage imageNamed:@"icons.bundle/profile_icon"];
}

-(NSDictionary *)userInfo
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;    
}

-(NSString *)email
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;    
}

@end
