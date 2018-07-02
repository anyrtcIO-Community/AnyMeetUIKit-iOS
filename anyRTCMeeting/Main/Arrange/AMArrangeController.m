//
//  AMArrangeController.m
//  anyRTCMeeting
//
//  Created by jh on 2018/6/1.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMArrangeController.h"

@interface AMArrangeController ()

@property (weak, nonatomic) IBOutlet UITextField *meetNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *padding;

@property (weak, nonatomic) IBOutlet UIView *pickerView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
//记录选择的时间
@property (nonatomic, assign) long dateRecord;

@end

@implementation AMArrangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安排会议";
    self.padding.constant = - SCREEN_HEIGHT;
    
    UIButton *backButton = [AMCommons produceButton:@"" image:@"return_back"];
    [backButton addTarget:self action:@selector(popToPrevious) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *leftButton = [AMCommons produceButton:@"" image:@"icon_会议名称"];
    self.meetNameTextField.leftView = leftButton;
    self.meetNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.dateButton addTarget:self action:@selector(selectMeetingTime) forControlEvents:UIControlEventTouchUpInside];
    
    self.dateRecord = [AMCommons getSecondsSince1970] + 300;
    [self.dateButton setTitle:[AMCommons getCurrentTime:300 formate:@"yyyy年MM月dd日 HH:mm:ss"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    [self.pickerView addGestureRecognizer:tap];
    
    self.datePicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:300];
    self.datePicker.locale= [NSLocale localeWithLocaleIdentifier:@"zh"];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
}

- (void)popToPrevious{
    [self.navigationController popViewControllerAnimated:YES];
}

//安排会议
- (IBAction)arrangeMeeting:(id)sender {
    if (self.meetNameTextField.text.length == 0) {
        [XHToast showCenterWithText:@"会议名称不能为空"];
        return;
    }
    
    //大于5分钟
    if (self.dateRecord - [AMCommons getSecondsSince1970] < 300) {
        self.dateRecord = [AMCommons getSecondsSince1970] + 300;
    }
    WEAKSELF;
    NSString *startTime = [AMCommons transformTimeStampString:[NSString stringWithFormat:@"%ld",self.dateRecord] formate:@"yyyy-MM-dd HH:mm:ss"];
    [[AMApiManager shareInstance] createMeetingRoom:self.meetNameTextField.text withMeetType:AMMeetTypeNomal withMeetStartTime:startTime withPassWord:@"" withLimitType:AMMeetLimitOpenType withDefaultPersonList:nil success:^(int code) {
        if (code == 200) {
            [XHToast showCenterWithText:@"安排会议成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ArrangeMeet_SUCESS object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [XHToast showCenterWithText:[[AMApiManager shareInstance] getErrorInfoWithCode:code]];
        }
    } failure:^(NSError *error) {
        [XHToast showCenterWithText:@"网络异常"];
    }];
}

- (void)datePickerValueChanged:(UIDatePicker *)picker{
    NSDate *select = [picker date];
    
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    
    selectDateFormatter.dateFormat = @"YYYY年MM月dd日 HH:mm:ss";
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",[selectDateFormatter stringFromDate:select]];
    [self.dateButton setTitle:dateStr forState:UIControlStateNormal];
    
    self.dateRecord = [select timeIntervalSince1970];
}

- (void)hidePicker{
    self.padding.constant = - SCREEN_HEIGHT;
}

- (void)selectMeetingTime{
    [self.meetNameTextField resignFirstResponder];
    self.padding.constant = 0;
}

@end
