//
//  UIViewController+Common.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

//MARK: - 自定义bar

- (void)customNavigationBar:(NSString *)title{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    navBar.backgroundColor = [UIColor colorWithRed:248 green:248 blue:255 alpha:1];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, CGRectGetWidth(self.view.frame), 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [navBar addSubview:lineLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 100)/2, 25, 100, 30)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.tintColor = [UIColor blackColor];
    [navBar addSubview:label];
    [self.view addSubview:navBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 25, 60, 30);
    [backButton setImage:Bundle_IMAGE(@"return_back") forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送短信
-(void)showSMSPicker:(MeetingInfo *)model{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            NSString *smsBody = [NSString stringWithFormat:@"让我们在会议中见吧，会议ID:%@；会议网址👉https://www.anyrtc.io/meetPlus/share/%@",model.meetingid,model.meetingid];
            
            picker.body=smsBody;
            
            [self presentViewController:picker animated:YES completion:nil];
            
        } else {
            [ASHUD showHUDWithCompleteStyleInView:self.view content:@"设备不支持短信功能" icon:nil];
        }
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送邮件
- (void)showEmailPicker:(MeetingInfo *)model{
    if (![MFMailComposeViewController canSendMail]) {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"设备未开启邮件服务" icon:nil];
        return;
    }
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"快来一起开会吧"];
    // 是否为HTML格式
    [mailCompose setMessageBody:@"" isHTML:NO];
    
    NSString *htmlStr = [NSString stringWithFormat:@"<html><body><p>会议ID：%@</p><p>会议网址：https://www.anyrtc.io/meetPlus/share/%@</p></body></html>",model.meetingid,model.meetingid];
    
    // 如使用HTML格式，则为以下代码
    [mailCompose setMessageBody:htmlStr isHTML:YES];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
