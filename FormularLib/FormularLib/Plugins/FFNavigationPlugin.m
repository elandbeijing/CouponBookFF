//
//  FFNavigationPlugin.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 4..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFNavigationPlugin.h"
#import "FFWebViewController.h"
#import "FFURLHelper.h"
#import "NSBundle+Extension.h"
#import "UIViewController+CurrentViewController.h"

@implementation FFNavigationPlugin

- (void) push:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    NSString *backButtonTitle = [params valueForKey:@"backTitle"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.title = [params valueForKey:@"title"];
    webViewController.urlString = [FFURLHelper getFullUrl:[params valueForKey:@"url"] withUrl:[NSURL URLWithString:((FFWebViewController*)[UIViewController currentViewController]).urlString]] ;
    webViewController.parent = (FFWebViewController*)[UIViewController currentViewController];
    if([backButtonTitle length] > 0)
//        webViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[params valueForKey:@"backTitle"] style:UIBarButtonItemStylePlain target:nil action:nil];
       [[[UIViewController currentViewController] navigationItem] setBackBarButtonItem: [[UIBarButtonItem alloc] initWithTitle:[params valueForKey:@"backTitle"] style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    [[UIViewController currentViewController].navigationController pushViewController:webViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];    
}

- (void) customPush:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    UIViewController *customViewController = [[NSClassFromString([params valueForKey:@"className"]) alloc]initWithNibName:[params valueForKey:@"className"] bundle:[NSBundle mainBundle]];
//    if([customViewController respondsToSelector:@selector(setParameters:)])
//        [customViewController performSelector:@selector(setParameters:) withObject:[params valueForKey:@"params"]];
    
    [[UIViewController currentViewController].navigationController pushViewController:customViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) customPresentModal:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    UIViewController *customViewController = [[NSClassFromString([params valueForKey:@"className"]) alloc]initWithNibName:[params valueForKey:@"className"] bundle:[NSBundle mainBundle]];
    if([customViewController respondsToSelector:@selector(setParameters:)])
        [customViewController performSelector:@selector(setParameters:) withObject:[params valueForKey:@"params"]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customViewController];    
    
    UIBarButtonItem *navigationButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"close", nil)
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(dismissModal)];
    [customViewController.navigationItem setLeftBarButtonItem:navigationButton];
    
    [[UIViewController currentViewController].navigationController presentViewController:navigationController animated:YES completion:Nil];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}


- (void) presentModal:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.title = [params valueForKey:@"title"];
    webViewController.urlString = [FFURLHelper getFullUrl:[params valueForKey:@"url"] withUrl:[NSURL URLWithString:((FFWebViewController*)[UIViewController currentViewController]).urlString]];
    webViewController.parent = (FFWebViewController*)[UIViewController currentViewController];
    webViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    webViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    
    UIBarButtonItem *navigationButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"close", nil)
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(dismissModal)];
    [webViewController.navigationItem setLeftBarButtonItem:navigationButton];
    
    [[UIViewController currentViewController].navigationController presentViewController:navigationController animated:YES completion:Nil];
//    [[UIViewController currentViewController].navigationController presentModalViewController:webViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) pop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) popToRoot:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    [[UIViewController currentViewController].navigationController popToRootViewControllerAnimated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

-(void) popAndPush:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    NSString *backButtonTitle = [params valueForKey:@"backTitle"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.title = [params valueForKey:@"title"];
    webViewController.urlString = [FFURLHelper getFullUrl:[params valueForKey:@"url"] withUrl:[NSURL URLWithString:((FFWebViewController*)[UIViewController currentViewController]).urlString]];

    UINavigationController *tempNavigationController = [[UIViewController currentViewController] navigationController];
    [[FFWebViewController currentViewController].navigationController popViewControllerAnimated:NO];
    
    if(backButtonTitle)
        [[tempNavigationController navigationItem] setBackBarButtonItem:backButton];
    [tempNavigationController pushViewController:webViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];

}

- (void)dismissModal
{
    if([UIViewController currentViewController].navigationController) {
        [[UIViewController currentViewController].navigationController dismissViewControllerAnimated:YES completion:Nil];
    }
    else {
        [[UIViewController currentViewController] dismissViewControllerAnimated:YES completion:Nil];
    }
}

- (void)dismissModal:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
//    NSError *error;
//    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    if(![[UIViewController currentViewController].navigationController isMemberOfClass:NSClassFromString(@"FFRootNavigationController")])
    {
        [[UIViewController currentViewController] dismissViewControllerAnimated:YES completion:Nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"dissmissModal Error" message:@"This navigationcontroller is root" delegate:Nil cancelButtonTitle:@"Got it!!!" otherButtonTitles:Nil, nil];
        [alertView show];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void)dismissModalAndPush:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.title = [params valueForKey:@"title"];
    webViewController.urlString = [FFURLHelper getFullUrl:[params valueForKey:@"url"] withUrl:[NSURL URLWithString:((FFWebViewController*)[UIViewController currentViewController]).urlString]];
    
    if(![[UIViewController currentViewController].navigationController isMemberOfClass:NSClassFromString(@"FFRootNavigationController")])
    {
        [[UIViewController currentViewController].navigationController dismissViewControllerAnimated:NO completion:Nil];
        [[UIViewController currentViewController].navigationController pushViewController:webViewController animated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"dissmissModal Error" message:@"This navigationcontroller is root" delegate:Nil cancelButtonTitle:@"Got it!!!" otherButtonTitles:Nil, nil];
        [alertView show];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

-(void) popToRootAndPush:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.title = [params valueForKey:@"title"];
    webViewController.urlString = [FFURLHelper getFullUrl:[params valueForKey:@"url"] withUrl:[NSURL URLWithString:((FFWebViewController*)[UIViewController currentViewController]).urlString]];
    
    UINavigationController *tempNavigationController = [[UIViewController currentViewController] navigationController];
    
    
    [[UIViewController currentViewController].navigationController popToRootViewControllerAnimated:NO];
    [tempNavigationController pushViewController:webViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
    
}



@end
