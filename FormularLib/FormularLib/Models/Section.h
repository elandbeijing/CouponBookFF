//
//  Section.h
//  FormularLib
//
//  Created by 장재휴 on 12. 12. 10..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *menus;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)insertObject:(Menu *)value inMenusAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMenusAtIndex:(NSUInteger)idx;
- (void)insertMenus:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMenusAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMenusAtIndex:(NSUInteger)idx withObject:(Menu *)value;
- (void)replaceMenusAtIndexes:(NSIndexSet *)indexes withMenus:(NSArray *)values;
- (void)addMenusObject:(Menu *)value;
- (void)removeMenusObject:(Menu *)value;
- (void)addMenus:(NSOrderedSet *)values;
- (void)removeMenus:(NSOrderedSet *)values;
@end
