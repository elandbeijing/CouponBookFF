//
//  FFSimpleLoginManager.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFSimpleLoginManager.h"

@implementation FFSimpleLoginManager

- (void)login:(void (^)())success failure:(void (^)(NSError *error))failure
{
    success();
}

@end
