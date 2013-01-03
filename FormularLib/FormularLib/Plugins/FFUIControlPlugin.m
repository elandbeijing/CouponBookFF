//
//  FFUIControlPlugin.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 4..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFUIControlPlugin.h"
#import "FFWebViewController.h"
#import "SVProgressHUD.h"
#import "iToast.h"
#import "FFEnvironmentInformationManager.h"
#import "FFDateHelper.h"
#import "FFRootNavigationController.h"
#import "UIViewController+CurrentViewController.h"

@interface FFUIControlPlugin()
@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@end

@implementation FFUIControlPlugin
@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize dateActionSheet = _dateActionSheet;
@synthesize datePicker = _datePicker;

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

- (void) setNavigationRightButton:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];    
    NSString *title = [params valueForKey:@"title"];
    NSString *script = [params valueForKey:@"script"];
    
    NSString *icon = [params valueForKey:@"icon"];
        
    FFWebViewController *currentViewController = [UIViewController currentViewController];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    [rightButton setStyle:UIBarButtonItemStyleBordered];
    [rightButton setTarget:currentViewController];
    [rightButton setAction:@selector(evalScript:)];
    [rightButton setTag:CB_UI_CONTROL_RIGHT_BUTTON_TAG];
    
    if(icon != [NSNull null]) {
        if([icon hasPrefix:@"http://"]) {
            [self performSelector:@selector(getWebImageWithArray:) withObject:[NSArray arrayWithObjects:rightButton, icon, nil] afterDelay:0.1];
            [rightButton setTitle:@""];
        } else {
            UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icons.bundle/%@", icon]];
            [rightButton setImage:iconImage];
        }
        
    } else {
        [rightButton setTitle:title];
    }
    
    currentViewController.navigationItem.rightBarButtonItem = rightButton;
    [currentViewController.scripts setObject:script forKey:[NSString stringWithFormat:@"%d", rightButton.tag]];

    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) setNavigationRightButtons:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *items = [params valueForKey:@"items"];
    
    if ([items isEqual:[NSNull null]]) {
        [[UIViewController currentViewController].navigationItem setRightBarButtonItem:nil];
    }
    else{
        if ([items count] == 1){ // 버튼이 하나일때
            [self setNavigationRightButton:arguments withDict:options];
        }
        
        int maxItemWidth = 0;
        UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] init];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl setMomentary:YES];
        [segmentedControl setTag:CB_UI_CONTROL_RIGHT_SEGMENTEDCONTROL_TAG];
        for (int i = 0; i < [items count]; i++) {
            if ([[items objectAtIndex:i] objectForKey:@"icon"]) {
                if([[[items objectAtIndex:i] objectForKey:@"icon"] hasPrefix:@"http://"]) {
                    [self performSelector:@selector(getWebImageWithArray:) withObject:[NSArray arrayWithObjects:segmentedControl, [[items objectAtIndex:i] objectForKey:@"icon"], [NSNumber numberWithInt:i], nil] afterDelay:0.1];
                } else {
                    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icons.bundle/%@", [[items objectAtIndex:i] objectForKey:@"icon"]]];
                    [segmentedControl insertSegmentWithImage:iconImage atIndex:i animated:NO];
                }
                if(maxItemWidth < 45) {
                    maxItemWidth = 45;
                }
            } else {
                [segmentedControl insertSegmentWithTitle:[[items objectAtIndex:i] objectForKey:@"title"] atIndex:i animated:NO];
                
                CGSize stringSize = [[[items objectAtIndex:i] objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:12]];
                if(maxItemWidth < stringSize.width) {
                    maxItemWidth = stringSize.width + 15;
                }
            }
            [((FFWebViewController*)[UIViewController currentViewController]).scripts setObject:[[items objectAtIndex:i] objectForKey:@"script"]
                                                                    forKey:[NSString stringWithFormat:@"%d", CB_UI_CONTROL_RIGHT_SEGMENTEDCONTROL_TAG + i]];
        }
        
        [segmentedControl setFrame:CGRectMake(7, 7, maxItemWidth*[items count], 30)];
        
        UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [[[UIViewController currentViewController] navigationItem] setRightBarButtonItem:segmentBarItem];

    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) setNavigationLeftButton:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *title = [params valueForKey:@"title"];
    NSString *script = [params valueForKey:@"script"];
    
    if (!title || title == [NSNull null]) {
        [UIViewController currentViewController].navigationItem.leftBarButtonItem = nil;
    } else {
        FFWebViewController *currentViewController = (FFWebViewController*)[UIViewController currentViewController];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] init];
        [leftButton setStyle:UIBarButtonItemStyleBordered];
        [leftButton setTarget:currentViewController];
        [leftButton setAction:@selector(evalScript:)];
        [leftButton setTag:CB_UI_CONTROL_LEFT_BUTTON_TAG];
        [leftButton setTitle:title];
        currentViewController.navigationItem.leftBarButtonItem = leftButton;
        [currentViewController.scripts setObject:script forKey:[NSString stringWithFormat:@"%d", leftButton.tag]];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) setTopSegmentedControl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *items = [params valueForKey:@"items"];
    int index = [[params valueForKey:@"initIndex"] intValue];
    
    if ([items isEqual:[NSNull null]]) {
        [(FFWebViewController*)[UIViewController currentViewController] hideToolbar:CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TOOLBAR_TAG];
    }
    else{
        [((FFWebViewController*)[UIViewController currentViewController]).topToolbar setTag:CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TOOLBAR_TAG];
        UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(7, 7, 306, 30)];
        [segmentedControl setTag:CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TAG];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        for (int i = 0; i < [items count]; i++) {
            if ([[items objectAtIndex:i] objectForKey:@"icon"]) {
                if([[[items objectAtIndex:i] objectForKey:@"icon"] hasPrefix:@"http://"]) {
                    [self performSelector:@selector(getWebImageWithArray:) withObject:[NSArray arrayWithObjects:segmentedControl, [[items objectAtIndex:i] objectForKey:@"icon"], [NSNumber numberWithInt:i], nil] afterDelay:0.1];
                }
                else {
                    UIImage *iconImage = [UIImage imageNamed:[[items objectAtIndex:i] objectForKey:@"icon"]];
                    [segmentedControl insertSegmentWithImage:iconImage atIndex:i animated:NO];
                }
                
            }
            else {
                [segmentedControl insertSegmentWithTitle:[[items objectAtIndex:i] objectForKey:@"title"] atIndex:i animated:NO];
            }
            [((FFWebViewController*)[UIViewController currentViewController]).scripts setObject:[[items objectAtIndex:i] objectForKey:@"script"]
                                                                    forKey:[NSString stringWithFormat:@"%d", CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TAG + i]];
        }
        
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (index) {
            if (index != -1) {
                NSDictionary *segmentControlDict = [[NSDictionary alloc] initWithObjectsAndKeys:segmentedControl, @"segmentedControl", [NSNumber numberWithInt:index], @"index", nil];
                [self performSelector:@selector(segmentedControlSetIndex:) withObject:segmentControlDict afterDelay:0.01f];
            } else {
                [segmentedControl setMomentary:YES];
            }
        }
        else {
            [segmentedControl setSelectedSegmentIndex:0];
        }
        [((FFWebViewController*)[UIViewController currentViewController]).topToolbar addSubview:segmentedControl];
        
        [(FFWebViewController*)[UIViewController currentViewController] showTopToolbar];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}


- (void) setBottomSegmentedControl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *items = [params valueForKey:@"items"];
    int index = [[params valueForKey:@"initIndex"] intValue];
    
    if ([items isEqual:[NSNull null]]) {
        [(FFWebViewController*)[UIViewController currentViewController] hideToolbar:CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TOOLBAR_TAG];
    }
    else{
        [((FFWebViewController*)[UIViewController currentViewController]).bottomToolbar setTag:CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TOOLBAR_TAG];
        UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(7, 7, 306, 30)];
        [segmentedControl setTag:CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TAG];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        for (int i = 0; i < [items count]; i++) {
            if ([[items objectAtIndex:i] objectForKey:@"icon"]) {
                if([[[items objectAtIndex:i] objectForKey:@"icon"] hasPrefix:@"http://"]) {
                    [self performSelector:@selector(getWebImageWithArray:) withObject:[NSArray arrayWithObjects:segmentedControl, [[items objectAtIndex:i] objectForKey:@"icon"], [NSNumber numberWithInt:i], nil] afterDelay:0.1];
                }
                else {
                    UIImage *iconImage = [UIImage imageNamed:[[items objectAtIndex:i] objectForKey:@"icon"]];
                    [segmentedControl insertSegmentWithImage:iconImage atIndex:i animated:NO];
                }
                
            }
            else {
                [segmentedControl insertSegmentWithTitle:[[items objectAtIndex:i] objectForKey:@"title"] atIndex:i animated:NO];
            }
            [((FFWebViewController*)[UIViewController currentViewController]).scripts setObject:[[items objectAtIndex:i] objectForKey:@"script"]
                                                                    forKey:[NSString stringWithFormat:@"%d", CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TAG + i]];
        }
        
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (index) {
            if (index != -1) {
                NSDictionary *segmentControlDict = [[NSDictionary alloc] initWithObjectsAndKeys:segmentedControl, @"segmentedControl", [NSNumber numberWithInt:index], @"index", nil];
                [self performSelector:@selector(segmentedControlSetIndex:) withObject:segmentControlDict afterDelay:0.01f];
            } else {
                [segmentedControl setMomentary:YES];
            }
        }
        else {
            [segmentedControl setSelectedSegmentIndex:0];
        }
        [((FFWebViewController*)[UIViewController currentViewController]).bottomToolbar addSubview:segmentedControl];
        
        [(FFWebViewController*)[UIViewController currentViewController] showBottomToolbar];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) setToolbar:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *items = [params valueForKey:@"items"];
    
    [((FFWebViewController*)[UIViewController currentViewController]).bottomToolbar setTag:CB_UI_CONTROL_TOOLBAR_TAG];
    NSMutableArray *toolbarButtons = [[NSMutableArray alloc] init];
    
    if ([items isEqual:[NSNull null]])
        [(FFWebViewController*)[UIViewController currentViewController] hideToolbar:CB_UI_CONTROL_TOOLBAR_TAG];
    else {
        for (int i = 0; i < [items count]; i++) {
            UIBarButtonItem *tempBarButton;
            if ([[items objectAtIndex:i] objectForKey:@"icon"]) {
                tempBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icons.bundle/%@", [[items objectAtIndex:i] objectForKey:@"icon"]]]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:[FFWebViewController currentViewController]
                                                                action:@selector(evalScript:)];
            } else if (![[[items objectAtIndex:i] objectForKey:@"title"] isEqualToString:@"|"]) {
                tempBarButton = [[UIBarButtonItem alloc] initWithTitle:[[items objectAtIndex:i] objectForKey:@"title"]
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:[FFWebViewController currentViewController]
                                                                action:@selector(evalScript:)];
            } else {
                tempBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            }
            [tempBarButton setTag:CB_UI_CONTROL_TOOLBAR_ITEM_TAG + i];
            if ([[items objectAtIndex:i] objectForKey:@"script"] != nil) {
                [((FFWebViewController*)[UIViewController currentViewController]).scripts setObject:[[items objectAtIndex:i] objectForKey:@"script"] forKey:[NSString stringWithFormat:@"%d", tempBarButton.tag]];
            }
            [toolbarButtons addObject:tempBarButton];
        }
        [((FFWebViewController*)[UIViewController currentViewController]).bottomToolbar setItems:toolbarButtons animated:NO];
        [(FFWebViewController*)[UIViewController currentViewController] showBottomToolbar];
    }
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) setNavigationTitle:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    NSError *error;
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
   
    NSString *title = [params valueForKey:@"title"];
    [UIViewController currentViewController].navigationItem.title = title;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) showProgressHUD:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) dismissProgressHUD:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    id params = Nil;
    
    NSError *error;
    
    if([arguments objectAtIndex:1] != [NSNull null]){
        params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
//        dicParams = [params valueForKey:@"params"];
    }
    
    NSString *type = [params valueForKey:@"type"];
    NSString *msg = [params valueForKey:@"msg"];
    
    if([type isEqualToString:@"success"]) {
        [SVProgressHUD dismissWithSuccess:msg afterDelay:1];
    } else if([type isEqualToString:@"error"]) {
        [SVProgressHUD dismissWithError:msg afterDelay:1];
    } else {
        [SVProgressHUD dismiss];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) showToast:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    id params = Nil;
    
    NSError *error;
    
    if([arguments objectAtIndex:1] != [NSNull null]){
        params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    }
    
    NSString *msg = [params valueForKey:@"msg"];
    NSString *gravity = [params valueForKey:@"gravity"];
    
    if([gravity isEqualToString:@"top"]) {
        [[[iToast makeText:msg] setGravity:iToastGravityTop] show];
    } else if([gravity isEqualToString:@"center"]) {
        [[[iToast makeText:msg] setGravity:iToastGravityCenter] show];
    } else {
        [[[iToast makeText:msg] setGravity:iToastGravityBottom] show];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) showActionSheet:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *items = [params valueForKey:@"items"];
    
    int scriptIdx = CB_UI_CONTROL_ACTION_SHEET_IDX;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for( NSDictionary *item in items) {
        [actionSheet addButtonWithTitle:[item objectForKey:@"title"]];
        [((FFWebViewController*)[UIViewController currentViewController]).scripts setObject:[item objectForKey:@"script"] forKey:[NSString stringWithFormat:@"%d", scriptIdx++]];
    }
    if([((FFWebViewController*)[UIViewController currentViewController]).scripts objectForKey:[NSString stringWithFormat:@"%d", scriptIdx]] != nil) {
        [((FFWebViewController*)[UIViewController currentViewController]).scripts removeObjectForKey:[NSString stringWithFormat:@"%d", scriptIdx]];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = [items count];

    [actionSheet showInView:[UIViewController currentViewController].view];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) setOrientation:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSString *orientation = [params valueForKey:@"orientation"];
    
    [[NSUserDefaults standardUserDefaults] setValue:orientation forKey:@"deviceOrientation"];
    
    [(FFWebViewController*)[UIViewController currentViewController] setDeviceOrientation:orientation];
    FFRootNavigationController *navigationController = (FFRootNavigationController *)[[UIViewController currentViewController] navigationController];
    [navigationController setOrientation:orientation];
    
    [UIView animateWithDuration:0.3 animations:^{
        UIViewController *tempView = [[UIViewController alloc] init];
        [[UIViewController currentViewController] presentModalViewController:tempView animated:NO];
        [tempView dismissModalViewControllerAnimated:NO];
        [(FFWebViewController*)[UIViewController currentViewController] setDeviceOrientation:orientation];
    }];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) callDatePicker:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    NSError *error;
    
    id params = [NSJSONSerialization JSONObjectWithData:[[arguments objectAtIndex:1]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSString *mode = [params valueForKey:@"mode"];
    NSString *script = [params valueForKey:@"script"];
    NSString *defaultDate = [params valueForKey:@"defaultDate"];
    NSString *maximumDate = [params valueForKey:@"maximumDate"];
    NSString *minimumDate = [params valueForKey:@"minimumDate"];
    NSString *minuteInterval = [params valueForKey:@"minuteInterval"];
    
    self.dateActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    [self.dateActionSheet showInView:[UIViewController currentViewController].view];
    [self.dateActionSheet setBounds:CGRectMake(0, 0, 320, 500)];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    if(defaultDate && [defaultDate length] > 0) {
        self.datePicker.date = [FFDateHelper dateFromString:defaultDate];
    }
    if(maximumDate && [maximumDate length] > 0) {
        self.datePicker.maximumDate = [FFDateHelper dateFromString:maximumDate];
    }
    if(minimumDate && [minimumDate length] > 0) {
        self.datePicker.minimumDate = [FFDateHelper dateFromString:minimumDate];
    }
    if(minuteInterval) {
        self.datePicker.minuteInterval = [minuteInterval intValue];
    }
    
    if([mode isEqualToString:@"time"]) {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    } else if([mode isEqualToString:@"date"]) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    } else if([mode isEqualToString:@"datetime"]) {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    } else if([mode isEqualToString:@"countdown"]) {
        self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    
    UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    datePickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [datePickerToolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    [datePickerToolbar sizeToFit];
    
    // add button
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:btnFlexibleSpace];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doDatePickerCancelClick:)];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doDatePickerDoneClick:)];
    btnDone.tag = CB_UI_CONTROL_DATE_PICKER_TAG;
    [((FFWebViewController*)[UIViewController currentViewController]).scripts setObject:script forKey:[NSString stringWithFormat:@"%d", btnDone.tag]];
    
    if ([[UIBarButtonItem class] respondsToSelector:@selector(appearance)]) {
        [btnCancel setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [btnCancel setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [btnDone setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [btnDone setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    }
    
    [barItems addObject:btnCancel];
    [barItems addObject:btnDone];
    
    [datePickerToolbar setItems:barItems animated:YES];
    
    [self.dateActionSheet addSubview:datePickerToolbar];
    [self.dateActionSheet addSubview:self.datePicker];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
}

- (void) removeAllControl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    [(FFWebViewController*)[UIViewController currentViewController] hideToolbar:CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TOOLBAR_TAG];
    [(FFWebViewController*)[UIViewController currentViewController] hideToolbar:CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TOOLBAR_TAG];
    [UIViewController currentViewController].navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIViewController currentViewController] performSelector:@selector(evalScriptByIdx:) withObject:[NSNumber numberWithInt:CB_UI_CONTROL_ACTION_SHEET_IDX+buttonIndex] afterDelay:0.01];
}

#pragma mark - Helper Method

- (void)segmentedControlSetIndex:(id)sender
{
    NSDictionary *segmentedControl = (NSDictionary *)sender;
    [[segmentedControl objectForKey:@"segmentedControl"] setSelectedSegmentIndex:[[segmentedControl objectForKey:@"index"] intValue]];
}

- (void)segmentedControlValueChanged:(id)sender
{
    UISegmentedControl *temp = (UISegmentedControl *)sender;

    NSString *script = [((FFWebViewController*)[UIViewController currentViewController]).scripts objectForKey:[NSString stringWithFormat:@"%d", temp.selectedSegmentIndex+temp.tag]];
    [(FFWebViewController*)[UIViewController currentViewController] evalScript:script  async:NO];
}

- (void)getWebImageWithArray:(NSArray *)array
{
    NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[array objectAtIndex:1]]];
    UIImage *iconImage = [[UIImage alloc] initWithData:dataImage];
    iconImage = [UIImage imageWithCGImage:[iconImage CGImage] scale:2.0 orientation:UIImageOrientationUp];
    
    if ([[array objectAtIndex:0] isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *barbutton = [array objectAtIndex:0];
        [barbutton setImage:iconImage];
    } else if ([[array objectAtIndex:0] isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentedControl = [array objectAtIndex:0];
        [segmentedControl insertSegmentWithImage:iconImage atIndex:[[array objectAtIndex:2] intValue] animated:YES];
    }
}

- (void)doDatePickerCancelClick:(id)sender
{
    [self.dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)doDatePickerDoneClick:(id)sender
{
    UIView *obj = (UIView *)sender;
    
    [self.dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
	int year = [[dateFormatter stringFromDate:[self.datePicker date]] intValue];
    [dateFormatter setDateFormat:@"MM"];
	int month = [[dateFormatter stringFromDate:[self.datePicker date]] intValue];
    [dateFormatter setDateFormat:@"dd"];
	int day = [[dateFormatter stringFromDate:[self.datePicker date]] intValue];
    [dateFormatter setDateFormat:@"HH"];
	int hour = [[dateFormatter stringFromDate:[self.datePicker date]] intValue];
    [dateFormatter setDateFormat:@"mm"];
	int min = [[dateFormatter stringFromDate:[self.datePicker date]] intValue];
    
    [(FFWebViewController*)[UIViewController currentViewController] evalScript:[NSString stringWithFormat:@"%@(%d, %d, %d, %d, %d)",
                                                             [((FFWebViewController*)[UIViewController currentViewController]).scripts objectForKey:[NSString stringWithFormat:@"%d", obj.tag]], year, month, day, hour, min] async:NO];
}

@end
