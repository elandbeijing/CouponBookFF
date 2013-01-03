//
//  FFImageHelper.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 15..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TopSegmentedBackgroundImage
} FFImageType;

@interface FFImageHelper : NSObject

-(UIImage *)imageWithType:(FFImageType)imageType;

@end
