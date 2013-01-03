//
//  Menu+CRUD.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "Menu.h"

#define MENUTYPE_FOLDER @"folder"
#define MENUTYPE_NODE @"node"

enum FFViewType {
    FFRemoteWebPage = 0,
    FFLocalWebPage = 1,
    FFNativeView = 2
};
typedef int FFViewType;

@interface Menu (CRUD)

+(Menu *)menuWithCode:(NSString *)code inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *)menusInManagedObjectContext:(NSManagedObjectContext *)context;

@end
