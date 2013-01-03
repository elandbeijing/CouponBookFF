//
//  FFColorHelper.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 16..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFColorHelper.h"

@implementation FFColorHelper

+ (UIColor *)htmlHexColor:(NSString *)htmlColor
{
    if(htmlColor == nil && [htmlColor hasPrefix:@"#"] == NO) {
        return [UIColor whiteColor];
    }
    unsigned int c = 0;
    NSScanner *scanner = [NSScanner scannerWithString:htmlColor];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&c];
    return [FFColorHelper opaqueHexColor:c];
}

+ (UIColor *)opaqueHexColor:(int)c
{
    return [FFColorHelper hexColor:c withAlpha:255.0];
}

+ (UIColor *)hexColor:(int)c
{
    return [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:((c>>24)&0xFF)/255.0];
}

+ (UIColor *)hexColor:(int)c withAlpha:(int)a
{
    return [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:a/255.0];
}

+ (UIColor *)convert:(int)r g:(int)g b:(int)b
{
    return [FFColorHelper convert:r g:g b:b a:255.0];
}

+ (UIColor *)convert:(int)r g:(int)g b:(int)b a:(int)a
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

@end
