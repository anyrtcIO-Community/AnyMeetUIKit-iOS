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
}

- (IBAction)doSomethingEvent:(id)sender {
    [AMUserManager sendAuthRequest];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
