//
//  ATSignInController.m
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "ATSignInController.h"

@implementation ATSignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
        [self.loginButton setTitle:@"快速登录" forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}

- (IBAction)doSomethingEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
                //微信请求
                [AMUserManager sendAuthRequest];
            } else {
                //快速登录
                AMUser *userModel = [[AMUser alloc] init];
                userModel.openid = [AMCommons getUUID];
                userModel.nickname = [AMCommons randomString:4];
                userModel.headimgurl = @"";
                if ([AMUserManager saveAccountInformation:userModel]) {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIApplication.sharedApplication.keyWindow.rootViewController = [board instantiateViewControllerWithIdentifier:@"AMMeet_HomeID"];
                }
            }
            break;
        case 101:
        {
            NSString*url =@"https://www.anyrtc.io";
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        }
            break;
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
