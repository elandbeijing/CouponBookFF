//
//  NSDictionary+UrlEncoding.m
//  GBFW
//
//  Created by 장재휴 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"

// helper function: get the string form of any object
static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
// http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                           (__bridge CFStringRef)string,
                                                                                           NULL,
                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                           kCFStringEncodingUTF8);
    return encodedString;
}

@implementation NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString
{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey:key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}
@end
