//
//  AMVideoController.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTabbarView.h"
#import "AMTopToolView.h"
#import "AMInformationModel.h"
#import "AMConfereeModel.h"
#import "AMVideoView.h"

typedef NS_ENUM(NSInteger,AMSharedType) {
    AMSharedTypeNone = 0,
    AMSharedTypeDoc = 1,
    AMSharedTypeScreen = 2,
    AMSharedTypeMySelfDoc = 3
};

@interface AMVideoController : UIViewController<AMTabBarDelegate,AMTopToolDelegate>

@property (nonatomic, strong) UIView *localView;

//参会者
@property (nonatomic, strong) NSMutableArray *videoArr;

//底部scrollview
@property (nonatomic, strong) UIScrollView *horizontalScrollView;

//头部
@property (nonatomic, strong) AMTopToolView *topBar;

//底部工具栏
@property (nonatomic, strong) AMTabbarView *tabbar;

//横竖屏
@property (nonatomic, assign) BOOL isLandscape;

//显示隐藏
@property (nonatomic, assign) BOOL isHide;

//共享流
@property (nonatomic, strong) AMVideoView *sharedView;

//分享类型
@property (nonatomic, assign) AMSharedType shearType;

//普通消息
- (AMInformationModel *)produceTextInfo:(NSString *)name content:(NSString *)content userId:(NSString *)userId icon:(NSString *)headUrl;

//参会人员
- (AMConfereeModel *)produceConferee:(NSString *)name userId:(NSString *)userId peerId:(NSString *)peerId icon:(NSString *)headUrl;

// 根据分辨率显示，防止拉伸压缩
- (void)makeResolution:(NSMutableArray *)videoArr itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight fill:(BOOL)isFill;

//videoView变大的视图
- (void)switchVideoRender:(UIView *)videoView;

//layout
- (void)layoutVideoView;

//显示隐藏
- (void)interfaceAnimation;

//5s隐藏
- (void)hideControlDelay;

//入会提示音
- (void)playRemindMusic;

@end
