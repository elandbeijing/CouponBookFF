//
//  FFLocalizationHelper.m
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "FFLocalizationHelper.h"

@implementation FFLocalizationHelper
+ (NSString *)getAppleLocalizableLanguage:(NSString *)key
{
    NSBundle* uikitBundle = [NSBundle bundleForClass:[UIButton class]];
    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSBundle *languageBundle = [NSBundle bundleWithPath:[uikitBundle pathForResource:language ofType:@"lproj"]];
    if (!languageBundle) {
        return key;
    }
    return NSLocalizedStringFromTableInBundle(key, @"Localizable", languageBundle, nil);
}
@end
