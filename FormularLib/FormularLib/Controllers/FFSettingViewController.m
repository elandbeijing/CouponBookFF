//
//  FFSettingViewController.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 12..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFSettingViewController.h"
#import "FFLocalizationHelper.h"
#import "FFEnvironmentInformationManager.h"
#import "FFVersion.h"
#import "iToast.h"
#import "FFWebViewController.h"
#import "FFFavoriteSettingViewController.h"
#import "NSBundle+Extension.h"
#import "FFSettingDebugTableViewController.h"

@interface FFSettingViewController (){
    NSArray *settingArray;
}
@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, strong) UISegmentedControl *modeSegmentedControl;
@end

@implementation FFSettingViewController

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize modeSegmentedControl = _modeSegmentedControl;

static int beforeExcutionMode;

#pragma mark - setter/getter
-(FFEnvironmentInformationManager *)environmentInformationManager
{
    if(!_environmentInformationManager)
        _environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return _environmentInformationManager;
}

#pragma mark - View Lifecycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];

    [self.navigationItem setTitle:NSLocalizedStringFromTableInBundle(@"SETTING_TITLE", nil, [NSBundle resourceBundle], nil)];
    settingArray = [self getSettingTableArray];
    
    NSString *excutionMode = [[NSUserDefaults standardUserDefaults] valueForKey:@"executionMode"];
    
    if ([excutionMode isEqualToString:@"PRD"]) {
        beforeExcutionMode = PRD_EXECUTION_MODE;
    }
    else if ([excutionMode isEqualToString:@"QAS"]){
        beforeExcutionMode = QAS_EXECUTION_MODE;
    }
    else{
        beforeExcutionMode = DEV_EXECUTION_MODE;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePressed:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [settingArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[settingArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *settingTableViewCell = [NSString stringWithFormat:@"SettingCell_%d_%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingTableViewCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingTableViewCell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *cellType = [[settingArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([cellType isEqualToString:@"favorite"]) {
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"SETTING_FAVORITE", nil, [NSBundle resourceBundle], nil);
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([cellType isEqualToString:@"clear_cache"]) {
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"SETTING_CLEAR_CACHE", nil, [NSBundle resourceBundle], nil);
        
    }
    else if ([cellType isEqualToString:@"appname"]) {
        NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"SETTING_APPNAME", nil, [NSBundle resourceBundle], nil);
        NSString *appName = [appInfo objectForKey:@"CFBundleDisplayName"];
        cell.detailTextLabel.text = appName;
    }
    else if ([cellType isEqualToString:@"appversion"]) {
        NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"SETTING_APPVERSION", nil, [NSBundle resourceBundle], nil);
        NSString *appVersion = [appInfo objectForKey:@"CFBundleVersion"];
        cell.detailTextLabel.text = appVersion;
    }
    else if ([cellType isEqualToString:@"frameworkversion"]) {
        NSString *frameworkVersion = [NSString stringWithFormat:@"MFW/%@", MOBILE_FRAMEWORK_VERSION];
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"SETTING_FRAMEWORK", nil, [NSBundle resourceBundle], nil);
        cell.detailTextLabel.text = frameworkVersion;
        
    }
    else if ([cellType isEqualToString:PHONEGAP_API]) {
        cell.textLabel.text = PHONEGAP_API;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    else if ([cellType isEqualToString:FORMULAR_API]) {
        cell.textLabel.text = FORMULAR_API;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    else if ([cellType isEqualToString:@"debug"]) {
        cell.textLabel.text = @"Debug";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults boolForKey:@"isDebugMode"]) {
            cell.detailTextLabel.text = @"On";
        }
        else {
            cell.detailTextLabel.text = @"Off";
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    else if ([cellType isEqualToString:@"executionMode"]) {
        cell.textLabel.text = @"Mode";
        NSArray * segmentItems= [NSArray arrayWithObjects: @"DEV", @"QAS", @"PRD", nil];
        
        self.modeSegmentedControl = [[UISegmentedControl alloc]initWithItems:segmentItems];
        [self.modeSegmentedControl setFrame:CGRectMake(150, 7, 140, 30)];
        [self.modeSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [self.modeSegmentedControl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:self.modeSegmentedControl];
        
        if (beforeExcutionMode == PRD_EXECUTION_MODE) {
            [self.modeSegmentedControl setSelectedSegmentIndex:PRD_EXECUTION_MODE];
        }
        else if (beforeExcutionMode == QAS_EXECUTION_MODE){
            [self.modeSegmentedControl setSelectedSegmentIndex:QAS_EXECUTION_MODE];
        }
        else{
            [self.modeSegmentedControl setSelectedSegmentIndex:DEV_EXECUTION_MODE];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = [[settingArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cellType isEqualToString:@"favorite"]) {
        NSBundle *bundle = [NSBundle resourceBundle];
        UIStoryboard *mainStroyBoard = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:bundle];
        else
            mainStroyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:bundle];
        
        FFFavoriteSettingViewController *favoriteSettingViewController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"FavoriteSettingViewController"];
        [self.navigationController pushViewController:favoriteSettingViewController animated:YES];
    }
    else if ([cellType isEqualToString:@"clear_cache"]) {
        // remove all cached responses
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[iToast makeText:NSLocalizedStringFromTableInBundle(@"SETTING_CLEAR_CACHE_COMPLETE", nil, [NSBundle resourceBundle], nil)] show];
    }
    else if ([cellType isEqualToString:PHONEGAP_API]) {
        FFWebViewController *developmentViewController = [[FFWebViewController alloc] init];
//        developmentViewController.urlString = self.environmentInformationManager.apiListUrl;
        developmentViewController.title = PHONEGAP_API;
        developmentViewController.cdvViewController.wwwFolderName = @"FormularLibResource.bundle/www";
        developmentViewController.cdvViewController.startPage = @"index.html";
        [self.navigationController pushViewController:developmentViewController animated:YES];
    }
    else if ([cellType isEqualToString:FORMULAR_API]) {
        FFWebViewController *developmentViewController = [[FFWebViewController alloc] init];
        developmentViewController.urlString = self.environmentInformationManager.apiListUrl;
        developmentViewController.title = FORMULAR_API;
        [self.navigationController pushViewController:developmentViewController animated:YES];
    }
    else if ([cellType isEqualToString:@"debug"]) {
        FFSettingDebugTableViewController *settingDebugView = [[FFSettingDebugTableViewController alloc] init];
        [self.navigationController pushViewController:settingDebugView animated:YES];
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (NSArray *)getSettingTableArray
{
    NSMutableArray *settingTableArray = [NSMutableArray array];
    
//    if ([customSettingSectionArray count] > 0) {
//        NSMutableArray *sectionArray_4 = [NSMutableArray array];
//        for (int i = 0; i < [customSettingSectionArray count]; i++) {
//            [sectionArray_4 addObject:@"customsetting"];
//        }
//        [settingTableArray addObject:sectionArray_4];
//    }
    
    NSMutableArray *sectionArray_1 = [[NSMutableArray alloc] initWithObjects:@"favorite", @"clear_cache", nil];
    [settingTableArray addObject:sectionArray_1];
    
    NSArray *sectionArray_2 = [[NSArray alloc] initWithObjects:@"appname", @"appversion", @"frameworkversion", nil];
    [settingTableArray addObject:sectionArray_2];
    
    if([FFEnvironmentInformationManager environmentInformationManager].developmentMode == YES)  {
        NSArray *sectionArray_3 = [[NSArray alloc] initWithObjects:PHONEGAP_API, FORMULAR_API, @"debug", @"executionMode", nil];
        [settingTableArray addObject:sectionArray_3];
    }
    
    return settingTableArray;
}

- (void) segmentedValueChanged:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                       message:NSLocalizedStringFromTableInBundle(@"SHELL_EXIT_MESSAGE", nil, [NSBundle resourceBundle], nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"CANCLE_BUTTON", nil, [NSBundle resourceBundle], nil)
                                             otherButtonTitles:NSLocalizedStringFromTableInBundle(@"CONFIRM_BUTTON", nil, [NSBundle resourceBundle], nil)
                              , nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
        self.modeSegmentedControl.selectedSegmentIndex = beforeExcutionMode;
    else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if(self.modeSegmentedControl.selectedSegmentIndex == DEV_EXECUTION_MODE)
            [userDefaults setValue:@"DEV" forKey:@"executionMode"];
        else if(self.modeSegmentedControl.selectedSegmentIndex == QAS_EXECUTION_MODE)
            [userDefaults setValue:@"QAS" forKey:@"executionMode"];
        else if(self.modeSegmentedControl.selectedSegmentIndex == PRD_EXECUTION_MODE)
            [userDefaults setValue:@"PRD" forKey:@"executionMode"];
        
        [userDefaults synchronize];
        exit(1);
    }
        
}
@end
