//
//  FFEnvironmentInformationManager.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 7..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TopSegmentedBackgroundImage
} FFThemeType;

@interface FFEnvironmentInformationManager : NSObject

+(FFEnvironmentInformationManager *) environmentInformationManager;

@property (nonatomic, readonly) NSString *accountManagerClassName;
@property (nonatomic, readonly) NSString *loginManagerClassName;
@property (nonatomic, readonly) NSString *notificationManagerClassName;
@property (nonatomic, readonly) NSString *domain;
@property (nonatomic, readonly) int port;
@property (nonatomic, readonly) NSString *backgroundColor;
@property (nonatomic, readonly) NSString *uiTheme;
@property (nonatomic, readonly) NSString *menuTheme;
@property (nonatomic, readonly) bool developmentMode;
@property (nonatomic, readonly) NSDictionary *homeUrl;
@property (nonatomic, readonly) NSString *apiListUrl;

@end
