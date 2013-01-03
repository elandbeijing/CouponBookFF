//
//  FFInitializer.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFLoginManagerProtocol.h"
#import "FFAccountManagerProtocol.h"
#import "FFEnvironmentInformationManager.h"

typedef void (^next_action_block)(void);

@interface FFInitializer : NSObject

@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, strong) id<FFAccountManagerProtocol> accountManager;
@property (nonatomic, strong) id<FFLoginManagerProtocol> loginManager;

-(void)initialize:(next_action_block)nextAction;

@end
