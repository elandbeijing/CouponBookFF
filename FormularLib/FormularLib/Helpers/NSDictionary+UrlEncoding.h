//
//  NSDictionary+UrlEncoding.h
//  GBFW
//
//  Created by 장재휴 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Dictionary(key-value) => Encoded URL Helper(Category)
 */
@interface NSDictionary (UrlEncoding)

/**
 키-벨류 값을 encoded key=encoded value&...=...&... 로 변경
 */
-(NSString*) urlEncodedString;

@end
