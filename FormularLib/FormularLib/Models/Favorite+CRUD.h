//
//  Favorite+CRUD.h
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 26..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "Favorite.h"

@interface Favorite (CRUD)

+(Favorite *)favoriteWithCode:(NSString *)code inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *)favoritesInManagedObjectContext:(NSManagedObjectContext *)context;
+(void)deleteFavorite:(Favorite *)favorite inManagedObjectContext:(NSManagedObjectContext *)context;

@end
