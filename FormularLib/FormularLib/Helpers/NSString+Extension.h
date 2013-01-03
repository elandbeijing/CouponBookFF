//
//  NSString+Extension.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (int)compareTo:(NSString*)comp;
- (int)compareToIgnoreCase:(NSString*)comp;
- (bool)contains:(NSString*)substring;
- (bool)endsWith:(NSString*)substring;
- (bool)startsWith:(NSString*)substring;
- (int)indexOf:(NSString*)substring;
- (int)indexOf:(NSString *)substring startingFrom:(int)index;
- (int)lastIndexOf:(NSString*)substring;
- (int)lastIndexOf:(NSString *)substring startingFrom:(int)index;
- (NSString*)substringFromIndex:(int)from toIndex:(int)to;
- (NSString*)trim;
- (NSArray*)split:(NSString*)token;
- (NSString*)replace:(NSString*) target withString:(NSString*)replacement;
- (NSArray*)split:(NSString*) token limit:(int)maxResults;
- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
@end
