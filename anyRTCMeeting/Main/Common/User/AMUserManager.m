//
//  AMUserManager.m
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMUserManager.h"

@implementation AMUserManager

+ (instancetype)sharedInstance {
    static AMUserManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AMUserManager alloc]init];
    });
    return instance;
}

+ (void)sendAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * res = (SendAuthResp *)resp;
        [self getAccess_token:res.code];
    }
}

//获取access_token
- (void)getAccess_token:(NSString *)code {
    WEAKSELF;
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",weixinAppID,weixinAppSecret,code];
    [AMNetWorkTool.shareInstance getWithURLString:url parameters:nil success:^(NSDictionary *dictionary) {
        [weakSelf getUserinfo:dictionary[@"access_token"] openid:dictionary[@"openid"]];
    } failure:^(NSError *error) {
        
    }];
}

//获取用户信息
- (void)getUserinfo:(NSString *)access_token openid:(NSString *)openid{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    [AMNetWorkTool.shareInstance getWithURLString:url parameters:nil success:^(NSDictionary *dictionary) {
        if (dictionary != nil) {
            AMUser *user = [AMUser mj_objectWithKeyValues:dictionary];
            if ([AMUserManager saveAccountInformation:user]) {
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIApplication.sharedApplication.keyWindow.rootViewController = [board instantiateViewControllerWithIdentifier:@"AMMeet_HomeID"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (BOOL)saveAccountInformation:(AMUser *)user{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userAccount.data"];
    return [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

+ (BOOL)deleteAccountInformation{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userAccount.data"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return  [manager removeItemAtPath:filePath error:nil];
    }
    return  NO;
}

+ (AMUser *)fetchUserInfo{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userAccount.data"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)isLogin{
    return AMUserManager.fetchUserInfo != nil;
}

+ (void)registeredDockingMeeting:(void (^)(void))sucess fail:(void (^)(void))fail{
    AMUserModel *model = [[AMUserModel alloc] init];
    AMUser *user = self.fetchUserInfo;
    model.userId = user.openid;
    model.userHeadUrl = user.headimgurl;
    model.userName = user.nickname;
    
    [[AMApiManager shareInstance]registeredDockingMeeting:model success:^(int code) {
        if (code == 200) {
            if (sucess) {
                sucess();
            }
        }
    } failure:^(NSError *error) {
        if (fail) {
            fail();
        }
    }];
}

@end
