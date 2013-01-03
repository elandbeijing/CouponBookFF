//
//  FFMenuDataSource.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 28..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"

@interface FFMenuDataSource : NSObject<UITableViewDataSource>
-(NSDictionary *)menuInfoFromIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, readonly) NSMutableOrderedSet *menuSections;
@end
