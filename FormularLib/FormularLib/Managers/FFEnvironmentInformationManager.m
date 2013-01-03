//
//  FFEnvironmentInformationManager.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFEnvironmentInformationManager.h"
#import "Menu+CRUD.h"
#import "FFURLHelper.h"

@interface FFEnvironmentInformationManager()
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation FFEnvironmentInformationManager

@synthesize properties = _properties;
@synthesize accountManagerClassName;
@synthesize loginManagerClassName;
@synthesize notificationManagerClassName;
@synthesize domain;
@synthesize port;
@synthesize developmentMode;
@synthesize uiTheme;
@synthesize menuTheme;
@synthesize apiListUrl;

static FFEnvironmentInformationManager * _environmentInformationManager;
+(FFEnvironmentInformationManager *)environmentInformationManager
{
    @synchronized(self){
        if(!_environmentInformationManager)
            _environmentInformationManager = [[self alloc]init];
    }
    return _environmentInformationManager;
}

-(NSDictionary *)properties
{
    if(!_properties){
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"Formular.plist"];
        _properties = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    }
    return _properties;
}

-(NSString *)accountManagerClassName
{
    return [self.properties valueForKey:@"AccountManagerClassName"];
}

-(NSString *)loginManagerClassName
{
    return [self.properties valueForKey:@"LoginManagerClassName"];
}

-(NSString *)notificationManagerClassName
{
    return [self.properties valueForKey:@"NotificationManagerClassName"];
}

-(NSString *)domain
{
    NSDictionary *dicDomain = [self.properties valueForKey:@"Domain"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults valueForKey:@"executionMode"] isEqualToString:@"PRD"])
        return [dicDomain objectForKey:@"PRD"];
    else if([[userDefaults valueForKey:@"executionMode"] isEqualToString:@"QAS"])
        return [dicDomain objectForKey:@"QAS"];
    else
        return [dicDomain objectForKey:@"DEV"];
}

-(int)port
{
    NSDictionary *dicPort = [self.properties valueForKey:@"Port"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([[userDefaults valueForKey:@"executionMode"] isEqualToString:@"PRD"])
        return [[dicPort objectForKey:@"PRD"] intValue];
    else if([[userDefaults valueForKey:@"executionMode"] isEqualToString:@"QAS"])
        return [[dicPort objectForKey:@"QAS"] intValue];
    else
        return [[dicPort objectForKey:@"DEV"] intValue];
}

-(NSString *)backgroundColor
{
    return [self.properties valueForKey:@"BackgroundColor"];
}

-(NSString *)uiTheme
{
    return [self.properties valueForKey:@"UITheme"];
}

-(NSString *)menuTheme
{
    return [self.properties valueForKey:@"MenuTheme"];
}

- (bool)developmentMode
{
    return [self.properties valueForKey:@"DevelopmentMode"];
}

-(NSDictionary *)homeUrl
{
    NSDictionary *homePageInfo = [self.properties valueForKey:@"HomePage"];
    if(homePageInfo){
        
        FFViewType viewType;
        NSString *viewTypeString = [homePageInfo valueForKey:@"ViewType"];
        if([viewTypeString isEqualToString:@"local"])
            viewType = FFLocalWebPage;
        else if([viewTypeString isEqualToString:@"remote"])
            viewType = FFRemoteWebPage;
        else if([viewTypeString isEqualToString:@"native"])
            viewType = FFNativeView;
        
        NSString *name = [homePageInfo valueForKey:@"Name"] ? [homePageInfo valueForKey:@"Name"] : @"home";
        
        NSString *url = viewType == FFRemoteWebPage ? [FFURLHelper getFullUrl:[homePageInfo valueForKey:@"URL"]] : [homePageInfo valueForKey:@"URL"];
        
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:viewType], @"viewType", name, @"name", url, @"url", nil];
    }
    return nil;
}

-(NSString *)apiListUrl
{
    return [self.properties valueForKey:@"APIListUrl"];
}

@end
