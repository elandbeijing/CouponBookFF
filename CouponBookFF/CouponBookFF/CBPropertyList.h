//
//  CBPropertyList.h
//  CB
//
//  Created by 장재휴 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APPID @"AppId"
#define ACCOUNT_REQUEST_URL @"AccountInfoRequestUrl"
#define LOGIN_URL @"LoginUrl"
#define NOTIFICATION_INFO_URL @"NotificationInfoUrl"
#define SET_NOTIFICATION_INFO_URL @"SetNotificationInfoUrl"
#define NOTIFICATION_REDIRECT_URL @"NotificationRedirectUrl"
#define USE_NOTIFICATION_VIEW @"UseNotificationView"

@interface CBPropertyList : NSObject
+(NSDictionary *)properties;
+(NSString *) getPropertyByExecutionMode:(NSString *)CBPlistKey;
@end
