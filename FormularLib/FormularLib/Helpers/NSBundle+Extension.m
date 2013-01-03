//
//  NSBundle+Extension.m
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 28..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)
+(NSBundle *)resourceBundle
{
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"FormularLibResource" withExtension:@"bundle"]];
}
@end
