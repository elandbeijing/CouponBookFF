//
//  CBPropertyList.m
//  CB
//
//  Created by 장재휴 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "CBPropertyList.h"

@implementation CBPropertyList

+(NSDictionary *)properties;
{
    if(!_properties)
        _properties = [self loadProperties];
    return _properties;
}


static NSDictionary *_properties;
+(NSDictionary *)loadProperties
{
    @synchronized(self){
        if(!_properties){
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *finalPath = [path stringByAppendingPathComponent:@"CB.plist"];
            _properties = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        }
    }
    return _properties;
}

+(NSString *) getPropertyByExecutionMode:(NSString *)CBPlistKey{
    NSDictionary *properties = [CBPropertyList properties]; 
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicPlistValues = [properties valueForKey:CBPlistKey];
    
    if([[userDefaults valueForKey:@"executionMode"] isEqualToString:@"PRD"])
        return [dicPlistValues objectForKey:@"PRD"];
    else if([[userDefaults valueForKey:@"executionMode"] isEqualToString:@"QAS"])
        return [dicPlistValues objectForKey:@"QAS"];
    else
        return [dicPlistValues objectForKey:@"DEV"];
}

@end
