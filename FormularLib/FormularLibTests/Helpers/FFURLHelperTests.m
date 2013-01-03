//
//  FFURLHelperTests.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFURLHelperTests.h"

@implementation FFURLHelperTests

-(void)testGetFullUrl
{
    NSString *fullUrl = [FFURLHelper getFullUrl:@"/api/index.html" withUrl:[NSURL URLWithString:@"http://ec2-175-41-233-173.ap-northeast-1.compute.amazonaws.com:3000/"]];
    NSLog(@"fullUrl: %@",fullUrl);
    STAssertEqualObjects(fullUrl, @"http://ec2-175-41-233-173.ap-northeast-1.compute.amazonaws.com:3000/api/index.html", @"not equal");
    
    fullUrl = [FFURLHelper getFullUrl:@"/api/index.html"];
    NSLog(@"fullUrl: %@",fullUrl);
    STAssertEqualObjects(fullUrl, @"http://ec2-175-41-233-173.ap-northeast-1.compute.amazonaws.com:3000/api/index.html", @"not equal");
}

@end
