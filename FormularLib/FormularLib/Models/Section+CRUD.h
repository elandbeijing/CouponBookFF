//
//  Section+CRUD.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "Section.h"

@interface Section (CRUD)

+(Section *)sectionWithCode:(NSString *)code inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *)sectionsInManagedObjectContext:(NSManagedObjectContext *)context;
+(void)deleteSection:(Section *)section inManagedObjectContext:(NSManagedObjectContext *)context;
@end
