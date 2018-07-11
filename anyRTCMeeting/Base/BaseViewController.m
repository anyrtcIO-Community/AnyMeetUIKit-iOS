//
//  BaseViewController.m
//  anyRTCMeeting
//
//  Created by jh on 2018/7/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backButton = [AMCommons produceButton:@"" image:@"return_back"];
    [backButton addTarget:self action:@selector(popToPrevious) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UITapGestureRecognizer *keyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAllKeyBoard)];
    [self.view addGestureRecognizer:keyTap];
}

- (void)hideAllKeyBoard{
    [AMCommons hideKeyBoard];
}

- (void)popToPrevious{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
