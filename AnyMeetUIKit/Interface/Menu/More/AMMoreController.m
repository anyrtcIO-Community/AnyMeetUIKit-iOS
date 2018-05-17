//
//  AMMoreController.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMMoreController.h"

@interface AMMoreController ()

@end

@implementation AMMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
    }];
    
    //提示音
    UISwitch *voiceSwitch = [[UISwitch alloc] init];
    [voiceSwitch setOn:[[NSUserDefaults.standardUserDefaults objectForKey:Music_Tip] boolValue]];
    [bottomView addSubview:voiceSwitch];
    [voiceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [voiceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.bottom.equalTo(@(-30));
    }];
    
    UILabel *voiceLabel = [[UILabel alloc]init];
    voiceLabel.text = @"进出会议室播放提示音";
    voiceLabel.font = [UIFont systemFontOfSize:17];
    voiceLabel.textColor = [AMCommon getColor:@"#4C5362"];
    [bottomView addSubview:voiceLabel];
    [voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(voiceSwitch.mas_left).equalTo(@(20));
        make.centerY.equalTo(voiceSwitch.mas_centerY);
        //.....
        make.top.equalTo(@(30));
    }];
//
//    //锁
//    UISwitch *lockSwitch = [[UISwitch alloc] init];
//    lockSwitch.on = YES;
//    [bottomView addSubview:lockSwitch];
//    [lockSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [lockSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@(-20));
//        make.bottom.equalTo(voiceSwitch.mas_top).offset(-30);
//        make.top.equalTo(bottomView).offset(30);
//    }];
//
//    UILabel *lockLabel = [[UILabel alloc]init];
//    lockLabel.font = [UIFont systemFontOfSize:17];
//    lockLabel.text = @"会议加锁";
//    lockLabel.textColor = [AMCommon getColor:@"#4C5362"];
//    [bottomView addSubview:lockLabel];
//    [lockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(20));
//        make.top.equalTo(@(30));
//        make.right.equalTo(lockSwitch.mas_left).equalTo(@(20));
//        make.centerY.equalTo(lockSwitch.mas_centerY).offset(-10);
//    }];
//
//    UILabel *tipLabel = [[UILabel alloc]init];
//    tipLabel.font = [UIFont systemFontOfSize:12];
//    tipLabel.text = @"会议一旦加锁，将不能有参与者进入会议";
//    tipLabel.textColor = [AMCommon getColor:@"#999999"];
//    [bottomView addSubview:tipLabel];
//    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(20));
//        make.right.equalTo(lockSwitch.mas_left).equalTo(@(-20));
//        make.centerY.equalTo(lockSwitch.mas_centerY).offset(10);
//    }];
}

- (void)switchAction:(UISwitch *)sender{
    [NSUserDefaults.standardUserDefaults setObject:[NSNumber numberWithBool:sender.isOn] forKey:Music_Tip];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if ( point.y < UIScreen.mainScreen.bounds.size.height - 85.5) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
