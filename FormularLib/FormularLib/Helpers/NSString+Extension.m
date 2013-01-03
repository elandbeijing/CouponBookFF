//
//  NSString+Extension.m
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extention)

- (int)compareTo:(NSString*)comp {
    NSComparisonResult result = [self compare:comp];
    if (result == NSOrderedSame) {
        return 0;
    }
    return result == NSOrderedAscending ? -1 : 1;
}

- (int)compareToIgnoreCase:(NSString*)comp {
    return [[self lowercaseString] compareTo:[comp lowercaseString]];
}

- (bool)contains:(NSString*)substring {
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (bool)endsWith:(NSString*)substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == [self length] - [substring length];
}

- (bool)startsWith:(NSString*)substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == 0;
}

- (int)indexOf:(NSString*)substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == NSNotFound ? -1 : range.location;
}

- (int)indexOf:(NSString *)substring startingFrom:(int)index {
    NSString* test = [self substringFromIndex:index];
    return [test indexOf:substring];
}

- (int)lastIndexOf:(NSString*)substring {
    int matchIndex = -1;
    int count = -1;
    NSString* test = self;
    while ([test contains:substring]) {
        matchIndex = [test indexOf:substring];
        count += matchIndex + 1;
        test = [test substringFromIndex: matchIndex + 1];
    }
    return count;
}

- (int)lastIndexOf:(NSString *)substring startingFrom:(int)index {
    NSString* test = [self substringFromIndex:index];
    return [test lastIndexOf:substring];
}

- (NSString*)substringFromIndex:(int)from toIndex:(int)to {
    NSRange range;
    range.location = from;
    range.length = to - from;
    return [self substringWithRange: range];
}

- (NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray*)split:(NSString*)token {
    return [self split:token limit:0];
}

- (NSString*)replace:(NSString*) target withString:(NSString*)replacement {
    return [self stringByReplacingOccurrencesOfString:target withString:replacement];
}

- (NSArray*)split:(NSString*) token limit:(int)maxResults {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity: 8];
    NSString* buffer = self;
    while ([buffer contains:token]) {
        if (maxResults > 0 && [result count] == maxResults - 1) {
            break;
        }
        int matchIndex = [buffer indexOf:token];
        NSString* nextPart = [buffer substringFromIndex:0 toIndex:matchIndex];
        buffer = [buffer substringFromIndex:matchIndex + [token length]];
        if (nextPart) {
            [result addObject:nextPart];
        }
    }
    if ([buffer length] > 0) {
        [result addObject:buffer];
    }
    
    return result;
}

- (NSString *)md5 {
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)sha256 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
