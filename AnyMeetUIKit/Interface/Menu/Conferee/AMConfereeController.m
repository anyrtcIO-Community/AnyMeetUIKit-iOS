//
//  AMConfereeController.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMConfereeController.h"
#import "AMConfereeCell.h"
#import "AMInformationController.h"

@interface AMConfereeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AMConfereeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNavigationBar:@"参会人员"];
    [self initializeTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshConferee) name:@"AnyMeetConferee_ChangeNotification" object:nil];
}

- (void)initializeTable{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 128) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 80;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AMConfereeCell class] forCellReuseIdentifier:@"AMConfereeCellID"];
    [self.view addSubview:self.tableView];
    
    NSArray *arr = @[@"聊天消息",@"邀请参会"];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        infoButton.frame = CGRectMake(20 + 110 * i, CGRectGetHeight(self.view.frame) - 48, 100, 32);
        infoButton.layer.borderWidth = 0.5;
        [infoButton setTitle:arr[i] forState:UIControlStateNormal];
        [infoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        infoButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        infoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [infoButton addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:infoButton];
    }
}

- (void)doSomethingEvent:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"聊天消息"]) {
        AMInformationController *messageVc = [[AMInformationController alloc]init];
        messageVc.meetKit = self.meetKit;
        messageVc.isLandscape = self.isLandscape;
        messageVc.infoArr = self.infoArr;
        messageVc.userModel = self.userModel;
        [self presentViewController:messageVc animated:YES completion:nil];
    } else {
        
        [UIAlertController showActionSheetInViewController:self withTitle:@"邀请参会" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"发送邮件",@"发送短信",@"复制链接"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex != 4 && buttonIndex != 0) {
                (buttonIndex == 2) ? ([self showEmailPicker]) : ([self showSMSPicker]);
            } else {
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = @"AnyMeetUIKit";
            }
        }];
    }
}

- (void)refreshConferee{
    
    [self.tableView reloadData];
}

# pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memberArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMConfereeCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AMConfereeCellID"];
    cell.confereeModel = self.memberArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMConfereeModel *model = self.memberArr[indexPath.row];
    
    NSString *video = @"";
    NSString *audio = @"";
    model.audio_state ? (audio = @"关闭语音") : (audio = @"打开语音");
    model.video_state ? (video = @"关闭视频") : (video = @"打开视频");
    
    if ([model.peerId isEqualToString:Video_MySelf]) {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"对自己操作不可用" icon:@""];
        return;
    }
    
    if (self.isHoster) {
        [UIAlertController showActionSheetInViewController:self withTitle:model.nickName message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[audio,video,@"踢出会议"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 2:
                    //音频
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"mType",[NSNumber numberWithInt:0],@"type",[NSNumber numberWithInt:!model.audio_state],@"state",model.userId,@"userid",nil];
                    [self.meetKit sendUserMessage:self.userModel.userName andUserHeader:@"" andContent:[dic mj_JSONString]];
                    model.audio_state = !model.audio_state;
                    [self.tableView reloadData];
                }
                    break;
                case 3:
                    //视频
                {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"mType",[NSNumber numberWithInt:1],@"type",[NSNumber numberWithInt:!model.video_state],@"state",model.userId,@"userid",nil];
                    [self.meetKit sendUserMessage:self.userModel.userName andUserHeader:@"" andContent:[dic mj_JSONString]];
                    model.video_state = !model.video_state;
                    [self.tableView reloadData];
                }
                    break;
                case 4:
                    //踢人
                {
                    NSString *tip = [NSString stringWithFormat:@"确认将 %@ 踢出?",model.nickName];
                    [UIAlertController showAlertInViewController:self withTitle:tip message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"踢出"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if (buttonIndex == 2) {
                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"mType",model.userId,@"userid",nil];
                            [self.meetKit sendUserMessage:self.userModel.userName andUserHeader:@"" andContent:[dic mj_JSONString]];
                            [self.memberArr removeObject:model];
                            [self.tableView reloadData];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (BOOL) shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.isLandscape) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"AnyMeetConferee_ChangeNotification" object:nil];
}

@end
