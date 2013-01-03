//
//  FFSettingViewController.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 12..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//
#define DEV_EXECUTION_MODE 0
#define QAS_EXECUTION_MODE 1
#define PRD_EXECUTION_MODE 2

#define PHONEGAP_API @"Phonegap API Demo"
#define FORMULAR_API @"Formular API Demo"

#import <UIKit/UIKit.h>

@interface FFSettingViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *settingTableView;
@end
