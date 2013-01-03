//
//  FFAppDelegate.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFEnvironmentInformationManager.h"
#import "FFNotificationManagerProtocol.h"
#import "NSBundle+Extension.h"

@interface FFAppDelegate()
@property (nonatomic, readonly) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, readonly) id<FFNotificationManagerProtocol> notificationManager;
@end
@implementation FFAppDelegate
@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize notificationManager = _notificationManager;

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // set webview UserAgent for .NET cookie check
    UIWebView *webview = [[UIWebView alloc] init];
    NSString *ua = [webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *uaString = [NSString stringWithFormat:@"%@ Version/5.1? Safari/?", ua];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:uaString, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    // init user default data
    [self initUserDefaultData];
    
    // ui custom
    [self customizeAppearance];
    
    // Register to receive notifications of the specified types from a provider via Apple Push Service.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    // set notification badge count
    self.notificationManager.badgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];

    // push 메시지를 통해 프로그램을 실행했을 경우: isStartWithRemoteNotification = YES
    if([[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] != nil){
        self.notificationManager.isStartAppWithRemoteNotification = YES;
        self.notificationManager.userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    } else {
        self.notificationManager.isStartAppWithRemoteNotification = NO;
    }
    
    // Load Initial ViewController
    NSBundle *bundle = [NSBundle resourceBundle];
    UIStoryboard *mainStroyBoard = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
    else
        mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
    
    UIViewController *viewController = [mainStroyBoard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.notificationManager.pushToken = token;
}

// 앱을 이미 실행한 상태일 경우에만 수행
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // set notification badge count
    self.notificationManager.badgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    // call notification manager
    self.notificationManager.userInfo = userInfo;
    UIApplicationState state = ([application applicationState] == UIApplicationStateActive) ? UIApplicationStateActive : UIApplicationStateBackground;
    [self.notificationManager receiveRemoteNotification:state];
}

- (UIImage *)makeLandscapeImage:(UIImage *)sourceImage
{
    CGSize size = sourceImage.size;
    CGFloat scale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width * scale * 0.82, size.height * scale * 0.82));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height * scale * 0.82);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width * scale * 0.82 + 1, size.height * scale * 0.82), [sourceImage CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    scaledImage = [UIImage imageWithCGImage:[scaledImage CGImage] scale:scale orientation:scaledImage.imageOrientation];
    
    return scaledImage;
}

- (void)customizeAppearance
{
    // UIEdgeInsetsMake (top, left, bottom, right)
    
    // Navigation Bar
    UIImage *navigationBackgroundImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/navi_bg"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [[UINavigationBar appearance] setBackgroundImage:navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[self makeLandscapeImage:navigationBackgroundImage] forBarMetrics:UIBarMetricsLandscapePhone];
    
    // Bar Button
    UIImage *barButtonTexture = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/bar_button_texture"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonTexture
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[self makeLandscapeImage:barButtonTexture]
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsLandscapePhone];
    
    // Bar Back Button
    UIImage *barBackButtonTexture = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/bar_back_button_texture"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 7)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackButtonTexture
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[self makeLandscapeImage:barBackButtonTexture]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsLandscapePhone];
    
    // Toolbar
    UIImage *toolbarBackgroundImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/toolbar_bg"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UIToolbar appearance] setBackgroundImage:toolbarBackgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // SearchBar
    UIImage *searchbarBackgroundImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/searchbar_bg"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UISearchBar appearance] setBackgroundImage:searchbarBackgroundImage];
    
    // SegmentedButton
    UIImage *segmentSelected = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/segmented_control_sel"]]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    UIImage *segmentUnselected = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/segmented_control_uns"]]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    UIImage *segmentSelectedUnselected = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/segmented_control_sel_uns"]];
    UIImage *segUnselectedSelected = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/segmented_control_uns_sel"]];
    UIImage *segmentUnselectedUnselected = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self.environmentInformationManager.uiTheme, @".bundle/segmented_control_uns_uns"]];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:[self makeLandscapeImage:segmentUnselected]
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:[self makeLandscapeImage:segmentUnselected]
                                               forState:UIControlStateDisabled barMetrics:UIBarMetricsLandscapePhone];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:[self makeLandscapeImage:segmentSelected]
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsLandscapePhone];
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[self makeLandscapeImage:segmentUnselectedUnselected]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsLandscapePhone];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[self makeLandscapeImage:segmentSelectedUnselected]
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsLandscapePhone];
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:[self makeLandscapeImage:segUnselectedSelected]
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsLandscapePhone];
}

#pragma mark - init user default value
// 필요에 의해 초기화가 필요한 UserDefault 값을 설정한다.
- (void)initUserDefaultData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"executionMode"] == nil) { // 값이 없으면 기본값 true로 설정함
        [userDefaults setValue:@"DEV" forKey:@"executionMode"];
    }
    [userDefaults synchronize];
}

@end
