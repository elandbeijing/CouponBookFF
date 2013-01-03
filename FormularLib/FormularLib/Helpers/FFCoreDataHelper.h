//
//  FFCoreDataHelper.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USER_PROFILE_DOCUMENT @"UserProfileDocument"

typedef void (^completion_block_t)(NSManagedObjectContext *context);

@interface FFCoreDataHelper : NSObject

+(void)openDocument:(NSString *)documentName usingBlock:(completion_block_t)completionBlock;

@end
