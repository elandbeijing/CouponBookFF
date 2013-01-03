//
//  Section+CRUD.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "Section+CRUD.h"

@implementation Section (CRUD)

+(Section *)sectionWithCode:(NSString *)code inManagedObjectContext:(NSManagedObjectContext *)context
{
    Section *section;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
    request.predicate = [NSPredicate predicateWithFormat:@"code = %@",code];
    
    NSError *error = nil;
    NSArray *sections = [context executeFetchRequest:request error:&error];
    
    if(!sections || sections.count > 1){
        // error
    }else if(!sections.count){
        section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
        section.code = code;
        NSLog(@"Section entity is saved! Code:%@", code);
    }else {
        section = [sections lastObject];
    }
    
    return section;
}

+(NSArray *)sectionsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
    NSArray *sections = [context executeFetchRequest:requst error:nil];
    return sections;
}

+(void)deleteSection:(Section *)section inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:section];
}


@end
