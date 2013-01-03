//
//  FFMenuViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 22..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFMenuViewController.h"
#import "Section.h"
#import "Menu.h"
#import "Menu+CRUD.h"
#import "FFRootWebViewController.h"
#import "FFAccountManagerProtocol.h"
#import "FFEnvironmentInformationManager.h"
#import "FFNotificationManagerProtocol.h"
#import "FFMenuDataSource.h"
#import "FFCoreDataHelper.h"
#import "FFColorHelper.h"
#import "UIViewController+CurrentViewController.h"

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

@interface FFMenuViewController ()
@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, strong) id<FFAccountManagerProtocol> accountManager;
@property (nonatomic, strong) id<FFNotificationManagerProtocol> notificationManager;
@property (nonatomic, strong) FFMenuDataSource *menuDataSource;
@property (nonatomic, weak) NSBundle *bundle;
@end

@implementation FFMenuViewController

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize accountManager = _accountManager;
@synthesize notificationManager = _notificationManager;
@synthesize menuDataSource = _menuDataSource;
@synthesize bundle = _bundle;

#pragma mark - setter/getter

-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

-(id<FFAccountManagerProtocol>)accountManager
{
    if(!_accountManager)
        _accountManager = [NSClassFromString(self.environmentInformationManager.accountManagerClassName) accountManager];
    return _accountManager;
}

-(id<FFNotificationManagerProtocol>)notificationManager
{
    if(!_notificationManager)
        _notificationManager = [NSClassFromString(self.environmentInformationManager.notificationManagerClassName) notificationManager];
    return _notificationManager;
}


-(FFMenuDataSource *)menuDataSource
{
    if(!_menuDataSource)
        _menuDataSource = [[FFMenuDataSource alloc]init];
    return _menuDataSource;
}

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = UIColor.scrollViewTexturedBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *bigFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1000)];
    
    if ([UIImage imageNamed:@"slide_menu_footer_bg"])
        bigFooterView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"slide_menu_footer_bg"]];
    else
        bigFooterView.backgroundColor = [FFColorHelper opaqueHexColor:0x5A5A5A];
    
    bigFooterView.opaque = YES;
    
    [self.tableView.tableFooterView addSubview:bigFooterView];

    // 아이폰 : 뷰 로드시 메뉴 셋팅.
    // 아이패드 : SpilitViewController에서 initialize 후 setupMenu 실행
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setupMenu];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menuInfo = [self.menuDataSource menuInfoFromIndexPath:indexPath];
    
    FFRootWebViewController *rootWebViewController = [[FFRootWebViewController alloc]init];
    rootWebViewController.title = [menuInfo valueForKey:@"name"];
    
    switch ( [[menuInfo valueForKey:@"viewType"]intValue]) {
        case FFNativeView:
            rootWebViewController = [[NSClassFromString([menuInfo valueForKey:@"url"]) alloc]initWithNibName:[menuInfo valueForKey:@"url"] bundle:nil];
            break;
            
        case FFLocalWebPage:
            rootWebViewController.cdvViewController.startPage = [menuInfo valueForKey:@"url"];
            break;
            
        default:
            rootWebViewController.urlString = [menuInfo valueForKey:@"url"];
            break;
    }
    
    UINavigationController *navigationController = [UIViewController currentViewController].navigationController;
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController setViewControllers:[NSArray arrayWithObject:rootWebViewController]];
    
    [UIViewController setCurrentViewController:rootWebViewController];
    // iPhone인 경우, RootWebView load시, menu button을 보여주고 menu view를 hide 시킴
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [rootWebViewController addMenuRevealButton];
        [rootWebViewController.navigationController.parentViewController performSelector:@selector(hideRearViewController)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = nil;
    
    id sectionValue = [self.menuDataSource.menuSections objectAtIndex:section];
    if([sectionValue isKindOfClass:[Section class]])
        sectionTitle = [sectionValue name];
    else
        sectionTitle = [sectionValue valueForKey:@"sectionName"];
    
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
//    // create image object
    [customView setBackgroundColor: [UIColor colorWithPatternImage:
                                     [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/slide_menu_section_bg", self.environmentInformationManager.menuTheme]]]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(10, 0, tableView.frame.size.width - 10, 22);
    headerLabel.text = sectionTitle;
    
    headerLabel.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [customView addSubview:headerLabel];
    
    return customView;
}

#pragma mark - private method

-(void)setupMenu
{
    // setup menu
    self.tableView.dataSource = nil;
    self.tableView.dataSource = self.menuDataSource;
    
    // make profile image
    UIBarButtonItem *imageBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:
                                           [[UIImageView alloc]initWithImage:
                                            self.accountManager.profileImage]];
    // make user name
    CGRect labelFrame = CGRectMake(0.0, 0.0, 130.0, 36.0);
    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.text = self.accountManager.name;
    UIBarButtonItem *labelBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    
    // make notice button image
    UIButton *noticeImageBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,36)];
    if(self.notificationManager.useNotificationView){
        [noticeImageBarButton setImage:[UIImage imageNamed:@"icons.bundle/noti_icon"] forState:UIControlStateNormal];
        [noticeImageBarButton addTarget:self action:@selector(showNoticeView:) forControlEvents:UIControlEventTouchDown];
    }
    UIBarButtonItem *noticeImageBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:noticeImageBarButton];
    
    // make setting button image
    UIButton *settingImageBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,36)];
    [settingImageBarButton setImage:[UIImage imageNamed:@"icons.bundle/setting_icon"] forState:UIControlStateNormal];
    [settingImageBarButton addTarget:self action:@selector(showSettingView:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *settingImageBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:settingImageBarButton];
    
    // setup navigation bar
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:imageBarButtonItem,labelBarButtonItem, noticeImageBarButtonItem, settingImageBarButtonItem , nil];
    } else {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:imageBarButtonItem,labelBarButtonItem, nil];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settingImageBarButtonItem, noticeImageBarButtonItem, nil];
    }
    
    // setup 완료 후, 첫번째 메뉴를 바로 로딩
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


-(void)showSettingView:(id)sender
{
    [self performSegueWithIdentifier:@"ShowSettingView" sender:self];
}

-(void)showNoticeView:(id)sender
{
    [self.notificationManager showNotificationView];
}

-(NSArray *) getFavoriteMenus{
    NSArray *favoriteMenuCodes = [[NSUserDefaults standardUserDefaults] valueForKey:@"favorites"];
    NSMutableArray *favoriteMenus = [[NSMutableArray alloc]init];
    
    [FFCoreDataHelper openDocument:USER_PROFILE_DOCUMENT usingBlock:^(NSManagedObjectContext *context){
        for(NSString *menuCode in favoriteMenuCodes){
            [favoriteMenus addObject:[Menu menuWithCode:menuCode inManagedObjectContext:context]];
        }
    }];
    
    return favoriteMenus;
}
@end
