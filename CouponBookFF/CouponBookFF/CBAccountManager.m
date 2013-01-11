//
//  CBAccountManager.m
//  CouponBookFF
//
//  Created by ElandApple02 on 13. 1. 3..
//  Copyright (c) 2013년 ElandApple02. All rights reserved.
//

#import "CBAccountManager.h"
#import "CBPropertyList.h"
#import "CBJSONResult.h"
#import <Cordova/JSONKit.h>
#import "CBLoginManager.h"


@interface CBAccountManager()
@property (nonatomic, readonly) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, readonly) CBLoginManager *loginManager;
@property (nonatomic, strong) NSString *currentMenuVersion;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@end

@implementation CBAccountManager

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize loginManager = _loginManager;
@synthesize menuSections = _menuSections;
@synthesize currentMenuVersion = _currentMenuVersion;
@synthesize email = _email;
@synthesize name = _name;

#pragma mark - Setter/Getter Method

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(CBLoginManager*)loginManager
{
    if(!_loginManager)
        _loginManager = [NSClassFromString(self.environmentInformationManager.loginManagerClassName) loginManager];
    return _loginManager;
}

-(void)setMenuSections:(NSOrderedSet *)menuSections
{
    if(_menuSections != menuSections)
        _menuSections = menuSections;
}

-(NSString *)currentMenuVersion
{
    return @"0"; // 무조건 메뉴 정보를 갱신하도록 하드코딩 함. 제거해야 함
    if(!_currentMenuVersion){
        _currentMenuVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"CB_CURRENT_MENU_VERSION"];
    }
    return _currentMenuVersion;
}

-(void)setCurrentMenuVersion:(NSString *)currentMenuVersion
{
    if(_currentMenuVersion != currentMenuVersion){
        [[NSUserDefaults standardUserDefaults]setValue:currentMenuVersion forKey:@"CB_CURRENT_MENU_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _currentMenuVersion = currentMenuVersion;
    }
}

-(void)setName:(NSString *)name
{
    if(_name != name){
        [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"CB_USER_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _name = name;
    }
}

-(void)setEmail:(NSString *)email
{
    if(_email != email){
        [[NSUserDefaults standardUserDefaults]setValue:email forKey:@"CB_USER_EMAIL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _email = email;
    }
}

#pragma mark - FFAccountManagerProtocol method

-(void)setMenuInfo:(void (^)())success failure:(void (^)(NSError *))failure
{
    [self initializeAccountInfo:success failure:failure];
}

#pragma mark - private method

-(void)initializeAccountInfo:(void (^)())success failure:(void (^)(NSError *error))failure
{
   // NSDictionary *properties = [CBPropertyList properties];//com.eland.esns
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[properties valueForKey:@"AppId"],@"appId",
//                           self.loginManager.loginId, @"loginID",
//                           self.currentMenuVersion, @"currentMenuVersion",
//                           [[NSLocale preferredLanguages] objectAtIndex:0], @"locale",
//                           nil];
    
   // NSDictionary *properties = [CBPropertyList properties];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.loginManager.loginId,  @"userID",
                           nil];
    //AccountInfoRequestUrl
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[FFURLHelper getFullUrl:[CBPropertyList getPropertyByExecutionMode:ACCOUNT_REQUEST_URL]
                                                                                                          withParam:param]]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             CBJSONResult *jsonResult = [[CBJSONResult alloc]initWithJSON:JSON];
                                             if([jsonResult.result isEqualToString:@"failure"]){
                                                 NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                                 [details setValue:jsonResult.msg
                                                            forKey:NSLocalizedDescriptionKey];
                                                 NSError *error = [NSError errorWithDomain:@"JSONRequestOperationWithRequest"
                                                                                      code:CBRequestResultCodeCustomError
                                                                                  userInfo:details];
                                                 failure(error);
                                             } else {
                                                 self.name = [jsonResult.data valueForKeyPath:@"AccountInfo.Name"];
                                                 self.email = [jsonResult.data valueForKeyPath:@"AccountInfo.Email"];
                                                 NSString *menuVersion = [[jsonResult.data objectForKey:@"MenuInfo"] objectForKey:@"MenuVersion"];
                                                 if([self.currentMenuVersion isEqualToString:menuVersion]){
                                                     success();
                                                 } else {
                                                     self.currentMenuVersion = menuVersion;
                                                     [self saveAccountInfo:jsonResult.data success:success];
                                                 }
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             NSLog(@"<<ERRROR>> \nCurrentAction:%@ \nErrorInfo:%@ \nJSON:%@",@"initializeAccountInfo", error, JSON);
                                         }];
    [operation start];
}

-(void)saveAccountInfo:(id)JSON success:(void (^)())success
{
    [FFCoreDataHelper openDocument:USER_PROFILE_DOCUMENT usingBlock:^(NSManagedObjectContext *context){
        
        // delete all menus
        NSArray *sections = [Section sectionsInManagedObjectContext:context];
        for(Section *section in sections)
            [Section deleteSection:section inManagedObjectContext:context];
                NSString *loginId=self.loginManager.loginId;
        if([loginId isEqualToString: @"manager"]||[loginId isEqualToString: @"admin"]||[loginId isEqualToString: @"userId"])
        {
        // save new menus
        NSArray *menuInfos = [[JSON objectForKey:@"MenuInfo"] objectForKey:@"Menus"];
        
        for (id menuInfo in menuInfos) {
            
            id sectionInfo = [menuInfo objectForKey:@"Section"];
            Section *section = [Section sectionWithCode:[sectionInfo valueForKey:@"DisplaySeq"] inManagedObjectContext:context];
            section.name = [sectionInfo valueForKey:@"Name"];
            
            id menuInfos = [menuInfo objectForKey:@"Menu"];
            for (id menuInfo in menuInfos) {
                Menu *menu = [Menu menuWithCode:[[menuInfo valueForKey:@"DisplaySeq"] description] inManagedObjectContext:context];
                menu.name = [menuInfo valueForKey:@"Name"];
                menu.icon = [menuInfo valueForKey:@"Icon"];
                menu.type = [[menuInfo valueForKey:@"MenuType"]intValue] == 1 ? MENUTYPE_NODE : MENUTYPE_FOLDER;
                menu.url = [FFURLHelper getFullUrl:[menuInfo valueForKey:@"ViewUrl"]];
                menu.badge = [[menuInfo valueForKey:@"count"] description];
               // menu.viewType = [NSNumber numberWithInt:0];

                menu.section = [Section sectionWithCode:[[menuInfo valueForKey:@"ParentSeq"] description] inManagedObjectContext:context];
            }
            
            
        }


        }
        //guest  add section with 2 menu    add by xiaoxinmiao
        NSString *sectionCount=[NSString stringWithFormat:@"%d", sections.count+1];
        Section *section = [Section sectionWithCode:sectionCount inManagedObjectContext:context];
        section.name = @"User Register";
        
        Menu *menu = [Menu menuWithCode:sectionCount inManagedObjectContext:context];
        menu.name = @"Register";;
        menu.viewType = [NSNumber numberWithInt:FFNativeView];
        menu.section = [Section sectionWithCode:sectionCount inManagedObjectContext:context];
        
        NSString *msg=self.loginManager.msg;
        if([msg isEqualToString:@"unregister" ])
        {
            menu.url = @"CBRegisterViewController";
        }
        else
        {
            menu.url = @"CBDeviceRegViewController";
        }
//        else if([loginId isEqualToString: @"guest"])
//        {
//
//
//
//        }
        


        


        [self setMenuSections:[NSOrderedSet orderedSetWithArray:[Section sectionsInManagedObjectContext:context]]];
        success();
    }];
}





-(NSString *)getURL:(NSString *)urlString
{
    NSDictionary *params;
    NSRange paramRange = [urlString rangeOfString:@"?param"];
    if(paramRange.length > 0) {
        NSString *parameterString = [[[urlString substringFromIndex:paramRange.location + 7] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *parameterData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *jsonError = nil;
        
        if ([NSJSONSerialization class]) {
            params = [NSJSONSerialization JSONObjectWithData:parameterData options:0 error:&jsonError];
        } else {
            params = [[CDVJSONDecoder decoder] objectWithData:parameterData error:&jsonError];
        }
    }
    return [params valueForKey:@"url"];
}

@end
