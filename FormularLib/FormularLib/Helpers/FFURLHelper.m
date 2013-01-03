//
//  FFURLHelper.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFURLHelper.h"
#import "FFEnvironmentInformationManager.h"
#import "NSString+Extension.h"
#import "NSDictionary+UrlEncoding.h"

@implementation FFURLHelper

+ (NSString *)getDefaultUrlPrefix
{
    FFEnvironmentInformationManager *environmentInformationManager = [FFEnvironmentInformationManager environmentInformationManager];
    return [NSString stringWithFormat:@"http://%@:%d", environmentInformationManager.domain, environmentInformationManager.port];;
}


+ (NSString *)getFullUrl:(NSString *)url
{
    return [self getFullUrl:url withPrefix:[self getDefaultUrlPrefix]];
}

+ (NSString *)getFullUrl:(NSString *)url withPrefix:(NSString *)prefix
{
    if([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] || [url hasPrefix:@"file://"]) {
        return url;
    } else {
        if([prefix hasSuffix:@"/"] == NO && [url hasPrefix:@"/"] == NO) {
            return [NSString stringWithFormat:@"%@/%@", prefix, url];
        } else {
            return [NSString stringWithFormat:@"%@%@", prefix, url];
        }
    }
}

+ (NSString *)getFullUrl:(NSString *)url withUrl:(NSURL *)currentUrl
{
    if([currentUrl.absoluteString hasPrefix:@"file://"]) {
        NSString *prefix = [currentUrl.absoluteString substringToIndex:[currentUrl.absoluteString lastIndexOf:@"/"]];
        return [self getFullUrl:url withPrefix:[NSString stringWithFormat:@"%@", prefix]];
    } else {
        if(currentUrl.host) {
            if([currentUrl.port intValue] == 0 || [currentUrl.port intValue] == 80) {
                return [self getFullUrl:url withPrefix:[NSString stringWithFormat:@"http://%@", currentUrl.host]];
            } else {
                return [self getFullUrl:url withPrefix:[NSString stringWithFormat:@"http://%@:%d", currentUrl.host, [currentUrl.port intValue]]];
            }
        }
    }
    
    return [self getFullUrl:url];
}

+ (NSString *)getFullUrl:(NSString *)url withParam:(NSDictionary *)dic
{
    NSString *prefix = [self getFullUrl:url];
    
    NSRange range = [prefix rangeOfString:@"?"];
    if(range.length > 0) {
        return [NSString stringWithFormat:@"%@&%@", prefix, [dic urlEncodedString]];
    } else {
        return [NSString stringWithFormat:@"%@?%@", prefix, [dic urlEncodedString]];
    }
}
@end
