//
//  FFMenuDataSource.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 28..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFMenuDataSource.h"
#import "FFEnvironmentInformationManager.h"
#import "FFAccountManagerProtocol.h"
#import "FFURLHelper.h"
#import "Section.h"
#import "FFCoreDataHelper.h"
#import "Menu+CRUD.h"

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

@interface FFMenuDataSource()
@property (nonatomic, readonly) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, readonly) id<FFAccountManagerProtocol> accountManager;

@property (nonatomic, strong) NSArray *favoriteMenus;
@end

@implementation FFMenuDataSource

@synthesize environmentInformationManager = _environmentInformationManager;
@synthesize accountManager = _accountManager;
@synthesize menuSections = _menuSections;
@synthesize favoriteMenus = _favoriteMenus;

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

- (NSArray *)favoriteMenus{
    return _favoriteMenus = [self getFavoriteMenus];
}

-(NSMutableOrderedSet *)menuSections
{
    _menuSections = [NSMutableOrderedSet orderedSetWithOrderedSet:self.accountManager.menuSections];
    if([self.favoriteMenus count])
        [_menuSections insertObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Favorite", @"sectionName",
                                     self.favoriteMenus, @"content",
                                     nil]
                            atIndex:0];
    if(self.environmentInformationManager.homeUrl)
        [_menuSections insertObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"home", @"sectionName",
                                     [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               [self.environmentInformationManager.homeUrl valueForKey:@"name"], @"name",
                                                               [self.environmentInformationManager.homeUrl valueForKey:@"viewType"],@"viewType",
                                                               [self.environmentInformationManager.homeUrl valueForKey:@"url"],@"url",
                                                               nil]], @"content",
                                     nil]
                            atIndex:0];

    return _menuSections;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuSections.count;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    id sectionValue = [self.menuSections objectAtIndex:section];
//    if([sectionValue isKindOfClass:[Section class]])
//        return [sectionValue name];
//    else
//        return [sectionValue valueForKey:@"sectionName"];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionValue = [self.menuSections objectAtIndex:section];
    if([sectionValue isKindOfClass:[Section class]])
        return [sectionValue menus].count;
    else
        return [[sectionValue valueForKey:@"content"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = nil;
    if (IsAtLeastiOSVersion(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/slide_menu_cell_bg", self.environmentInformationManager.menuTheme]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/slide_menu_cell_select_bg", self.environmentInformationManager.menuTheme]];
    
    cell.backgroundView = imageView;
    cell.selectedBackgroundView = imageView2;
    
    id menuInfo = [self menuInfoFromIndexPath:indexPath];
    if([menuInfo isKindOfClass:[Menu class]])
        [self settingCell:cell withMenu:menuInfo];
    else
        [self settintHomeCell:cell withMenu:menuInfo];

    return cell;
}

-(id) menuInfoFromIndexPath:(NSIndexPath *)indexPath
{
    id sectionValue = [self.menuSections objectAtIndex:indexPath.section];
    if([sectionValue isKindOfClass:[Section class]]){
        Menu *menu = [[[self.menuSections objectAtIndex:indexPath.section] menus]objectAtIndex:indexPath.row];
//        return [NSDictionary dictionaryWithObjectsAndKeys:menu.name, @"name", menu.url, @"url", nil];
        return menu;
    } else {
        id value = [[sectionValue valueForKey:@"content"] objectAtIndex:indexPath.row];
        if([[sectionValue valueForKey:@"sectionName"] isEqualToString:@"Favorite"])
            return value;
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[value valueForKey:@"name"],@"name",[value valueForKey:@"url"],@"url", [value valueForKey:@"viewType"], @"viewType",nil];
        
    }
}

- (void) settintHomeCell:(UITableViewCell *)cell withMenu:(NSDictionary *)menu{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 11, 130, 22)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = [menu valueForKey:@"name"];
    [titleLabel setTextAlignment:UITextAlignmentLeft];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    [iconImageView setImage:[UIImage imageNamed:@"icons.bundle/home_icon"]];
    
    [cell addSubview:iconImageView];
    [cell addSubview:titleLabel];
}

- (void) settingCell:(UITableViewCell *)cell withMenu:(Menu *)menu{
    
    for (UIView *view in cell.subviews) {
        if([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 11, 130, 22)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = menu.name;
    [titleLabel setTextAlignment:UITextAlignmentLeft];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    
    UIButton *unreadCountButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 10, 40, 22)];
    UIImage *countBackgroundImage = [[UIImage imageNamed:@"icons.bundle/slide_menu_count_bg"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    [unreadCountButton setBackgroundImage:countBackgroundImage forState:UIControlStateNormal];
    [unreadCountButton setBackgroundImage:countBackgroundImage forState:UIControlStateHighlighted];
    [unreadCountButton setBackgroundImage:countBackgroundImage forState:UIControlStateDisabled];
    unreadCountButton.titleLabel.textColor = [UIColor whiteColor];
    [unreadCountButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [unreadCountButton setHidden:YES];
    
    if(menu.icon){
        if([menu.icon hasPrefix:@"http://"]) {
            //        [iconImageView setImageWithURL:[NSURL URLWithString:menu.icon]];
        } else {
            [iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@",
                                                         self.environmentInformationManager.menuTheme, menu.icon]]];
            if(!iconImageView.image)
                [iconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icons.bundle/%@", menu.icon]]];
        }
    }
    else
        [iconImageView setImage:[UIImage imageNamed:@"icons.bundle/note_icon"]];
        
    iconImageView.frame = CGRectMake(iconImageView.frame.origin.x + 15 * [self getMenuDepth:menu],
                                     iconImageView.frame.origin.y,
                                     iconImageView.frame.size.width,
                                     iconImageView.frame.size.height);
    int titleLabelWidth = [menu.badge isEqualToString:@""] ? 190 : 140;
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x + 15 * [self getMenuDepth:menu],
                                  titleLabel.frame.origin.y,
                                  titleLabelWidth - 15 * [self getMenuDepth:menu],
                                  titleLabel.frame.size.height);
    
    if(![menu.badge isEqualToString:@"0"]) {
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

