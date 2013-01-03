//
//  CBJSONResult.m
//  CB
//
//  Created by 장재휴 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "CBJSONResult.h"

@implementation CBJSONResult

@synthesize result;
@synthesize msg;
@synthesize data;

- (id)initWithJSON:(id)JSON
{
    self = [super init];
    if (self) {
        self.result = [JSON valueForKeyPath:@"result"];
        self.msg = [JSON valueForKeyPath:@"msg"];
        self.data = [JSON valueForKeyPath:@"data"];
    }
    
    return self;
}

@end
