//
//  AMUserManager.h
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMUserManager : NSObject <WXApiDelegate>

+ (instancetype)sharedInstance;

//微信授权登录
+ (void)sendAuthRequest;

//保存用户信息
+ (BOOL)saveAccountInformation:(AMUser *)user;

//删除用户信息
+ (BOOL)deleteAccountInformation;

//获取用户信息
+ (AMUser *)fetchUserInfo;

//是否登录
+ (BOOL)isLogin;

//用户对接
+ (void)registeredDockingMeeting:(void (^)(void))sucess;

@end
