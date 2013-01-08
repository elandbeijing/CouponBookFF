//
//  CBLoginManager.m
//  CouponBookFF
//
//  Created by ElandApple02 on 13. 1. 3..
//  Copyright (c) 2013년 ElandApple02. All rights reserved.
//

#import "CBLoginManager.h"
#import "CBPropertyList.h"
#import "CBJSONResult.h"
#import "CBNetworkHelper.h"



@interface CBLoginManager ()
@property (nonatomic, readonly) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, readonly) id<FFNotificationManagerProtocol> notificationManager;

@end

@implementation CBLoginManager


@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize notificationManager = _notificationManager;
@synthesize loginId = _loginId;
@synthesize msg=_msg;

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(id<FFNotificationManagerProtocol>)notificationManager
{
    if(!_notificationManager)
        _notificationManager = [NSClassFromString(self.environmentInformationManager.notificationManagerClassName) notificationManager];
    return _notificationManager;
}

-(NSString *)loginId
{
    return _loginId;
}

-(void)setLoginId:(NSString *)loginId
{
    _loginId = loginId;
}



-(void)login:(void (^)())success failure:(void (^)(NSError *))failure
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[FFURLHelper getFullUrl:[[CBPropertyList properties]valueForKey:LOGIN_URL]]]];
    [request setHTTPMethod:@"POST"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
   NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[CBNetworkHelper macAddress], @"deviceId",
                          nil];
//       NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"C:AA:21:CD:B0:13", @"deviceId",
//                          nil];
    [request setHTTPBody:[[param urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        
        if([response statusCode] == 200) {
            CBJSONResult *json = [[CBJSONResult alloc] initWithJSON:JSON];
            if([json.result isEqualToString:@"success"]) {
                self.loginId = [json.data valueForKey:@"loginId"];
                self.notificationManager.userId = [json.data valueForKey:@"loginId"];
                self.msg=json.msg;
                success();
            } else if([json.result isEqualToString:@"failure"]) {
                [details setValue:json.msg
                           forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                     code:CBRequestResultCodeCustomError
                                                 userInfo:details];
                failure(error);
            } else {
                [details setValue:@"json format exception"
                           forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                     code:CBRequestResultCodeJsonError
                                                 userInfo:details];
                failure(error);
            }
            
        } else {
            [details setValue:[JSON objectForKey:@"data"] forKey:@"data"];
            [details setValue:[NSString stringWithFormat:@"%d %@", [response statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]]
                       forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                 code:CBRequestResultCodeServerError
                                             userInfo:details];
            failure(error);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[error.userInfo valueForKey:NSLocalizedDescriptionKey]
                   forKey:NSLocalizedDescriptionKey];
        failure(error);
    }];
    [operation start];

}


@end
