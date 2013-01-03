//
//  FFURLHelper.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 9..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFURLHelper : NSObject

/**
 주어진 url과 설정값을 조합하여 full url 생성
 @param url 상대경로 또는 절대경로
 @warning 만약 현재 보고 있던 페이지의 정보를 가지고 올수 있다면 getFullUrl:withUrl 함수 이용
 */
+ (NSString *)getFullUrl:(NSString *)url;
/**
 주어진 url과 currentUrl을 조합하여 full url 생성
 @param url 상대경로 또는 절대경로
 @param currentUrl 현재창의 url host와 port를 참조함
 */
+ (NSString *)getFullUrl:(NSString *)url withUrl:(NSURL *)currentUrl;
/**
 주어진 url과 파라미터값 조합하여 full url 생성
 @param url 상대경로 또는 절대경로
 @param param 파라미터값
 */
+ (NSString *)getFullUrl:(NSString *)url withParam:(NSDictionary *)dic;

@end
