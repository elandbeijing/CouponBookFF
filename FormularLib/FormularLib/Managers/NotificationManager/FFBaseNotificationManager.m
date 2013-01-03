//
//  FFBaseNotificationManager.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 15..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFBaseNotificationManager.h"

@implementation FFBaseNotificationManager
@synthesize userInfo = _userInfo;
@synthesize badgeCount = _badgeCount;
@synthesize isStartAppWithRemoteNotification = _isStartAppWithRemoteNotification;
@synthesize pushToken = _pushToken;
@synthesize userId = _userId;

static id<FFNotificationManagerProtocol> _notificationManager;
+(id<FFNotificationManagerProtocol>) notificationManager
{
    @synchronized(self){
        if(!_notificationManager)
            _notificationManager = [[self alloc]init];
    }
    return _notificationManager;
}

@end
