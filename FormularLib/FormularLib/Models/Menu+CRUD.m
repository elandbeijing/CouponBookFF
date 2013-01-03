//
//  Menu+CRUD.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "Menu+CRUD.h"

@implementation Menu (CRUD)

+(Menu *)menuWithCode:(NSString *)code inManagedObjectContext:(NSManagedObjectContext *)context
{
    Menu *menu;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Menu"];
    request.predicate = [NSPredicate predicateWithFormat:@"code = %@",code];
    
    NSError *error = nil;
    NSArray *menus = [context executeFetchRequest:request error:&error];
    
    if(!menus || menus.count > 1){
        // error
    }else if(!menus.count){
        menu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:context];
        menu.code = code;
        NSLog(@"Menu entity is saved! Code:%@", code);
    }else {
        menu = [menus lastObject];
    }
    
    return menu;
}

+(NSArray *)menusInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"Menu"];
    NSArray *menus = [context executeFetchRequest:requst error:nil];
    return menus;
}

@end
