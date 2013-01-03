//
//  FFWebViewPlugin.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 13..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFWebViewPlugin.h"
#import "FFWebViewController.h"
#import "FFURLHelper.h"
#import "NSBundle+Extension.h"
#import "UIViewController+CurrentViewController.h"

@implementation FFWebViewPlugin

- (void) setRefreshAction:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    bool enable = [params valueForKey:@"enable"];
    
    if(enable)
        [(FFWebViewController*)[UIViewController currentViewController] showRefreshControl];
    else
        [(FFWebViewController*)[UIViewController currentViewController] hideRefreshControl];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) loadUrl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *url = [params valueForKey:@"url"];
    NSString *title = [params valueForKey:@"title"];
    NSString *method = [params valueForKey:@"method"];
    
    if (method == nil) {
        [(FFWebViewController*)[UIViewController currentViewController] loadUrl:[FFURLHelper getFullUrl:url withUrl:((FFWebViewController*)[UIViewController currentViewController]).webView.request.URL]];
    } else {
        [(FFWebViewController*)[UIViewController currentViewController] loadUrl:[FFURLHelper getFullUrl:url withUrl:((FFWebViewController*)[UIViewController currentViewController]).webView.request.URL] method:method];
    }
    if(title) {
        [[[UIViewController currentViewController] navigationItem] setTitle:title];
    }
        
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) loadUrlToParent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *url = [params valueForKey:@"url"];
    NSString *method = [params valueForKey:@"method"];
    
    if (method == nil) {
        [((FFWebViewController*)[UIViewController currentViewController]).parent loadUrl:[FFURLHelper getFullUrl:url withUrl:((FFWebViewController*)[UIViewController currentViewController]).webView.request.URL]];
    } else {
        [((FFWebViewController*)[UIViewController currentViewController]).parent loadUrl:[FFURLHelper getFullUrl:url withUrl:((FFWebViewController*)[UIViewController currentViewController]).webView.request.URL] method:method];
    }
    
    [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) reloadUrl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    [(FFWebViewController*)[UIViewController currentViewController] reloadUrl];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) reloadUrlToParent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    [((FFWebViewController*)[UIViewController currentViewController]).parent reloadUrl];
    [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) evalScript:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *script = [params valueForKey:@"script"];
    
    [(FFWebViewController*)[UIViewController currentViewController] evalScript:script async:NO];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) evalScriptToParent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *script = [params valueForKey:@"script"];
    
    BOOL isModalView = NO;
    if([[[[UIViewController currentViewController] navigationController] viewControllers] objectAtIndex:0] == [UIViewController currentViewController]) {
        isModalView = YES;
    }
    
    [((FFWebViewController*)[UIViewController currentViewController]).parent evalScript:script async:NO];
    
    if(isModalView) {
        [[UIViewController currentViewController] dismissModalViewControllerAnimated:YES];
    } else {
        [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) evalScriptToParentAndPush:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *script = [params valueForKey:@"script"];
    NSString *title = [params valueForKey:@"title"];
    NSString *url = [params valueForKey:@"url"];
    NSString *backTitle = [params valueForKey:@"backTitle"];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.title = title;
    webViewController.urlString = [FFURLHelper getFullUrl:url withUrl:[NSURL URLWithString:((FFWebViewController*)[UIViewController currentViewController]).urlString]];
    [webViewController setParent:((FFWebViewController*)[UIViewController currentViewController]).parent];
    
    UINavigationController *tempNavigationController = [[UIViewController currentViewController] navigationController];
    if (backTitle) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:backTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        [[[[[UIViewController currentViewController] navigationController] viewControllers] objectAtIndex:0] navigationItem].backBarButtonItem = backButton;
    } else {
        [[[[[UIViewController currentViewController] navigationController] viewControllers] objectAtIndex:0] navigationItem].backBarButtonItem = nil;
    }
    
    [((FFWebViewController*)[UIViewController currentViewController]).parent evalScript:script async:NO];
    [[UIViewController currentViewController].navigationController popViewControllerAnimated:NO];
    [tempNavigationController pushViewController:webViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];

}

- (void) ready:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    // todo something
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
    
}

- (void) log:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
}

- (void) loadUrlAsync:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
}

@end
