//
//  Favorite.h
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 26..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu;

@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) Menu *menus;

@end
