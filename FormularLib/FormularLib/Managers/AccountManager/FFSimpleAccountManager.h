//
//  FFSimpleAccountManager.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFBaseAccountManager.h"

#define SECTION_INFO @"sample menu", @"name", @"S001", @"code"
#define MENU_INFO_1 @"index", @"name", @"M001", @"code", @"http://121.169.202.179:8001/", @"url"
#define MENU_INFO_2 @"네이버", @"name", @"M002", @"code", @"http://m.naver.com", @"url"

@interface FFSimpleAccountManager : FFBaseAccountManager

@end
