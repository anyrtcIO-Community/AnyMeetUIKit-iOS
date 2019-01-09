//
//  AnyMeetUIKitConfig.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/11.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AnyMeetUIKitConfig.h"
#import <RTMeetEngine/AnyRTCMeetEngine.h>

static NSString *gDevelopId;
static NSString *gAppId;
static NSString *gKey;
static NSString *gToken;
static NSString *gVerifyUrl;
static BOOL gDebugLog = YES;

NSString *GetDevelopId() {
    return gDevelopId;
}
NSString *GetAppId() {
    return gAppId;
}
NSString *GetAppKey() {
    return gKey;
}
NSString *GetAppToken() {
    return gToken;
}
NSString *GetVerifyUrl() {
    return gVerifyUrl;
}
BOOL getDebugLog() {
    return gDebugLog;
}

@implementation AnyMeetUIKitConfig

+ (void)initEngineWithAnyRTCInfo:(NSString*)nsDevelopID andAppId:(NSString*)nsAppID andKey:(NSString*)nsKey andToke:(NSString*)nsToken andVerifyUrl:(NSString*)strVerifyUrl
{
    gDevelopId = nsDevelopID;
    gAppId = nsAppID;
    gKey = nsKey;
    gToken = nsToken;
    gVerifyUrl = strVerifyUrl;
    
    // 初始化视频库
    [AnyRTCMeetEngine initEngineWithAnyRTCInfo:nsDevelopID andAppId:nsAppID andKey:nsKey andToke:nsToken];
    
}

+ (void)configServerForPriCloud:(NSString*)nsSvrAddr andPort:(int)nSvrPort
{
    [AnyRTCMeetEngine configServerForPriCloud:nsSvrAddr andPort:nSvrPort];
}

+ (NSString*)getSdkVersion {
    return @"V2.1.3 2019-01-09";
}
+ (void)setDebugLogOpen:(BOOL)isDebugLogOpen {
    gDebugLog = isDebugLogOpen;
}
@end
