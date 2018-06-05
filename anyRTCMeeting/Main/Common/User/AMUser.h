//
//  AMUser.h
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMUser : NSObject<NSCoding>

//普通用户的标识，对当前开发者帐号唯一
@property (nonatomic, copy) NSString *openid;

@property (nonatomic, copy) NSString *nickname;
//1为男性，2为女性
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *headimgurl;
//用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的
@property (nonatomic, copy) NSString *unionid;

@end
