//
//  FFMacAddressPlugin.m
//  FormularLib
//
//  Created by ElandApple01 on 1/8/13.
//  Copyright (c) 2013 Ïû•Ïû¨Ìú¥. All rights reserved.
//

#import "FFMacAddressPlugin.h"
#import "CBNetworkHelper.h"
#import "FFWebViewController.h"
#import "UIViewController+CurrentViewController.h"

@implementation FFMacAddressPlugin

- (void) getMacAddress:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *script = [params valueForKey:@"script"];
    
        [(FFWebViewController*)[UIViewController currentViewController] evalScript:[NSString stringWithFormat:@"%@('%@');", script,[CBNetworkHelper macAddress]] async:NO];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

@end
