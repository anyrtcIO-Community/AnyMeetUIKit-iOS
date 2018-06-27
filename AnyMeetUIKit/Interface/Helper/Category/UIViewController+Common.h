//
//  UIViewController+Common.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>

@interface UIViewController (Common)<MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>

// 自定义Bar
- (void)customNavigationBar:(NSString *)title;

//发短信
-(void)showSMSPicker:(MeetingInfo *)model;

//发邮件
- (void)showEmailPicker:(MeetingInfo *)model;

@end
