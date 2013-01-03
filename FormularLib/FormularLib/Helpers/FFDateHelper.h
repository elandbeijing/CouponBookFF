//
//  FFDateHelper.h
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 13..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 날짜 관련 helper
 */
@interface FFDateHelper : NSObject
/**
 스트링 날짜를 NSDate형으로 변경
 .net에서 날짜를 생성할 경우 - date.ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'");
 javascript에서 날짜를 생성할 경우 - date.js date.toString("yyyy-MM-ddTHH:mm:ss")
 ex) @"2009-10-16T09:42:24";
 @param dateString 스트링 날짜
 */
+ (NSDate *)dateFromString:(NSString *)dateString;
@end
