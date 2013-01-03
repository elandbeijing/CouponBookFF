//
//  FFLoginManagerProtocol.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FFLoginManagerProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString *loginId;

@required
- (void)firstLogin:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)login:(void (^)())success failure:(void (^)(NSError *error))failure;
+(id<FFLoginManagerProtocol>)loginManager;

@end
