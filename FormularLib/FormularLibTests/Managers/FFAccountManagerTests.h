//
//  FFAccountManagerTests.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FFAccountManagerProtocol.h"
#import "FFEnvironmentInformationManager.h"

@interface FFAccountManagerTests : SenTestCase
@property (nonatomic, strong) FFEnvironmentInformationManager *environmentInformationManager;
@property (nonatomic, strong) id<FFAccountManagerProtocol> accountManager;
@end
