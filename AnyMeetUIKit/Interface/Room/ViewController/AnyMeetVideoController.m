//
//  AnyMeetVideoController.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/27.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AnyMeetVideoController.h"
#import <AVFoundation/AVFoundation.h>
//画板
#import "AMDocBlockView.h"

@interface AnyMeetVideoController ()<RTMeetKitDelegate,AnyRTCUserShareBlockDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) RTMeetKit *meetKit;
//消息
@property (nonatomic, strong) NSMutableArray *infoArr;
//参会人员
@property (nonatomic, strong) NSMutableArray *memberArr;
//自己
@property (nonatomic, strong) AMConfereeModel *confereeModel;
//画板
@property (nonatomic, strong) AMDocBlockView *boardView;

@end

@implementation AnyMeetVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.infoArr = [NSMutableArray arrayWithCapacity:20];
    self.memberArr = [NSMutableArray arrayWithCapacity:20];
    self.confereeModel = [self produceConferee:self.userModel.userName userId:self.userModel.userId peerId:Video_MySelf icon:self.userModel.userHeadUrl];
    
    [self.memberArr addObject:self.confereeModel];
    
    [self itializationMeetKit];
}

- (void)itializationMeetKit{
    //配置
    RTMeetOption *option = [RTMeetOption defaultOption];
    option.videoLayOut = RTC_V_1X3;
    option.videoScreenOrientation = RTMPC_SCRN_Auto;
    option.videoMode = RTCMeet_Videos_SD;
    //实例化会议对象
    self.meetKit = [[RTMeetKit alloc] initWithDelegate:self andOption:option];
    self.meetKit.delegate = self;
    
    //本地视频采集窗口
    [self.meetKit setLocalVideoCapturer:self.localView];
    
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userModel.userName,@"nickName",nil];
    NSString *customStr = [AMCommon fromDicToJSONStr:customDict];
    //加入会议
    [self.meetKit joinRTC:self.meetModel.meetinginfo.meetingid andIsHoster:NO andUserId:self.userModel.userId andUserData:customStr];
}
#pragma mark- 离开会议
- (void)leaveMeet{
    [self.meetKit leaveRTC];
    [self.navigationController popViewControllerAnimated:YES];
    //多层级模态返回
    if ([AMCommon topViewController] != self) {
        UIViewController *rootVc = [AMCommon topViewController].presentingViewController;
        while (rootVc.presentingViewController) {
            rootVc = rootVc.presentingViewController;
        }
        [rootVc dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - AMTabBarDelegate

- (void)tabBardidSelectItem:(UIButton *)button{
    //延迟隐藏时间
    [self hideControlDelay];
    switch (button.tag) {
        case 0:
            //语音
            self.confereeModel.audio_state = !button.selected;
            [self.meetKit setLocalAudioEnable:!button.selected];
            break;
        case 1:
            //视频
            self.confereeModel.video_state = !button.selected;
            [self.meetKit setLocalVideoEnable:!button.selected];
            break;
        case 2:
            //文档
        {
            if (self.shearType == AMSharedTypeScreen && self.sharedView) {
                self.sharedView.hidden = !self.sharedView.hidden;
                [self.meetKit setDriveModel:!self.sharedView.hidden];
            }
            
            if (self.boardView) {
                self.boardView.hidden = !self.boardView.hidden;
                [self.meetKit setDriveModel:!self.boardView.hidden];
            }
            
            if (self.shearType == AMSharedTypeNone) {
                [self.meetKit canShareUser:1];
            }
        }
            break;
        case 3://人员
        {
            AMConfereeController *confereeVc = [[AMConfereeController alloc]init];
            confereeVc.meetKit = self.meetKit;
            confereeVc.infoArr = self.infoArr;
            confereeVc.memberArr = self.memberArr;
            confereeVc.userModel = self.userModel;
            confereeVc.isLandscape = self.isLandscape;
            ([self.meetModel.meetinginfo.m_userid isEqualToString:self.userModel.userId]) ? confereeVc.isHoster = YES : 0;
            [self presentViewController:confereeVc animated:YES completion:nil];
        }
            break;
        case 4:
            //更多
        {
            AMMoreController *moreVc = [[AMMoreController alloc]init];
            moreVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:moreVc animated:NO completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - AMTopToolDelegate

- (void)topBarDidSelectItem:(UIButton *)button{
    if (button.tag == 201) {
        if (self.shearType == AMSharedTypeMySelfDoc) {
            [self.meetKit closeUserShare];
            if (self.boardView) {
                [self.boardView removeFromSuperview];
                self.boardView = nil;
            }
        } else {
            [self leaveMeet];
        }
    } else {
        //延迟隐藏时间
        [self hideControlDelay];
        (button.tag == 200) ? ([self.meetKit setSpeakerOn:!button.selected]) : ([self.meetKit switchCamera]);
    }
}

- (void)gotoShearPics:(NSArray*)picArray withFileId:(NSString*)fileId {
 
    //fileId如果没有传入过来，给一个随机的
    fileId = fileId?fileId:[AMCommon randomString:12];
    if (picArray.count != 0) {
        NSDictionary *fileDic = [[NSDictionary alloc]initWithObjectsAndKeys:fileId,@"fileid",self.meetModel.meetinginfo.meetingid,@"meetid",picArray,@"picArray", nil];
        [self.meetKit openUserShareInfo:[AMCommon fromDicToJSONStr:fileDic]];
        
        //先置空
        if (self.boardView) {
            if (self.boardView.superview) {
                [self.boardView removeFromSuperview];
            }
            self.boardView = nil;
        }
        AMDocItem *docItem = [[AMDocItem alloc] init];
        docItem.fildId = fileId;
        docItem.meetingId = self.meetModel.meetinginfo.meetingid;
        docItem.urlArray = [picArray copy];
        
        self.boardView = [[AMDocBlockView alloc] initWithDoc:self.userModel withHost:YES withDocItem:docItem];
        __weak typeof(self)weakSelf = self;
        self.boardView.docBlockFial = ^(NSString *errorStr) {
            [weakSelf.meetKit closeUserShare];
            [ASHUD showHUDWithCompleteStyleInView:weakSelf.view content:errorStr icon:nil];
        };
        self.boardView.toolShowBlock = ^{
            [weakSelf interfaceAnimation];
        };
        [self.view addSubview:self.boardView];
        [self.view insertSubview:self.boardView belowSubview:self.topBar];
        [self.boardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.shearType = AMSharedTypeMySelfDoc;
        [self.topBar.leaveButton setTitle:@"退出共享" forState:UIControlStateNormal];
        [self.tabbar tabBarDidShared:YES];
    }
}

#pragma mark - RTMeetKitDelegate
- (void)onRTCJoinMeetOK:(NSString*)strAnyRTCId{
    //加入会议成功的回调
    [self.view addSubview:self.tabbar];
    [self hideControlDelay];
    
    //进会
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4],@"mType",self.userModel.userId,@"userid",self.userModel.userName,@"name",nil];
    [self.meetKit sendUserMessage:self.userModel.userName andUserHeader:nil andContent:[dic mj_JSONString]];
    
    [self playRemindMusic];
    
    self.topBar.titleLabel.text = self.meetModel.meetinginfo.meetingid;
}

- (void)onRTCJoinMeetFailed:(NSString*)strAnyRTCId withCode:(int)nCode{
    //加入会议室失败的回调
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[AMCommon joinMeetingError:nCode] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        [self leaveMeet];
    }];
    [alertController addAction:closeButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onRTCLeaveMeet:(int)nCode{
    //离开会议的回调
}

-(void)onRTCOpenVideoRender:(NSString*)strRTCPeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString*)strUserId withUserData:(NSString*)strUserData{
    //其他与会者视频接通回调(音视频)
    if (self.sharedView) {
        //共享屏幕流
        if ([self.sharedView.strPubId isEqualToString:strRTCPubId]) {
            return;
        }
    }
    
    AMVideoView *video = [AMVideoView loadVideoWithpeerId:strRTCPeerId pubId:strRTCPubId size:CGSizeZero];
    [self.videoArr addObject:video];
    [self.meetKit setRTCVideoRender:strRTCPubId andRender:video.localView];
    
    //参会者
    
    BOOL isFind = NO;
    NSDictionary *dict = [AMCommon fromJsonStr:strUserData];
    for (AMConfereeModel *confereeModel in self.memberArr) {
        if ([confereeModel.peerId isEqualToString:strRTCPeerId]) {
            confereeModel.userId = strUserId;
            confereeModel.headUrl = [dict objectForKey:@"headUrl"];
            confereeModel.nickName = [dict objectForKey:@"nickName"];
            isFind = YES;
            break;
        }
    }
    
    if (!isFind) {
        AMConfereeModel *confereeModel = [self produceConferee:[dict objectForKey:@"nickName"] userId:strUserId peerId:strRTCPeerId icon:[dict objectForKey:@"headUrl"]];
        [self.memberArr addObject:confereeModel];
    }
    [NSNotificationCenter.defaultCenter postNotificationName:@"AnyMeetConferee_ChangeNotification" object:self.memberArr];
}

-(void)onRTCCloseVideoRender:(NSString*)strRTCPeerId withRTCPubId:(NSString *)strRTCPubId withUserId:(NSString*)strUserId{
    //共享屏幕流
    if (self.sharedView) {
        if ([self.sharedView.strPubId isEqualToString:strRTCPubId]) {
            return;
        }
    }
    
    //当离开者为大屏时，将自身切换为大屏
    UIView *currentView = [self.view viewWithTag:1000];
    if ([currentView isKindOfClass:[AMVideoView class]]) {
        AMVideoView *largeView = (AMVideoView *)currentView;
        if ([largeView.strPubId isEqualToString:strRTCPubId]) {
            [largeView removeFromSuperview];
            [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj == self.localView) {
                    UIView *videoView = (UIView *)obj;
                    videoView.tag = 1000;
                    [self.view insertSubview:videoView atIndex:0];
                    [self switchVideoRender:videoView];
                    [self.videoArr removeObjectAtIndex:idx];
                    [self layoutVideoView];
                    *stop = YES;
                }
            }];
        }
    }
    
    //移除离开者参会者视图
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AMVideoView class]]) {
            AMVideoView *video = (AMVideoView *)obj;
            if ([video.strPubId isEqualToString:strRTCPubId]) {
                [self.videoArr removeObject:video];
                [video removeFromSuperview];
                [self layoutVideoView];
                *stop = YES;
            }
        }
    }];
    
    //移除参会人员列表
    [self.memberArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMConfereeModel *confereeModel = (AMConfereeModel * )obj;
        if ([confereeModel.userId isEqualToString:strUserId]) {
            [self.memberArr removeObject:confereeModel];
            *stop = YES;
        }
    }];
    
    //发送刷新参会列表通知
    [NSNotificationCenter.defaultCenter postNotificationName:@"AnyMeetConferee_ChangeNotification" object:self.memberArr];
}

- (void)onRTCAVStatus:(NSString*)strRTCPeerId withAudio:(BOOL)bAudio withVideo:(BOOL)bVideo{
    //其他与会者对音视频的操作的回调（比如对方关闭了音频，对方关闭了视频）
    BOOL isFind = NO;
    for (AMConfereeModel *confereeModel in self.memberArr) {
        if ([confereeModel.peerId isEqualToString:strRTCPeerId]) {
            confereeModel.video_state = bVideo;
            confereeModel.audio_state = bAudio;
            isFind = YES;
            break;
        }
    }
    
    if (!isFind) {
        AMConfereeModel *model = [self produceConferee:@"" userId:@"" peerId:strRTCPeerId icon:@""];
        model.audio_state = bAudio;
        model.video_state = bVideo;
        [self.memberArr addObject:model];
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"AnyMeetConferee_ChangeNotification" object:self.memberArr];
}

- (void)onRTCAudioActive:(NSString*)strRTCPeerId withUserId:(NSString *)strUserId withShowTime:(int)nTime{
    //RTC音频检测
}

- (void)onRTCViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size{
    if (self.sharedView.localView == videoView) {
        //屏幕共享流size
        self.sharedView.videoSize = size;
        [self makeResolution:[NSMutableArray arrayWithObject:self.sharedView] itemWidth:UIScreen.mainScreen.bounds.size.width itemHeight:UIScreen.mainScreen.bounds.size.height fill:NO];
        return;
    }
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AMVideoView class]]) {
            AMVideoView *video = (AMVideoView *)obj;
            if (videoView == video.localView) {
                video.videoSize = size;
                [self layoutVideoView];
                *stop = YES;
            }
        }
    }];
}

- (void)onRTCUserMessage:(NSString*)strUserId withUserName:(NSString*)strUserName withUserHeader:(NSString*)strUserHeaderUrl withContent:(NSString*)strContent{
    NSDictionary *dic = [AMCommon fromJsonStr:strContent];
    switch ([[dic objectForKey:@"mType"] intValue]) {
        case 0:
            //普通消息
            [self.infoArr addObject:[self produceTextInfo:strUserName content:[dic objectForKey:@"mContent"] userId:strUserId icon:strUserHeaderUrl]];
            [NSNotificationCenter.defaultCenter postNotificationName:@"AnyMeetMessage_ChangeNotification" object:self.infoArr];
            break;
        case 1://关闭音视频
        {
            NSString *userId = [dic objectForKey:@"userid"];
            BOOL type = (BOOL)[[dic objectForKey:@"type"] intValue];
            BOOL state = (BOOL)[[dic objectForKey:@"state"] intValue];
            if ([userId isEqualToString:self.userModel.userId]) {
                type ? ([self.meetKit setLocalVideoEnable:state]) : ([self.meetKit setLocalAudioEnable:state]);
            }
        }
            break;
        case 2://踢出
        {
            if (![[dic objectForKey:@"userid"] isEqualToString:self.userModel.userId]) {
                [self leaveMeet];
            }
        }
            break;
        case 4:
            //进会消息
            if ([[NSUserDefaults.standardUserDefaults objectForKey:Music_Tip] boolValue]) {
                [self playRemindMusic];
            }
            break;
        default:
            break;
    }
}

#pragma mark - AnyRTCWriteBlockDelegate
- (void)onRTCCanUseShareEnableResult:(BOOL)scuess{
    //判断是否可以开启共享
    if (scuess) {
        [UIAlertController showActionSheetInViewController:self withTitle:@"共享" message:nil cancelButtonTitle:@"取消选择" destructiveButtonTitle:nil otherButtonTitles:@[@"图片"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 2) {
                [self presentViewController:[self produceImagePickerController] animated:YES completion:nil];
            }
        }];
    } else {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"当前已有人文档共享，请等待结束后共享!" icon:nil];
    }
}

- (void)onRTCUserShareOpen:(int)nType withShareInfo:(NSString*)strUserShareInfo withUserId:(NSString *)strUserId withUserData:(NSString*)strUserData{
    //共享开启
    switch (nType) {
        case 1:
        {
            self.shearType = AMSharedTypeDoc;
            [self.tabbar tabBarDidShared:YES];
            // 显示文档共享
            NSDictionary *docDict = [AMCommon fromJsonStr:strUserShareInfo];
            //先置空
            if (self.boardView) {
                if (self.boardView.superview) {
                    [self.boardView removeFromSuperview];
                }
                self.boardView = nil;
            }
            
            AMDocItem *docItem = [[AMDocItem alloc] init];
            docItem.fildId = [docDict objectForKey:@"fileid"];
            docItem.meetingId = [docDict objectForKey:@"meetid"];
            
            docItem.urlArray = [[docDict objectForKey:@"picArray"] copy];
            
            self.boardView = [[AMDocBlockView alloc] initWithDoc:self.userModel withHost:NO withDocItem:docItem];
            __weak typeof(self)weakSelf = self;
            self.boardView.docBlockFial = ^(NSString *errorStr) {
                [weakSelf.meetKit closeUserShare];
            };
            self.boardView.toolShowBlock = ^{
                [weakSelf interfaceAnimation];
            };
            [self.view addSubview:self.boardView];
            [self.view insertSubview:self.boardView aboveSubview:self.horizontalScrollView];
            [self.boardView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
            break;
        case 2:
        {
            self.shearType = AMSharedTypeScreen;
            
            if (!self.sharedView && strUserShareInfo.length != 0) {
                self.sharedView = [AMVideoView loadVideoWithpeerId:@"" pubId:strUserShareInfo size:CGSizeZero];
                [self.view insertSubview:self.sharedView aboveSubview:self.horizontalScrollView];
                self.sharedView.frame = self.view.bounds;
                self.sharedView.localView.frame = self.view.bounds;
                [ASHUD showHUDWithLoadingStyleInView:self.view belowView:nil content:@"正在打开屏幕共享"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ASHUD hideHUD];
                    [self.meetKit setRTCVideoRender:self.sharedView.strPubId andRender:self.sharedView.localView];
                });
                
                //添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(interfaceAnimation)];
                [self.sharedView addGestureRecognizer:tap];
                [self.tabbar tabBarDidShared:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)OnRTCUserShareClose{
    //共享关闭
    if (self.boardView) {
        [self.boardView removeFromSuperview];
        self.boardView = nil;
    } else if (self.shearType == AMSharedTypeScreen && self.sharedView){
        [self.sharedView removeFromSuperview];
        self.sharedView = nil;
    }
    
    [self.topBar.leaveButton setTitle:@"离开" forState:UIControlStateNormal];
    [self.tabbar tabBarDidShared:NO];
    self.shearType = AMSharedTypeNone;
    [self.meetKit setDriveModel:NO];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    // 取消
    [self.meetKit closeUserShare];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.uploadBlock) {
        self.uploadBlock(assets);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    CGFloat toolBarHigh,tabBarY,position;
    kDevice_Is_iPhoneX ? (toolBarHigh = 88) : (toolBarHigh = 64);
    self.isHide ? (position = - toolBarHigh) : (position = 0);
    self.topBar.frame = CGRectMake(0, position, size.width, toolBarHigh);
    
    self.isHide ? (tabBarY = size.height) : (tabBarY = size.height - 49);
    self.tabbar.frame = CGRectMake(0, tabBarY, size.width, 49);
}

// MARK: - class
- (TZImagePickerController *)produceImagePickerController{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.isStatusBarDefault = NO;
    return imagePickerVc;
}

@end
