//
//  FFColorHelper.h
//  FormularLib
//
//  Created by 장재휴 on 12. 11. 16..
//  Copyright (c) 2012년 장재휴. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Color Convert Helper
 */
@interface FFColorHelper : NSObject

/** @name hex convert */

/**
 HTML hex color 변환
 
 예제
 
 htmlHexColor(@"#505050")
 
 @param htmlColor html rgb값
 */
+ (UIColor *)htmlHexColor:(NSString *)htmlColor;
/**
 alpha값이 255인 rgb값을 hex로 표현
 
 예제
 
 opaqueHexColor(0x505050)
 
 @param c rgb값
 
 - 1~2 : red값(00~FF)
 - 3~4 : green값(00~FF)
 - 5~6 : blue값(00~FF)
 */
+ (UIColor *)opaqueHexColor:(int)c;
/**
 argb값을 hex로 표현
 
 예제
 
 hexColor(0xFF505050)
 
 @param c argb값
 
 - 1~2 : alpha값(00~FF)
 - 3~4 : red값(00~FF)
 - 5~6 : green값(00~FF)
 - 7~8 : blue값(00~FF)
 */
+ (UIColor *)hexColor:(int)c;
/**
 rgba값을 hex와 alpha로 표현
 
 예제
 
 hexColor(0xFF505050)
 
 @param c rgb값
 
 - 1~2 : red값(00~FF)
 - 3~4 : green값(00~FF)
 - 5~6 : blue값(00~FF)
 
 @param a alpha값(0~255)
 */
+ (UIColor *)hexColor:(int)c withAlpha:(int)a;

/** @name rgb convert */

/**
 rgb 변환
 @param r red(0~255)
 @param g green(0~255)
 @param b green(0~255)
 */
+ (UIColor *)convert:(int)r g:(int)g b:(int)b;
/**
 rgba 변환
 @param r red(0~255)
 @param g green(0~255)
 @param b green(0~255)
 @param a alpha(0~255)
 */
+ (UIColor *)convert:(int)r g:(int)g b:(int)b a:(int)a;

@end