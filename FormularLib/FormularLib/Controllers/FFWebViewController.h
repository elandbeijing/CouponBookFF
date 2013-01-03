//
//  FFWebViewController.h
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//
#define FF_BASE_UI_WEBVIEW_TAG 10
#define FF_BASE_UI_INDICATOR_VIEW_TAG 20
#define FF_BASE_UI_TOP_SUB_VIEW_TAG 30
#define FF_BASE_UI_BOTTOM_SUB_VIEW_TAG 40
#define FF_BASE_UI_BOTTOM_STATIC_VIEW_TAG 50

#define FF_SLIDE_LEFT_MENU_WIDTH 260

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

#import <Cordova/CDVViewController.h>

@interface FFWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly) CDVViewController *cdvViewController;

@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (assign) BOOL isShowTopToolbar;
@property (assign) BOOL isShowBottomToolbar;

@property (nonatomic, weak) FFWebViewController *parent;

/** 각종 콜백 스크립트 저장 */
@property (nonatomic, strong) NSMutableDictionary *scripts;
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSString *deviceOrientation;
@property (nonatomic, readonly) UIWebView *webView;

- (void)loadUrl:(NSString *)urlString;
- (void)loadUrl:(NSString *)urlString method:(NSString *)method;

- (void)reloadUrl;
- (void)reloadUrl:(BOOL)init;

- (void)evalScript:(id)sender;
- (void)evalScriptByIdx:(NSNumber *)idx;
- (void)evalScript:(NSString *)script async:(BOOL)async;

- (void)addBottomSubview:(UIView *)subview;
- (void)hideToolbar:(NSInteger)tag;

- (void)showTopToolbar;
- (void)showBottomToolbar;

-(void)showRefreshControl;
-(void)hideRefreshControl;
@end
