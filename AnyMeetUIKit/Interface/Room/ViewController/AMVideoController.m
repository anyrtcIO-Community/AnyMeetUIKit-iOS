//
//  AMVideoController.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMVideoController.h"

@interface AMVideoController()

//scrollView容器
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AMVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.videoArr = [NSMutableArray arrayWithCapacity:6];
    //本地视图
    self.localView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.localView.tag = 1000;
    [self.view addSubview:self.localView];
    
    self.containerView = [[UIView alloc]init];
    self.topBar = [[AMTopToolView alloc] init];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(interfaceAnimation)];
    [self.localView addGestureRecognizer:tap];
}

//普通消息
- (AMInformationModel *)produceTextInfo:(NSString *)name content:(NSString *)content userId:(NSString *)userId icon:(NSString *)headUrl{
    AMInformationModel *model = [[AMInformationModel alloc]init];
    model.t_msg_u_name = name;
    model.t_msg_content = content;
    model.t_msg_userid = userId;
    model.t_msg_u_icon = headUrl;
    return model;
}

//参会人员
- (AMConfereeModel *)produceConferee:(NSString *)name userId:(NSString *)userId peerId:(NSString *)peerId icon:(NSString *)headUrl{
    AMConfereeModel *model = [[AMConfereeModel alloc]init];
    model.nickName = name;
    model.userId = userId;
    model.peerId = peerId;
    model.headUrl = headUrl;
    //默认打开
    model.video_state = 1;
    model.audio_state = 1;
    return model;
}

// MARK: - Transition

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    CGFloat scrollH,padding;
    if (size.width < size.height) {
        scrollH = Video_Height;
        self.isLandscape = NO;
    } else {
        scrollH = Video_Width;
        self.isLandscape = YES;
    }
    
    UIView *largeView = [self.view viewWithTag:1000];
    [largeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if ([largeView isKindOfClass:[AMVideoView class]]) {
        [self makeResolution:[NSMutableArray arrayWithObject:largeView] itemWidth:UIScreen.mainScreen.bounds.size.height itemHeight:UIScreen.mainScreen.bounds.size.width fill:NO];
    }
    
    if (self.shearType == AMSharedTypeScreen && self.sharedView) {
        [self.sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self makeResolution:[NSMutableArray arrayWithObject:self.sharedView] itemWidth:UIScreen.mainScreen.bounds.size.height itemHeight:UIScreen.mainScreen.bounds.size.width fill:NO];
    }
    
    self.isHide ? (padding = 5) : (padding = 54);
    self.horizontalScrollView.frame = CGRectMake(0, size.height - scrollH - padding, size.width, scrollH);
    [self layoutVideoView];
}

// MARK: - layout

- (void)layoutVideoView {
    //4：3  暂定 120 ：90
    CGFloat itemWidth = Video_Width;
    CGFloat itemHeight = Video_Height;
    if (self.isLandscape) {
        itemWidth = Video_Height;
        itemHeight = Video_Width;
    }
    
    [self.videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIView class]]) {
            //移除所有手势
            UIView *video = (UIView *)obj;
            for (UIGestureRecognizer *gesture in video.gestureRecognizers) {
                [video removeGestureRecognizer:gesture];
            }
            
            //scrollView子视图添加切换大屏手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeVideoSize:)];
            [video addGestureRecognizer:tap];
            //标识点击事件
            UIView *singleTapView = [tap view];
            singleTapView.tag = idx;
        }
    }];
    
    //将所video放在scrollView上
    [self makeScrollView:self.horizontalScrollView inViews:self.videoArr LRpadding:5 viewPadding:5 width:itemWidth];
    //根据分辨率显示
    [self makeResolution:self.videoArr itemWidth:itemWidth itemHeight:itemHeight fill:NO];
}

- (void)changeVideoSize:(UITapGestureRecognizer *)tap{
    //当前大视图
    UIView *largeView = [self.view viewWithTag:1000];
    
    //即将切换的视图
    NSInteger tagIndex = [tap view].tag;
    UIView *videoView = self.videoArr[tagIndex];
    videoView.tag = 1000;
    [self.view insertSubview:videoView atIndex:0];
    
    [self switchVideoRender:videoView];
    
    largeView.tag = 0;
    [self.videoArr removeObjectAtIndex:tagIndex];
    [self.videoArr insertObject:largeView atIndex:tagIndex];
    [self layoutVideoView];
}

//变大的视图
- (void)switchVideoRender:(UIView *)videoView{
    //remake
    [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //消除切换大小屏事件
    for (UIGestureRecognizer *gesture in videoView.gestureRecognizers) {
        [videoView removeGestureRecognizer:gesture];
    }
    
    //添加tabbar的显示事件
    UITapGestureRecognizer *tabBarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(interfaceAnimation)];
    [videoView addGestureRecognizer:tabBarTap];
    
    //按分辨率显示大视图
    if ([videoView isKindOfClass:[AMVideoView class]]) {
        [self makeResolution:[NSMutableArray arrayWithObject:videoView] itemWidth:UIScreen.mainScreen.bounds.size.width itemHeight:UIScreen.mainScreen.bounds.size.height fill:NO];
    }
}

// 根据分辨率显示，防止拉伸压缩
- (void)makeResolution:(NSMutableArray *)videoArr itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight fill:(BOOL)isFill{
    
    [videoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[AMVideoView class]]) {
            AMVideoView *video = (AMVideoView *)obj;
            [self videoAccordingSize:video itemWidth:itemWidth itemHeight:itemHeight fill:NO];
        }
        
        if ([obj isKindOfClass: [UIView class]]) {
            UIView *video = (UIView *)obj;
            video.clipsToBounds = YES;
        }
    }];
}

// isFill  默认NO，根据需求选择填充方式
- (void)videoAccordingSize:(AMVideoView *)video itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight fill:(BOOL)isFill{
    CGFloat sizeW = video.videoSize.width;
    CGFloat sizeH = video.videoSize.height;
    
    if (sizeW != 0 && sizeH != 0) {
        if (!isFill) {
            //--------------------------- 不填充，根据videoSize----------------------------------------
            video.backgroundColor = [UIColor blackColor];
            if (sizeW > sizeH) {
                CGFloat height = itemWidth * sizeH/sizeW;
                
                if (height > itemHeight * 0.7) {
                    //若大于总高度0.7,则说明边距很小，可填充
                    [self videoAccordingSize:video itemWidth:itemWidth itemHeight:itemHeight fill:YES];
                    return;
                }
                
                [video addSubview:video.localView];
                [video.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(video);
                    make.height.equalTo(video.mas_width).multipliedBy(sizeH/sizeW);
                    make.center.equalTo(video);
                }];
            } else {
                
                CGFloat width = itemHeight * sizeW/sizeH;
                
                if (width > itemWidth * 0.7) {
                    //若大于总宽度0.7,则说明边距很小，则填充
                    [self videoAccordingSize:video itemWidth:itemWidth itemHeight:itemHeight fill:YES];
                    return;
                }
                
                [video.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(video);
                    make.width.equalTo(video.mas_height).multipliedBy(sizeW/sizeH);
                    make.center.equalTo(video);
                }];
            }
        } else {
            //-------------------------- 根据videoSize扩充填充---------------------------
            CGFloat value0 = 0;
            CGFloat value1 = 0;
            
            //固定高填充宽
            if (itemHeight * sizeW/sizeH > itemWidth) {
                value0 = (itemHeight * sizeW/sizeH) * itemHeight;
            }
            
            //固定宽填充高
            if (itemWidth * sizeH/sizeW > itemHeight) {
                value1 = (itemWidth * sizeH/sizeW) * itemWidth;
            }
            
            [video addSubview:video.localView];
            
            //取面积小的进行扩充
            if ((value0 > value1 && value1 != 0) || value0 == 0){
                //固定宽填充高
                [video.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(video);
                    make.height.equalTo(video.mas_width).multipliedBy(sizeH/sizeW);
                    make.center.equalTo(video);
                }];
            } else {
                //固定高填充宽
                [video.localView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(video);
                    make.width.equalTo(video.mas_height).multipliedBy(sizeW/sizeH);
                    make.center.equalTo(video);
                }];
            }
            
        }
        video.clipsToBounds = YES;
    }
}

//scrollView横向排列
- (void)makeScrollView:(UIScrollView *)scrollView inViews:(NSArray *)views LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding width:(CGFloat)viewWidth{
    if (views.count != 0) {
        [scrollView addSubview:self.containerView];
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.height.equalTo(scrollView);
        }];
        
        __block UIView *lastView;
        
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                UIView *videoView = (UIView *)obj;
                [self.containerView addSubview:videoView];
                
                [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.and.bottom.equalTo(self.containerView);
                    make.width.equalTo(@(viewWidth));
                    
                    if (lastView){
                    make.left.mas_equalTo(lastView.mas_right).offset(viewPadding);
                    } else {
                        make.left.mas_equalTo(LRpadding);
                    }
                }];
                
                lastView = videoView;
            }
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(lastView.mas_right).offset(LRpadding);
        }];
    }
}

//5s隐藏
- (void)hideControlDelay{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTabBarAnimation) object:nil];
    [self performSelector:@selector(hideTabBarAnimation) withObject:nil afterDelay:5];
}

- (void)hideTabBarAnimation{
    [self.tabbar tabBarAnimation:YES];
    [self.topBar topBarAnimation:YES];
    self.isHide = YES;
    self.index = 0;
}

- (void)interfaceAnimation{
    if (self.index == 0 && self.isHide) {
        //显示
        self.isHide = NO;
        [self.tabbar tabBarAnimation:NO];
        [self.topBar topBarAnimation:NO];
        [self hideControlDelay];
        self.index ++;
    } else {
        //隐藏
        [self hideTabBarAnimation];
    }
}

// MARK: - 监听tabbar

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isHide"]) {
        CGFloat padding,scrollH;
        ([[change valueForKey:@"new"] boolValue]) ? (padding = 5) : (padding = 54);
        self.isLandscape ? (scrollH = Video_Width) : (scrollH = Video_Height);
        [UIView animateWithDuration:0.3 animations:^{
            self.horizontalScrollView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - padding - scrollH, UIScreen.mainScreen.bounds.size.width, scrollH);
            [self.horizontalScrollView layoutIfNeeded];
        }];
    }
    
    if (self.shearType == AMSharedTypeDoc || self.shearType == AMSharedTypeMySelfDoc) {
        BOOL is = [[change valueForKey:@"new"] boolValue];
        
        NSNumber *isShow = [NSNumber numberWithBool:is];
        [NSNotificationCenter.defaultCenter postNotificationName:@"Notification_Hidden_Or_Show_Tool" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:isShow,@"isShow", nil]];
    }
}

// MARK: - 提示音

- (void)playRemindMusic{
    self.player = nil;
    NSError *errors = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&errors];
    //获取音频路径
    NSArray *arr = [[NSBundle bundleForClass:self.class] pathsForResourcesOfType:@"mp3" inDirectory:@"/AnyMeetUIKit.bundle"];
    if (arr.count == 1) {
        NSURL *tempUrl = [NSURL fileURLWithPath:arr[0]];
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:tempUrl error:&error];
        self.player.delegate = self;
        self.player.numberOfLoops = 0;
        [self.player prepareToPlay];
        [self.player play];
    }
}

// MARK: - 懒加载

- (UIScrollView *)horizontalScrollView{
    if (!_horizontalScrollView) {
        CGFloat scrollH,padding;
        self.isLandscape ? (scrollH = Video_Width) : (scrollH = Video_Height);
        self.isHide ? (padding = 5) : (padding = 55);
        
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - padding - scrollH, UIScreen.mainScreen.bounds.size.width, scrollH)];
        _horizontalScrollView.showsHorizontalScrollIndicator  = NO;
        [self.view insertSubview:_horizontalScrollView belowSubview:self.topBar];
    }
    return _horizontalScrollView;
}

- (AVAudioPlayer *)player{
    AVAudioPlayer *_player = objc_getAssociatedObject(self, &"player");
    if (!_player) {
        objc_setAssociatedObject(self, &"player",_player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _player;
}

- (void)setPlayer:(AVAudioPlayer *)player{
    objc_setAssociatedObject(self, &"player", player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// MARK: - other

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)dealloc{
    if (self.tabbar) {
        [self.tabbar removeObserver:self forKeyPath:@"isHide"];
    }
}

@end
