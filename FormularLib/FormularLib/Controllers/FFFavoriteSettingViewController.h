//
//  FFFavoriteSettingViewController.h
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 26..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFavoriteSettingViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *menus;
    UILabel *zeroFavoriteLabel;
}

@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) NSMutableArray *menuCodes;
@property (nonatomic, strong) UILabel *zeroFavoriteLabel;
@property BOOL isEditing;
@end
