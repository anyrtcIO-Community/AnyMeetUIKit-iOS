//
//  AMCommons.h
//  anyRTCMeeting
//
//  Created by jh on 2018/6/5.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMCommons : NSObject

// 将16进制颜色转换成UIColor
+ (UIColor *)getColor:(NSString *)color;

//得到从1970年到现在的秒数
+(long)getSecondsSince1970;

//随机字符串
+ (NSString*)randomString:(int)len;

//时间格式  time 添加的时间
+ (NSString *)getCurrentTime:(NSInteger)time formate:(NSString *)formate;

//时间转时间戳
+ (NSString *)transformTimeStampString:(NSString *)time formate:(NSString *)formate;

//纯数字
+ (BOOL)validateNumber:(NSString*)number;

//获取uuid（卸载、升级,标识唯一）
+ (NSString *)getUUID;

+ (UIButton *)produceButton:(NSString *)title image:(NSString *)image;

@end
