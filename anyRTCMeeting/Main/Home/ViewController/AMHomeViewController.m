//
//  AMHomeViewController.m
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMHomeViewController.h"

@interface AMHomeViewController ()<AMFunctionDelegate>

@property (nonatomic, strong) NSMutableArray *dateArr;

@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) UIRefreshControl *refreshControls;

@end

@implementation AMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    self.dateArr = [NSMutableArray arrayWithCapacity:20];
    self.listArr = [NSMutableArray arrayWithCapacity:20];
    
    AMFunctionView *functionView = [[AMFunctionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4)];
    functionView.delegate = self;
    self.tableView.tableHeaderView = functionView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [AMCommons getColor:@"#EBEBEB"];
    [AMUserManager registeredDockingMeeting:^{
        [weakSelf addRefreshControl];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMeetingList) name:ArrangeMeet_SUCESS object:nil];
}

- (void)addRefreshControl{
    self.refreshControls = [[UIRefreshControl alloc]init];
    [self.refreshControls addTarget:self action:@selector(getMeetingList) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControls];
    [self getMeetingList];
}

//获取会议列表
- (void)getMeetingList{
    WEAKSELF;
    [[AMApiManager shareInstance] getUserMeetingListWithPageNum:1 withPageSize:20 success:^(AMMeetListModel *model, int code) {
        if (code == 200) {
            [weakSelf.dateArr removeAllObjects];
            [weakSelf.listArr removeAllObjects];
            [weakSelf sorting:model.meetinglist];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [self.refreshControls endRefreshing];
}

//按日期排序
- (void)sorting:(NSArray *)arr {
    
    NSMutableArray *timeArr = [NSMutableArray arrayWithCapacity:20];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MeetingInfo class]]) {
            MeetingInfo *model = (MeetingInfo *)obj;
            [timeArr addObject:[AMCommons transformTimeStampString:model.m_start_time formate:@"yyyy年MM月dd日"]];
        }
    }];
    
    NSSet *set = [NSSet setWithArray:timeArr];
    NSArray *allArr = set.allObjects;
    //YES升序  NO 降序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES];
    [self.dateArr addObjectsFromArray:[allArr sortedArrayUsingDescriptors:@[descriptor]]];
    
    [self.dateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.listArr addObject:arr];
    }];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MeetingInfo classForKeyedArchiver]]) {
            MeetingInfo *model = (MeetingInfo *)obj;
            for (NSString *date in self.dateArr) {
                if ([date isEqualToString:[AMCommons transformTimeStampString:model.m_start_time formate:@"yyyy年MM月dd日"]]) {
                    NSMutableArray *arr = [self.listArr objectAtIndex:[self.dateArr indexOfObject:date]];
                    [arr addObject:model];
                }
            }
        }
    }];
    [self.tableView reloadData];
}

// MARK: - AMFunctionDelegate

- (void)functionEvent:(NSInteger)index{
    NSString *identify;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    !index ? (identify = @"AMMeet_JoinID") : (identify = @"AMMeet_ArrangeID");
    [self.navigationController pushViewController:[board instantiateViewControllerWithIdentifier:identify] animated:YES];
}

// MARK: - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arr = self.listArr[section];
    return arr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.text = [NSString stringWithFormat:@"  %@",self.dateArr[section]];
    label.textColor = [AMCommons getColor:@"#999999"];
    label.backgroundColor = [AMCommons getColor:@"#EBEBEB"];
    label.font = [UIFont systemFontOfSize:14.0];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMHomeCell *cell = (AMHomeCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeCellID" forIndexPath:indexPath];
    NSMutableArray *arr = self.listArr[indexPath.section];
    cell.listModel = (MeetingInfo *)arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMUser *user = [AMUserManager fetchUserInfo];
    
    AMUserModel *userModel = [[AMUserModel alloc] init];
    userModel.userId = user.openid;
    userModel.userName = user.nickname;
    userModel.userHeadUrl = user.headimgurl;
    
    NSMutableArray *arr = self.listArr[indexPath.section];
    MeetingInfo *model = (MeetingInfo *)arr[indexPath.row];
    
    AnyMeetVideoController *meetVc = [[AnyMeetVideoController alloc]init];
    meetVc.userModel = userModel;
    meetVc.meetModel = model;
    
    WEAKSELF;
    __weak AnyMeetVideoController *tempVideoController = meetVc;
    meetVc.uploadBlock = ^(NSArray *picArray) {
        [weakSelf uploadPics:picArray withController:tempVideoController];
    };
    [self.navigationController pushViewController:meetVc animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arr = self.listArr[indexPath.section];
    MeetingInfo *model = (MeetingInfo *)arr[indexPath.row];
    
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享会议" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    
    }];
    action0.backgroundColor = [UIColor grayColor];
    WEAKSELF;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除会议" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [[AMApiManager shareInstance] deleteMeetingRoom:model.meetingid success:^(int code) {
            [weakSelf getMeetingList];
        } failure:^(NSError *error) {
            
        }];
    }];
    action1.backgroundColor = [UIColor redColor];
    
    return @[action1,action0];
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

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:ArrangeMeet_SUCESS object:nil];
}

@end
