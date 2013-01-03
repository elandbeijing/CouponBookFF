//
//
//  FFWebViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFWebViewController.h"
#import "FFUIControlPlugin.h"
#import "FFColorHelper.h"
#import "FFEnvironmentInformationManager.h"
#import "ODRefreshControl.h"
#import "NSBundle+Extension.h"
#import "UIViewController+CurrentViewController.h"

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

@interface FFWebViewController (){
    time_t  lastActiveTimestamp;    
    BOOL isViewDidAppear;
}
@property (nonatomic, readonly) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, readonly) NSString *cordovaJavaScript;
@property (nonatomic, readonly) NSString *blankPageScript;
@property (nonatomic, readonly) UIActivityIndicatorView *indicator;
@property (nonatomic, readonly) UIControl *refreshControl;
@end

@implementation FFWebViewController

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize urlString = _urlString;
@synthesize scripts = _scripts;
@synthesize cdvViewController = _cdvViewController;
@synthesize cordovaJavaScript;
@synthesize blankPageScript;
@synthesize topToolbar = _topToolbar;
@synthesize bottomToolbar = _bottomToolbar;
@synthesize isShowTopToolbar = _isShowTopToolbar;
@synthesize isShowBottomToolbar = _isShowBottomToolbar;
@synthesize deviceOrientation = _deviceOrientation;
@synthesize parent = _parent;
@synthesize indicator = _indicator;
@synthesize refreshControl = _refreshControl;

static FFWebViewController *_currentViewController;
static NSString *_cordovaJavaScript;
static NSString *_blankPageScript;

+ (FFWebViewController *)currentViewController
{
    return _currentViewController;
}

#pragma mark - getter/setter

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(NSMutableDictionary *)scripts
{
    if(!_scripts)
        _scripts = [NSMutableDictionary dictionary];
    return _scripts;
}

-(CDVViewController *)cdvViewController
{
    if(!_cdvViewController){
        _cdvViewController = [CDVViewController new];
        _cdvViewController.useSplashScreen = YES;
        _cdvViewController.wwwFolderName = @"www";
        _cdvViewController.startPage = @"";
        _cdvViewController.useSplashScreen = NO;
    }
    return _cdvViewController;
}

-(NSString *)cordovaJavaScript
{
    if(!_cordovaJavaScript){
        NSBundle *bundle = [NSBundle resourceBundle];
        NSString *filePath = [bundle pathForResource:@"cordova-2.2.0" ofType:@"js"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        _cordovaJavaScript = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
    }
    return _cordovaJavaScript;
}

-(NSString *)blankPageScript
{
    if(!_blankPageScript){
        _blankPageScript = [NSString stringWithFormat:@"document.body.innerHTML = ''; document.body.style.backgroundColor = '%@';", self.environmentInformationManager.backgroundColor];
        
    }
    return _blankPageScript;
}

-(UIWebView *)webView
{
    return self.cdvViewController.webView;
}

-(UIActivityIndicatorView *)indicator
{
    if(!_indicator){
        
        // CDVViewController의 activityView를 indicator로 사용 (CDVViewController.m 참고하여 작성함)
        
        NSString* topActivityIndicator = [self.cdvViewController.settings objectForKey:@"TopActivityIndicator"];
        UIActivityIndicatorViewStyle topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        
        if ([topActivityIndicator isEqualToString:@"whiteLarge"]) {
            topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
        } else if ([topActivityIndicator isEqualToString:@"white"]) {
            topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
        } else if ([topActivityIndicator isEqualToString:@"gray"]) {
            topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        }
        [self.cdvViewController performSelector:@selector(setActivityView:)
                                     withObject:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:topActivityIndicatorStyle]];
        self.cdvViewController.activityView.tag = 2;
        [self.cdvViewController.view.superview addSubview:self.cdvViewController.activityView];
        
        self.cdvViewController.activityView.center = self.view.center;
        [self.cdvViewController.view.superview layoutSubviews];
        _indicator = self.cdvViewController.activityView;
    }
    return _indicator;
}

-(UIControl *)refreshControl
{
    if(!_refreshControl){
        if (NSClassFromString(@"UIRefreshControl") != nil){
            
            // iOS 6.0 이상: UIRefreshControl 사용
            _refreshControl = [[NSClassFromString(@"UIRefreshControl") alloc]init];
            
        } else {
            
            // iOS 6.0 미만: ODRefreshControl 사용
            _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.webView.scrollView];
            [self.webView.scrollView addSubview:_refreshControl];
            
        }
        [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

# pragma mark - UIViewController Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIViewController setCurrentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.cdvViewController.view];
    self.webView.delegate = self;
    self.view.backgroundColor = [FFColorHelper htmlHexColor:self.environmentInformationManager.backgroundColor];
    self.webView.backgroundColor = [FFColorHelper htmlHexColor:self.environmentInformationManager.backgroundColor];
    [self hideRefreshControl]; //refreshControl은 디폴트로 hide 시킴

    self.cdvViewController.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    
    if(self.urlString)
        [self loadUrl:self.urlString];    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // add observer app switching event
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    if(isViewDidAppear == YES) { // 한번 로딩이 완료되었다면 새로 창을 보여줄때마다 함수 호출
        NSLog(@"viewDidAppear");
        time_t nowTimestamp = (time_t) [[NSDate date] timeIntervalSince1970];
        long check = nowTimestamp - lastActiveTimestamp;
        [self evalScript:[NSString stringWithFormat:@"if(viewDidAppear !== undefined) {viewDidAppear(%ld);}", check]];
    } else {
        isViewDidAppear = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    lastActiveTimestamp = (time_t) [[NSDate date] timeIntervalSince1970];
    
    // remove observer app switching event
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:NULL];
    
}



-(void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // CDVController 메모리 처리
//    [self.cdvViewController didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{    
    [self.cdvViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willEnterForeground;
{
    NSLog(@"willEnterForeground");
    time_t nowTimestamp = (time_t) [[NSDate date] timeIntervalSince1970];
    long check = nowTimestamp - lastActiveTimestamp;
    [self evalScript:[NSString stringWithFormat:@"if(viewDidAppear !== undefined) {viewDidAppear(%ld);}", check]];
}

- (void)willEnterBackground;
{
    NSLog(@"willEnterBackground");
    lastActiveTimestamp = (time_t) [[NSDate date] timeIntervalSince1970];
    
    // 로딩바 제거
//    [SVProgressHUD dismiss];
}

#pragma mark - webview load

- (void)loadUrl:(NSString *)urlString
{
    [self loadUrl:urlString method:@"GET"];
}

- (void)loadUrl:(NSString *)urlString method:(NSString *)method
{   
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [self.webView loadRequest:request];
    [self webViewLoadingStart];
}

- (void)reloadUrl
{
    [self reloadUrl:NO];
}

- (void)reloadUrl:(BOOL)init
{
    if(init == YES) {
        [self.indicator startAnimating];
        [self.webView stringByEvaluatingJavaScriptFromString:self.blankPageScript];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    [self.webView reload];
}

#pragma - mark RefreshControl(iOS6.0 이후)

-(void)refreshView:(UIControl *)sender
{
    [self reloadUrl];
}

# pragma mark - UIWebViewDelegate Protocol

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(error.code != -999 && error.code != 204 && error.code != 102) { // ignore operation couldn't be complete error
        [self.cdvViewController webView:webView didFailLoadWithError:error];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [self.cdvViewController webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.cdvViewController webViewDidStartLoad:webView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [webView stringByEvaluatingJavaScriptFromString:self.cordovaJavaScript];    
    [self.cdvViewController webViewDidFinishLoad:webView];
    [self webViewLoadingFinish];
}

#pragma - mark private 

- (void)webViewLoadingStart
{
    [self.indicator startAnimating];
    [self.webView stringByEvaluatingJavaScriptFromString:self.blankPageScript];
    [self.webView setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewLoadingFinish
{
    [self.webView setUserInteractionEnabled:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.refreshControl performSelector:@selector(endRefreshing)];
    [self.indicator stopAnimating];
}

#pragma mark - eval script

- (void)evalScript:(id)sender
{
    if([sender isKindOfClass:[NSString class]]){
        [self evalScript:sender async:NO];
    } else {
        UIView *obj = (UIView *)sender;
        [self evalScriptByIdx:[NSNumber numberWithInt:obj.tag]];
    }
}

- (void)evalScriptByIdx:(NSNumber *)idx
{
    NSString *script = [self.scripts objectForKey:[NSString stringWithFormat:@"%d", [idx intValue]]];
    [self evalScript:script async:NO];
}

- (void)evalScript:(NSString *)script async:(BOOL)async
{
    if(async == YES)
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimeout(function() {%@}, 1);", script]];
    else
        [self.webView stringByEvaluatingJavaScriptFromString:script];
}

#pragma mark - toolbar manage

- (void)showTopToolbar
{
    if(!self.isShowTopToolbar)
        [self updateWebViewSize:CGRectMake(0, self.topToolbar.frame.size.height, 0, -self.topToolbar.frame.size.height)];
    self.isShowTopToolbar = YES;
}

- (void)showBottomToolbar
{
    if(!self.isShowBottomToolbar)
        [self updateWebViewSize:CGRectMake(0, 0, 0, -self.bottomToolbar.frame.size.height)];
    self.isShowBottomToolbar = YES;
}

- (void)updateWebViewSize:(CGRect)frame
{
    CGRect webViewFrame = self.cdvViewController.view.frame;
    webViewFrame.origin.x += frame.origin.x;
    webViewFrame.origin.y += frame.origin.y;
    webViewFrame.size.width += frame.size.width;
    webViewFrame.size.height += frame.size.height;
    self.cdvViewController.view.frame = webViewFrame;
}

- (void)hideToolbar:(NSInteger)tag
{
    if(tag == CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TOOLBAR_TAG && self.isShowTopToolbar){
        [self updateWebViewSize:CGRectMake(0, -self.topToolbar.frame.size.height, 0, self.topToolbar.frame.size.height)];
        self.isShowTopToolbar = NO;
    }
    else if((tag == CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TOOLBAR_TAG || tag == CB_UI_CONTROL_TOOLBAR_TAG) && self.isShowBottomToolbar){
        [self updateWebViewSize:CGRectMake(0, 0, 0, self.bottomToolbar.frame.size.height)];
        self.isShowBottomToolbar = NO;
    }
}

// iOS 6.0 이상: UIRefreshControl 사용
// iOS 6.0 미만: ODRefreshControl 사용
// show() & hide() 방식 다름
-(void)showRefreshControl
{
    if (IsAtLeastiOSVersion(@"6.0"))
        [self.webView.scrollView addSubview:self.refreshControl];
    else
        self.refreshControl.enabled = YES;
}
-(void)hideRefreshControl
{
    if (IsAtLeastiOSVersion(@"6.0"))
        [self.refreshControl removeFromSuperview];
    else
        self.refreshControl.enabled = NO;
}

@end
