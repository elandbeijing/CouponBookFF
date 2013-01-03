//
//  FFNotificationManagerProtocol.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFNotificationManagerProtocol <NSObject>

@required
+(id<FFNotificationManagerProtocol>) notificationManager;
@property (nonatomic, strong) NSDictionary *userInfo; // remote notification message
@property (nonatomic, readonly) BOOL useNotificationView;
@property (nonatomic, strong) NSString *pushToken;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic) NSInteger badgeCount;
@property (nonatomic) BOOL isStartAppWithRemoteNotification;

-(void)receiveRemoteNotification:(UIApplicationState)state;
-(void)showNotificationView;

@end
