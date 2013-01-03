//
//  FFAccountManagerProtocol.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFAccountManagerProtocol <NSObject>

@required

-(void)setMenuInfo:(void (^)())success failure:(void (^)(NSError *error))failure;
+(id<FFAccountManagerProtocol>) accountManager;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) UIImage *profileImage;
@property (nonatomic, strong, readonly) NSOrderedSet *menuSections;

@optional

@property (nonatomic, strong, readonly) NSDictionary *userInfo;
@property (nonatomic, strong, readonly) NSString *email;

@end
