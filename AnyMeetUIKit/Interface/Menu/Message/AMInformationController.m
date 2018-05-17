//
//  AMInformationController.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMInformationController.h"
#import "AMInformationCell.h"

@implementation AMInformationController{
    UIView *_bottomView;    //底部视图
    
    UITableView *_tableView;
    
    UITextField *_textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [AMCommon getColor:@"#F2F4F6"];
    
    [self customNavigationBar:@"聊天消息"];
    [self initializeTable];
    //监听键盘
    [self observeKeyBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upateMessage) name:@"AnyMeetMessage_ChangeNotification" object:nil];
}

- (void)initializeTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 113) style:UITableViewStylePlain];
    _tableView.backgroundColor = [AMCommon getColor:@"#F2F4F6"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 80;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[AMInformationCell class] forCellReuseIdentifier:@"InformationCellID"];
    [self.view addSubview:_tableView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    //聊天框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 120, 49)];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.placeholder = @"  请输入聊天消息...";
    _textField.layer.borderColor = [AMCommon getColor:@"#DDDDDD"].CGColor;
    _textField.layer.borderWidth = 0.5;
    [_bottomView addSubview:_textField];
    [_textField addTarget:self action:@selector(messageMaxLimit:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    
    //发送
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 120, 0, 120, 49);
    sendButton.backgroundColor = [AMCommon getColor:@"#2797FF"];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendUserMessage) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:sendButton];
}

- (void)observeKeyBoard {
    //隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardTapClick)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardChange:(NSNotification *)notify{
    NSTimeInterval duration;
    [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    
    if (notify.name == UIKeyboardWillShowNotification ) {
        //键盘高度
        CGFloat keyboardY = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
        CGFloat high = CGRectGetHeight(self.view.frame) - 49 - keyboardY;
        
        [UIView animateWithDuration:duration animations:^{
            self->_bottomView.frame = CGRectMake(0, high, CGRectGetWidth(self.view.frame), 49);
            [self.view layoutIfNeeded];
        }];
        
    } else if (notify.name == UIKeyboardWillHideNotification) {
        
        [UIView animateWithDuration:duration animations:^{
            self->_bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)messageMaxLimit:(UITextField *)textField{
    if (textField.text.length > 256) {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"超过最大字数限制" icon:@""];
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 256)];
        return;
    }
}

- (void)upateMessage{
    [_tableView reloadData];
    [self scrollToBottom];
}

- (void)sendUserMessage{
    if (_textField.text.length != 0) {
        [_textField resignFirstResponder];
        AMInformationModel *model = [[AMInformationModel alloc]init];
        model.t_msg_content = [Base64Generater EncodedWithBase64:_textField.text];
        model.t_msg_u_name = self.userModel.userName;
        model.t_msg_u_icon = self.userModel.userHeadUrl;
        model.t_msg_userid = self.userModel.userId;
        [self.infoArr addObject:model];
        
        NSTimeInterval time =[[NSDate date] timeIntervalSince1970];
        long second = time;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"mType",[Base64Generater EncodedWithBase64:_textField.text],@"mContent",[NSNumber numberWithLong:second],@"mTime",nil];
        [self.meetKit sendUserMessage:self.userModel.userName andUserHeader:self.userModel.userHeadUrl andContent:[dic mj_JSONString]];
        _textField.text = @"";
        [_tableView reloadData];
    }
    [self scrollToBottom];
}

- (void)scrollToBottom {
    //滑动最底部
    if (self.infoArr.count > 1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.infoArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)hideKeyBoardTapClick{
    [_textField resignFirstResponder];
}

# pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        return NO;
    }
    [self sendUserMessage];
    return YES;
}

# pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMInformationCell *cell = (AMInformationCell *) [tableView dequeueReusableCellWithIdentifier:@"InformationCellID"];
    [cell updateInfoModel:(AMInformationModel *)self.infoArr[indexPath.row] userId:self.userModel.userId];
    return cell;
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

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"AnyMeetMessage_ChangeNotification" object:nil];
}


@end
