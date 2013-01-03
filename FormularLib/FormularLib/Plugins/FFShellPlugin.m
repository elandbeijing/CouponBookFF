//
//  FFShellPlugin.m
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFShellPlugin.h"
#import "FFWebViewController.h"
#import "FFLocalizationHelper.h"
#import "FFURLHelper.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "NSBundle+Extension.h"
#import "UIViewController+CurrentViewController.h"

@implementation FFShellPlugin

@synthesize imageScript = _imageScript;
@synthesize photos = _photos;

-(NSMutableArray *)photos
{
    if(!_photos)
        _photos = [NSMutableArray array];
    return _photos;
}

-(NSString *)imageScript{
    if(!_imageScript)
        _imageScript = [NSString string];
    return _imageScript;
}


#pragma mark
- (id)init
{
    if (self = [super init]) {
        // photo
        self.photos = [[NSMutableArray alloc] init];
        self.imageScript = [[NSString alloc] init];
    }
    return self;
}

- (void) callApp:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *identifier = [params valueForKey:@"identifier"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:identifier]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:identifier]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:identifier]];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"This app is not installed"];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

- (void) checkAppInstall:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *identifier = [params valueForKey:@"identifier"];
    NSString *script = [params valueForKey:@"script"];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:identifier]]) {
        [(FFWebViewController*)[UIViewController currentViewController] evalScript:[NSString stringWithFormat:@"%@('Install');", script] async:NO];
    }
    else {
        [(FFWebViewController*)[UIViewController currentViewController] evalScript:[NSString stringWithFormat:@"%@('NotInstall');", script] async:NO];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) callWebView:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *url = [params valueForKey:@"url"];
    bool isDisableMenu = [params valueForKey:@"disableMenu"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[FFLocalizationHelper getAppleLocalizableLanguage:@"Back"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    FFWebViewController *webViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [[[UIViewController currentViewController] navigationItem] setBackBarButtonItem:backButton];
    webViewController.urlString = [FFURLHelper getFullUrl:url withUrl:[NSURL URLWithString:webViewController.urlString]] ;
    
    [[UIViewController currentViewController].navigationController pushViewController:webViewController animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) callImageViewer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *items = [params valueForKey:@"items"];
    NSString *initIndex = [params valueForKey:@"initIndex"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[FFLocalizationHelper getAppleLocalizableLanguage:@"Back"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[[UIViewController currentViewController] navigationItem] setBackBarButtonItem:backButton];
    
    [self.photos removeAllObjects];
    MWPhoto *photo;
    
    for (int i=0; i<[items count]; i++) {
        NSString *url = [[items objectAtIndex:i] objectForKey:@"url"];
//        if(url == nil) {
//            return DispatchCallbackStatusParameterRequireException;
//        }
        
        if([url hasPrefix:@"data:image"]) { // base64 data
            NSData *decodedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            photo = [MWPhoto photoWithImage:[UIImage imageWithData:decodedData]];
        } else {
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[FFURLHelper getFullUrl:url
                                                                               withUrl:((FFWebViewController*)[UIViewController currentViewController]).webView.request.URL]]];
        }
        
        if ([[items objectAtIndex:i] objectForKey:@"title"] != [NSNull null] && ![[[items objectAtIndex:i] objectForKey:@"title"] isEqualToString:@""]) {
            photo.caption = [[items objectAtIndex:i] objectForKey:@"title"];
        }
        [self.photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.wantsFullScreenLayout = NO;
    if (initIndex == nil) {
        [browser setInitialPageIndex:0];
    } else {
        [browser setInitialPageIndex:[initIndex intValue]];
    }
    
    [[[UIViewController currentViewController] navigationController] pushViewController:browser animated:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) exit:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    id params = nil;
    int isForce;
    
    NSError *error;
    params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    isForce = [[params valueForKey:@"force"] integerValue];
    
    if(isForce == 1) {
        exit(1);
    } else {
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = [FFLocalizationHelper getAppleLocalizableLanguage:@"Cancel"];
        
        RIButtonItem *okItem = [RIButtonItem item];
        okItem.label = [FFLocalizationHelper getAppleLocalizableLanguage:@"OK"];
        okItem.action = ^
        {
            exit(1);
        };
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedStringFromTableInBundle(@"SHELL_EXIT_MESSAGE", nil, [NSBundle resourceBundle], nil)
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:okItem, nil];
        [alertView show];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

#pragma mark - action
- (void)dismissView:(id)sender
{
    [[UIViewController currentViewController] dismissModalViewControllerAnimated:YES];
}
@end
