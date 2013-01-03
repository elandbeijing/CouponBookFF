//
//  CBNotificationMessage.m
//  CB
//
//  Created by 장재휴 on 12. 11. 21..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "CBNotificationMessage.h"

@implementation CBNotificationMessage

@synthesize badge;
@synthesize msg;
@synthesize sound;

@synthesize foregroundAlertType;
@synthesize backgroundAlertType;
@synthesize backgroundActionType;
@synthesize menuReloadType;
@synthesize redirectId;

-(id)init
{
    if (self = [super init])
    {
        self.badge = [NSNumber numberWithInt:0];
        self.msg = @"";
        self.sound = @"";
        
        self.foregroundAlertType = CBNotificationAlertTypeNone;
        self.backgroundAlertType = CBNotificationAlertTypeNone;
        self.backgroundActionType = CBNotificationActionTypeNone;
        self.menuReloadType = CBNotificationMenuReloadTypeNone;
        self.redirectId = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self parseDictionary:dic];
    }
    return self;
    
}

- (void)parseDictionary:(NSDictionary *)dic
{
    self.badge = (NSNumber *)[[dic objectForKey:@"aps"] objectForKey:@"badge"];
    self.msg = [[dic objectForKey:@"aps"] objectForKey:@"alert"];
    self.sound = [[dic objectForKey:@"aps"] objectForKey:@"sound"];
    
    if([dic objectForKey:@"cf"]) {
        NSArray *configArray = [[dic objectForKey:@"cf"] componentsSeparatedByString:@"|"];
        self.foregroundAlertType = [[[configArray objectAtIndex:0] substringToIndex:1] intValue];
        self.backgroundAlertType = [[[[configArray objectAtIndex:0] substringToIndex:2] substringFromIndex:1] intValue];
        self.backgroundActionType = [[[[configArray objectAtIndex:0] substringToIndex:3] substringFromIndex:2] intValue];
        self.menuReloadType = [[[[configArray objectAtIndex:0] substringToIndex:4] substringFromIndex:3] intValue];
        self.redirectId = [configArray objectAtIndex:1];
    }
}

- (NSString *)toString
{
    return [NSString stringWithFormat:@"%d|%@|%@ %d|%d|%d|%d|%@",
            [self.badge intValue], self.msg, self.sound,
            self.foregroundAlertType, self.backgroundAlertType, self.backgroundActionType, self.menuReloadType, self.redirectId];
}

@end
