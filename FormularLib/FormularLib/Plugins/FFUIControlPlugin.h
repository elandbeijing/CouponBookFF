//
//  FFUIControlPlugin.h
//  FormularLib
//
//  Created by 장재휴 on 12. 10. 4..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

#define CB_UI_CONTROL_RIGHT_BUTTON_TAG 100
#define CB_UI_CONTROL_LEFT_BUTTON_TAG 200
#define CB_UI_CONTROL_LEFT_BACK_BUTTON_TAG 201
#define CB_UI_CONTROL_TOOLBAR_ITEM_TAG 300 /* ~304 */
#define CB_UI_CONTROL_TOOLBAR_TAG 1000
#define CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TAG 400
#define CB_UI_CONTROL_TOP_SEGMENTEDCONTROL_TOOLBAR_TAG 401
#define CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TAG 500
#define CB_UI_CONTROL_BOTTOM_SEGMENTEDCONTROL_TOOLBAR_TAG 501
#define CB_UI_CONTROL_RIGHT_SEGMENTEDCONTROL_TAG 600
#define CB_UI_CONTROL_ACTION_SHEET_IDX 700
#define CB_UI_CONTROL_TITLE_ACTION_TAG 800
#define CB_UI_CONTROL_DATE_PICKER_TAG 900
#define CB_UI_CONTROL_SEARCH_BAR_TAG 1100

@interface FFUIControlPlugin : CDVPlugin <UIActionSheetDelegate>

/** date action sheet */
@property (nonatomic, strong) UIActionSheet *dateActionSheet;
/** date picker */
@property (nonatomic, strong) UIDatePicker *datePicker;

- (void) setNavigationRightButton:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setNavigationRightButtons:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setNavigationLeftButton:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setTopSegmentedControl:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;


- (void) setNavigationTitle:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showProgressHUD:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) dismissProgressHUD:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showToast:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showActionSheet:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setOrientation:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) callDatePicker:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
