//
//  FFDateHelper.m
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 13..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFDateHelper.h"

@implementation FFDateHelper
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDate *date = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSError *error = nil;
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    if (![dateFormatter getObjectValue:&date forString:dateString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
    }
    return date;
}

@end
