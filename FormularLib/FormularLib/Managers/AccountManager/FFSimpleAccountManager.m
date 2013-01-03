//
//  FFSimpleAccountManager.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFSimpleAccountManager.h"
#import "FFCoreDataHelper.h"
#import "Section+CRUD.h"
#import "Menu+CRUD.h"

@implementation FFSimpleAccountManager

@synthesize menuSections = _menuSections;

-(NSOrderedSet *)menuSections
{
    return _menuSections;
}

-(void)setMenuSections:(NSOrderedSet *)menuSections
{
    if(_menuSections != menuSections)
        _menuSections = menuSections;
}

-(void)setMenuInfo:(void (^)())success failure:(void (^)(NSError *error))failure
{
    [FFCoreDataHelper openDocument:USER_PROFILE_DOCUMENT usingBlock:^(NSManagedObjectContext *context){
        
        NSDictionary *sectionInfo = [NSDictionary dictionaryWithObjectsAndKeys:SECTION_INFO, nil];
        Section *section = [Section sectionWithCode:[sectionInfo valueForKey:@"code"] inManagedObjectContext:context];
        section.name = [sectionInfo valueForKey:@"name"];
        
        NSDictionary *menuInfo = [NSDictionary dictionaryWithObjectsAndKeys:MENU_INFO_1, nil];
        Menu *menu = [Menu menuWithCode:[menuInfo valueForKey:@"code"] inManagedObjectContext:context];
        menu.name = [menuInfo valueForKey:@"name"];
        menu.url = [menuInfo valueForKey:@"url"];
        menu.section = section;
        
        menuInfo = [NSDictionary dictionaryWithObjectsAndKeys:MENU_INFO_2, nil];
        menu = [Menu menuWithCode:[menuInfo valueForKey:@"code"] inManagedObjectContext:context];
        menu.name = [menuInfo valueForKey:@"name"];
        menu.url = [menuInfo valueForKey:@"url"];
        menu.section = section;
        
        [self setMenuSections:[NSOrderedSet orderedSetWithObject:section]];
        success();
    }];
}

@end
