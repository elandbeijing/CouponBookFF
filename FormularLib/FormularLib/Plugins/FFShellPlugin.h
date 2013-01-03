//
//  FFShellPlugin.h
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Cordova/CDVPlugin.h>
#import "MWPhotoBrowser.h"

@interface FFShellPlugin : CDVPlugin <MWPhotoBrowserDelegate>


/** 카메라, 앨범 결과 호출 script */
@property (nonatomic, strong) NSString *imageScript;

/** 이미지 뷰어 사진 정보 */
@property (nonatomic, strong) NSMutableArray *photos;

@end


