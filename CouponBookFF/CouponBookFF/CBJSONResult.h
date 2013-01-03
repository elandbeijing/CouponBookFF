//
//  CBJSONResult.h
//  CB
//
//  Created by 장재휴 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/JSONKit.h>

enum {
    CBRequestResultCodeOk = 0,        // 정상
    CBRequestResultCodeCustomError,   // 정상 에러 (서버에서 정상으로 처리하여 에러 처리함)
    // 하단부는 일반적으로 생기면 안되는 에러임!!
    CBRequestResultCodeJsonError,     // JSON parse exception
    CBRequestResultCodeRequestError,  // 요청 에러 (네트웍등의 문제)
    CBRequestResultCodeServerError,   // 서버 에러 (404, 500등)
    CBRequestResultCodeUnknown        // 알수없는 에러
} CBRequestResultCode;

/**
 JSON 통신 기본 포멧 wrapper
 
 - result : success/failure (성공/실패)
 - msg : 메시지, 일반적으로 에러가 발생했을때 활용
 - data : 필요한 리턴값
 - 예제
 {
 "result":"success",
 "msg":"성공했습니다.",
 "data":{
 "loginId":"macgyver"
 }
 }
 */

@interface CBJSONResult : NSObject

/** @name Properties */

/** 결과 - success/failure */
@property (nonatomic, strong) NSString *result;
/** 관련 메시지 */
@property (nonatomic, strong) NSString *msg;
/** 추가 데이터 */
@property (nonatomic, strong) NSDictionary *data;

/** @name initialize */

/**
 초기화
 @param JSON json 객체
 */
- (id)initWithJSON:(id)JSON;

@end
