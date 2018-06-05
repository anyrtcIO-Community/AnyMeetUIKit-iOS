//
//  AMJoinViewController.m
//  anyRTCMeeting
//
//  Created by jh on 2018/6/1.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMJoinViewController.h"

@interface AMJoinViewController ()

@property (weak, nonatomic) IBOutlet UITextField *meetIdTextField;

@end

@implementation AMJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入会议";
    
    UIButton *backButton = [AMCommons produceButton:@"" image:@"return_back"];
    [backButton addTarget:self action:@selector(popToPrevious) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *leftButton = [AMCommons produceButton:@"" image:@"icon_会议名称"];
    self.meetIdTextField.leftView = leftButton;
    self.meetIdTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)popToPrevious{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doSomethingEvent:(id)sender {
    //获取会议详情
    if (self.meetIdTextField.text.length != 8 || ![AMCommons validateNumber:self.meetIdTextField.text]) {
        [XHToast showCenterWithText:@"会议号ID错误"];
        return;
    }
    
    WEAKSELF;
    [[AMApiManager shareInstance] getMeetingInfo:self.meetIdTextField.text success:^(AMMeetInfoModel *model, int code) {
        
        (code == 200) ? ([weakSelf joinMeetingRoom:model.meetinginfo]) : ([XHToast showCenterWithText:[[AMApiManager shareInstance] getErrorInfoWithCode:code]]);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)joinMeetingRoom:(MeetingInfo *) model{
    NSLog(@"--------%@---------%@",AMApiManager.shareInstance.anyUserId,model.m_userid);
    if (!model.m_is_lock || [model.m_userid isEqualToString:AMApiManager.shareInstance.anyUserId]) {
        AMUserModel *userModel = [[AMUserModel alloc] init];
        AMUser *user = AMUserManager.fetchUserInfo;
        userModel.userId = user.openid;
        userModel.userHeadUrl = user.headimgurl;
        userModel.userName = user.nickname;
        
        AnyMeetVideoController *meetVc = [[AnyMeetVideoController alloc]init];
        meetVc.userModel = userModel;
        meetVc.meetModel = model;
        __weak typeof(self)weakSelf = self;
        __weak AnyMeetVideoController *tempVideoController = meetVc;
        meetVc.uploadBlock = ^(NSArray *picArray) {
            [weakSelf uploadPics:picArray withController:tempVideoController];
        };
        [self.navigationController pushViewController:meetVc animated:YES];
    }
}

- (void)uploadPics:(NSArray*)picArray withController:(AnyMeetVideoController*)controller {
    //    //选择图片（并上传，这里不再上传，自己上传自己的业务服务器）eg:假设已经上传成功
    NSArray *picArrayEg = @[@"http://h.hiphotos.baidu.com/image/pic/item/a5c27d1ed21b0ef48c509cecd1c451da80cb3ec3.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/f11f3a292df5e0fe2a436547506034a85edf7219.jpg"];
    // 图片在自己服务器中的ID
    NSString *fileId = @"12212121212";
    
    if (controller) {
        [controller gotoShearPics:picArrayEg withFileId:fileId];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
