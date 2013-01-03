//
//  FFLocalizationHelper.h
//  FormularLib
//
//  Created by 인식 조 on 12. 11. 14..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 로컬라이징 helper
 기본적으로 로컬라이징의 경우 NSLocalizedString을 그대로 사용하고
 이미 ios내에 등록된것을 사용하는 경우에만 사용
 /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk/System/Library/Frameworks/UIKit.framework를 참고
 */
@interface FFLocalizationHelper : NSObject

/**
 UIKit.framework에 등록된 로컬라이징을 가져옴
 @param key 키값
 */
+ (NSString *)getAppleLocalizableLanguage:(NSString *)key;
@end
