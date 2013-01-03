//
//  Menu.h
//  FormularLib
//
//  Created by 장재휴 on 12. 12. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu, Section;

@interface Menu : NSManagedObject

@property (nonatomic, retain) NSString * badge;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * viewType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) Menu *parent;
@property (nonatomic, retain) Section *section;
@end

@interface Menu (CoreDataGeneratedAccessors)

- (void)insertObject:(Menu *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(Menu *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(Menu *)value;
- (void)removeChildrenObject:(Menu *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end
