//
//  FFFavoriteSettingViewController.m
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 26..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFFavoriteSettingViewController.h"
#import "Section.h"
#import "Menu.h"
#import "Menu+CRUD.h"
#import "FFAccountManagerProtocol.h"
#import "FFEnvironmentInformationManager.h"
#import "FFCoreDataHelper.h"
#import "NSBundle+Extension.h"
#import "FFColorHelper.h"

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

@interface FFFavoriteSettingViewController ()
@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, strong) id<FFAccountManagerProtocol> accountManager;
@property (nonatomic, strong) NSOrderedSet *menuSections;
@end

@implementation FFFavoriteSettingViewController

@synthesize menus;
@synthesize menuCodes = _menuCodes;
@synthesize zeroFavoriteLabel;
@synthesize isEditing;

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize accountManager = _accountManager;
@synthesize menuSections = _menuSections;

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

-(void)setMenuSections:(NSOrderedSet *)menuSections
{
    if(_menuSections != menuSections){
        _menuSections = menuSections;
        [self.tableView reloadData];
    }
}

#pragma mark - View Lifecycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isEditing = NO;
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"BOOKMARK_TITLE", nil, [NSBundle resourceBundle], nil);
    
    self.menus = [[NSMutableArray alloc]initWithArray:[self getFavoriteMenus]];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editButtonPressed)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    [self.tableView setEditing:!isEditing];
    
    zeroFavoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 37)];
    [zeroFavoriteLabel setBackgroundColor:[UIColor clearColor]];
    [zeroFavoriteLabel setTextColor:[UIColor whiteColor]];
    [zeroFavoriteLabel setTextAlignment:UITextAlignmentCenter];
    [zeroFavoriteLabel setText:NSLocalizedStringFromTableInBundle(@"FAVORITE_EMPTY_MESSAGE", nil, [NSBundle resourceBundle], nil)];
    [zeroFavoriteLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [self.view addSubview:zeroFavoriteLabel];
    if ([menus count] == 0) {
        [zeroFavoriteLabel setHidden:NO];
    } else {
        [zeroFavoriteLabel setHidden:YES];
    }
    
    //background image setting
    self.view.backgroundColor = UIColor.scrollViewTexturedBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *bigFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1000)];
    bigFooterView.backgroundColor = [FFColorHelper opaqueHexColor:0x5A5A5A];    
    [self.tableView.tableFooterView addSubview:bigFooterView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 갱신
//    if (!isEditing) {
//        [accountSqlite updateFavoriteMenu:menus];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editButtonPressed
{
    isEditing = !isEditing;
    if (isEditing) {
        self.menuSections = self.accountManager.menuSections;

        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonPressed)];
        self.navigationItem.rightBarButtonItem = editButton;
        [zeroFavoriteLabel setHidden:YES];
    } else {
        [menus removeAllObjects];
        self.menus= [[NSMutableArray alloc]initWithArray:[self getFavoriteMenus]];
        
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editButtonPressed)];
        self.navigationItem.rightBarButtonItem = editButton;
        if ([menus count] == 0) {
            [zeroFavoriteLabel setHidden:NO];
        }
    }
    [self.tableView setEditing:!isEditing];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isEditing) {
        return self.menuSections.count;
    } else {
        return 1;
    }
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[self.menuSections objectAtIndex:section] name];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isEditing) {
        return [[self.menuSections objectAtIndex:section] menus].count;
    } else {
        return [menus count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favoriteSettingCell";
    UITableViewCell *cell = nil;
    if (IsAtLeastiOSVersion(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    Menu *menu;
    if (isEditing) {
//        menu = [[(MFMenuSectionModel *)[self.menus objectAtIndex:indexPath.section] menus] objectAtIndex:indexPath.row];
        menu = [self menuFromIndexPath:indexPath];
        
        //check favorite
        if([self isFavoriteMenu:menu.code]) {
            UIImageView *mark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icons.bundle/check_icon"]];
            [cell setAccessoryView:mark];
        }
        else {
            [cell setAccessoryView:nil];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else {
        menu = [menus objectAtIndex:indexPath.row];
    }
    [self settingCell:cell withMenu:menu];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isEditing) {
        if ([[[self.menuSections objectAtIndex:section] name] isEqualToString:@""])
            return 0;
        else
            return 22;
    }
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [[self.menuSections objectAtIndex:section] name];
    
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
    // create image object
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        Menu *menu = [self.menus objectAtIndex:indexPath.row];
        
        [self.menus removeObjectAtIndex:indexPath.row];
        [self setFavoriteMenu:self.menus];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Menu *menu = [self.menus objectAtIndex:fromIndexPath.row];
    [menus removeObjectAtIndex:fromIndexPath.row];
    [menus insertObject:menu atIndex:toIndexPath.row];
    [self setFavoriteMenu:menus];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditing) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        Menu *menu = [self menuFromIndexPath:indexPath];

        if([menu.type isEqualToString:@"folder"] == NO) {
            if([self isFavoriteMenu:menu.code] == YES) {
                [self.menus removeObjectAtIndex:[self.menus indexOfObject:menu]];
            } else {
                [self.menus addObject:menu];
            }
            [self setFavoriteMenu:self.menus];
            [tableView reloadData];
            [self.view setNeedsDisplay];
        }
    }
}

#pragma mark - private method

-(Menu *)menuFromIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.menuSections objectAtIndex:indexPath.section] menus]objectAtIndex:indexPath.row];
}

- (Boolean) isFavoriteMenu:(NSString *)menuCode{
    NSArray *favoriteMenus = [[NSArray alloc]initWithArray:[self getFavoriteMenus]];
    
    for(Menu *tmpMenu in favoriteMenus){
        if([menuCode isEqualToString:tmpMenu.code])
            return YES;
    }
    return NO;
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

-(void) setFavoriteMenu:(NSArray *)favoriteMenus{
    NSMutableArray *menuCodes = [[NSMutableArray alloc]init];
    for(Menu *menu in favoriteMenus)
        [menuCodes addObject:menu.code];
    
    [[NSUserDefaults standardUserDefaults] setObject:menuCodes forKey:@"favorites"];
}

- (void) settingCell:(UITableViewCell *)cell withMenu:(Menu *)menu{
    
    for (UIView *view in cell.subviews) {
        if([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/slide_menu_cell_bg", self.environmentInformationManager.menuTheme]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/slide_menu_cell_select_bg", self.environmentInformationManager.menuTheme]];
    
    cell.backgroundView = imageView;
    cell.selectedBackgroundView = imageView2;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 11, 130, 22)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = menu.name;
    [titleLabel setTextAlignment:UITextAlignmentLeft];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 7, 30, 30)];
    
    UIButton *unreadCountButton = [[UIButton alloc]initWithFrame:CGRectMake(240, 10, 40, 22)];
    UIImage *countBackgroundImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/slide_menu_count_bg", self.environmentInformationManager.menuTheme]]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    [unreadCountButton setBackgroundImage:countBackgroundImage forState:UIControlStateNormal];
    [unreadCountButton setBackgroundImage:countBackgroundImage forState:UIControlStateHighlighted];
    [unreadCountButton setBackgroundImage:countBackgroundImage forState:UIControlStateDisabled];
    unreadCountButton.titleLabel.textColor = [UIColor whiteColor];
    [unreadCountButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [unreadCountButton setHidden:YES];

    if([menu.icon hasPrefix:@"http://"]) {
//        [iconImageView setImageWithURL:[NSURL URLWithString:menu.icon]];
    } else {
        if(menu.icon){
            [iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@",
                                                         self.environmentInformationManager.menuTheme, menu.icon]]];
            if(!iconImageView.image)
                [iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icons.bundle/%@", menu.icon]]];
        }
        else
            [iconImageView setImage:[UIImage imageNamed:@"icons.bundle/note_icon"]];
    }
    iconImageView.frame = CGRectMake(iconImageView.frame.origin.x + 15 * [self getMenuDepth:menu],
                                          iconImageView.frame.origin.y,
                                          iconImageView.frame.size.width,
                                          iconImageView.frame.size.height);
    int titleLabelWidth = [menu.badge isEqualToString:@""] ? 190 : 140;
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x + 15 * [self getMenuDepth:menu],
                                       titleLabel.frame.origin.y,
                                       titleLabelWidth - 15 * [self getMenuDepth:menu],
                                       titleLabel.frame.size.height);
    
    if(menu.badge && ![menu.badge isEqualToString:@"0"]) {
        unreadCountButton.hidden = NO;
        [unreadCountButton setTitle:menu.badge forState:UIControlStateNormal];
    }
    
    [cell addSubview:iconImageView];
    [cell addSubview:titleLabel];
    [cell addSubview:unreadCountButton];
}

- (int) getMenuDepth:(Menu *)menu{
    int menuDepth = 1;
    if(menu.parent){
        menuDepth += [self getMenuDepth:menu.parent];
    }
    else
        menuDepth = 0;
    return menuDepth;
}


@end
