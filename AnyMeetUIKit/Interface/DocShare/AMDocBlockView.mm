//
//  AMDocBlockView.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMDocBlockView.h"
#import <AVFoundation/AVFoundation.h>

#import <AnyBoardEngine/AnyBoardEngine.h>
#import "AMDocToolView.h"

//颜色
#import "AMPopverView.h"
#import "AMColorMenuView.h"

extern NSString *GetDevelopId();

extern NSString *GetAppId();

extern NSString *GetAppKey();

extern NSString *GetAppToken();

extern NSString *GetVerifyUrl();

@implementation AMDocItem

@end

@interface AMDocBlockView()<AnyBoardViewDelegate,AMPopverViewDelegate>
{
    AMPopverView *popView;
    UITapGestureRecognizer *tapGesture;
}
//画板
@property (nonatomic, strong) AnyBoardView *boardView;
//画笔类型
@property (nonatomic, assign) JQDrawingType drawType;
//左右按钮
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
//工具栏按钮
@property (nonatomic, strong) UIButton *tooButton;
//工具栏
@property (nonatomic, strong) AMDocToolView *toolView;
//是否是主持人
@property (nonatomic, assign) BOOL isHost;
//状态
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation AMDocBlockView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithDoc:(AMUserModel*)userModel withHost:(BOOL)docHost withDocItem:(AMDocItem*)docItem {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.isHost = docHost;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
        //画板页面
        AnyBoardOption *option = [[AnyBoardOption alloc] init];
        option.strDeveloperId = GetDevelopId();
        option.strAppId = GetAppId();
        option.strKey = GetAppKey();
        option.strToken = GetAppToken();
        option.strFileId = docItem.fildId;
        option.strMeetingId = docItem.meetingId;
        option.userId = userModel.userId;
        option.isHost = docHost;
        option.boardBgColor = [UIColor blackColor];
        
        self.boardView = [[AnyBoardView alloc] initWithFrame:CGRectZero withOption:option withImageUrlArray:docItem.urlArray withDelegate:self];
        [self addSubview:self.boardView];
        [self sendSubviewToBack:self.boardView];
        
        [self initUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenOrShowTool:) name:@"Notification_Hidden_Or_Show_Tool" object:nil];
    }
    return self;
}
- (void)layoutSubviews {
    NSLog(@"layoutSubviews");
    
    CGRect localAspectRatio = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGSize defaultAspectRatio;
    if (self.frame.size.width>self.frame.size.height) {
        defaultAspectRatio = CGSizeMake(4, 3);
    }else{
        defaultAspectRatio = CGSizeMake(3, 4);
    }
    CGRect localVideoFrame = AVMakeRectWithAspectRatioInsideRect(defaultAspectRatio, localAspectRatio);
    if (!CGRectEqualToRect(localVideoFrame, self.boardView.frame)) {
         self.boardView.frame = localVideoFrame;
    }
}
- (void)handleRotation:(NSNotification *)notification {
    //收到通知隐藏工具栏以及弹出框
    if (popView) {
        [popView dismiss];
    }
}

- (void)initUI {
    
    if (self.isHost) {
        [self addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@25);
            make.height.equalTo(@50);
        }];
        [self addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.equalTo(@25);
            make.height.equalTo(@50);
        }];
    }
    
    [self addSubview:self.tooButton];
    [self.tooButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-20);
        make.width.height.equalTo(@50);
    }];
    
    [self addSubview:self.toolView];
    [self insertSubview:self.toolView belowSubview:self.tooButton];
    
    //根据显示比例
    BOOL is5SLater =  [UIScreen mainScreen].bounds.size.width > 320;
    if (is5SLater) {
        [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@300);
            make.height.equalTo(@36);
            make.left.equalTo(self.tooButton.mas_right).offset(-24);
            make.centerY.equalTo(self.tooButton.mas_centerY);
        }];
    }else{
        [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@248);
            make.height.equalTo(@36);
            make.left.equalTo(self.tooButton.mas_right).offset(-24);
            make.centerY.equalTo(self.tooButton.mas_centerY);
        }];
    }
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview: self.activityView];
//    self.activityView.color = [UIColor redColor]; // 改变圈圈的颜色为红色； iOS5引入
    [self.activityView startAnimating]; // 开始旋转
    [self.activityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowOrDismiss)];
    [self addGestureRecognizer:tapGesture];
}

- (void)hiddenOrShowTool:(NSNotification*)notification {
    
    NSDictionary *dict = [notification userInfo];
    NSNumber *num = [dict objectForKey:@"isShow"];
    
    CGFloat padding;
    ([num isEqualToNumber:[NSNumber numberWithBool:NO]]) ? (padding = 60) : (padding = 20);
    [self.tooButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-padding);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)tapShowOrDismiss {
    if (self.toolShowBlock) {
        self.toolShowBlock();
    }
}

#pragma mark - AnyBoardViewDelegate
//文档初始化成功
- (void)initBoardScuess {
    [self.activityView stopAnimating];
}
//文档初始化失败
- (void)initBoardFaild:(int)nCode {
    [self.activityView stopAnimating];
    if (self.docBlockFial) {
        self.docBlockFial([self getErrorCode:nCode]);
    }
}
//文档共享主持人翻到了那一页
- (void)anyBoardPageChange:(int)currentPage withTotalPage:(int)totalPage withImageUrl:(NSString*)imageUrl{
     [self showOrDismissLeftOrRightButton:currentPage withAllPage:totalPage];
}
//自己翻页页码变化回调
- (void)anyBoardPageChangeByMe:(int)currentPage withTotalPage:(int)totalPage withImageUrl:(NSString*)imageUrl{
     [self showOrDismissLeftOrRightButton:currentPage withAllPage:totalPage];
}
//文档是否可编辑
- (void)onBoardEditable:(BOOL)editable {
    
}
//文档添加了一页
- (void)onBoardAddScuess {
    
}
//文档删除了一页
- (void)onBoardDeleteScuess {
    
}
//文档销毁了
- (void)onBoardDestoryScuess {
    
}
#pragma mark - AMPopverViewDelegate
- (void)popoverViewDidDismiss:(AMPopverView *)popoverView {
    if (popView) {
        _toolView.colorButton.selected = NO;
        popView = nil;
    }
}
#pragma mark - button event
- (void)showOrDismissLeftOrRightButton:(int)pageNum withAllPage:(int)allPage{
    if (!self.isHost) {
        return;
    }
    //判断是否显示隐藏按钮
    if (pageNum == 1) {
        self.leftButton.hidden = YES;
        if (pageNum == allPage) {
            self.rightButton.hidden = YES;
        }else{
            self.rightButton.hidden = NO;
        }
    }else if (pageNum == allPage){
        self.rightButton.hidden = YES;
        if (pageNum>1) {
            self.leftButton.hidden = NO;
        }
    }else{
        self.rightButton.hidden = NO;
        self.leftButton.hidden = NO;
    }
}

- (void)leftButtonEvent:(UIButton *)sender {
    if (self.boardView) {
        [self.boardView lastPage];
    }
}
- (void)rightButtonEvent:(UIButton *)sender {
    if (self.boardView) {
        [self.boardView nextPage];
    }
}
- (void)tooButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _toolView.hidden = NO;
        tapGesture.enabled = NO;
    }else{
        _toolView.hidden = YES;
        tapGesture.enabled = YES;
    }
    if (self.boardView) {
        [self.boardView setMyBoardCanEdit:sender.selected];
    }
}
- (void)showColorMenu {
    
    AMColorMenuView *colorView = [AMColorMenuView loadColorMenuView];
    colorView.frame = CGRectMake(0, 0, 300, 100);
    colorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    colorView.selectedColor = self.boardView.drawColor;
    __weak typeof(self)weakSelf = self;
    //颜色
    colorView.selectedColorBlock = ^(NSString *colorStr) {
        if (weakSelf.boardView) {
            weakSelf.boardView.drawColor = colorStr;
        }
    };
    //画笔粗细
    colorView.lineWidthBlock = ^(int lineWidth) {
        if (weakSelf.boardView) {
            weakSelf.boardView.lineWidth = lineWidth;
        }
    };
    CGPoint point = [self convertPoint:CGPointMake(self.toolView.colorButton.center.x, self.toolView.colorButton.center.y-15) fromView:self.toolView];
    //颜色
    popView = [AMPopverView showPopoverAtPoint:point inView:self withContentView:colorView delegate:self];
    
}
#pragma mark - get
- (AMDocToolView*)toolView {
    if (!_toolView) {
       
        if (self.isHost) {
            _toolView = [[[NSBundle bundleWithPath:Bundle_Path] loadNibNamed:@"AnyMeetUIKit.bundle/AMDocToolView" owner:self options:nil] lastObject];
        }else{
            _toolView = [[[NSBundle bundleWithPath:Bundle_Path] loadNibNamed:@"AnyMeetUIKit.bundle/AMDocToolGuestView" owner:self options:nil] lastObject];
        }
        _toolView.hidden = YES;
        __weak typeof(self)weakSelf = self;
        _toolView.drawBlock = ^(ButtonType type) {
            switch (type) {
                case PencilButtonType:
                    {
                        weakSelf.drawType = JQDrawingTypeGraffiti;
                    }
                    break;
                case ArrowsLineButtonType:
                {
                    weakSelf.drawType = JQDrawingTypeArrow;
                }
                    break;
                case DrawColorLineSelectedType:
                {
                    [weakSelf showColorMenu];
                }
                    break;
                case RemoveButtonType:
                {
                    if (weakSelf.boardView) {
                        [weakSelf.boardView removeLastStroke];
                    }
                }
                    break;
                case ClearButtonType:
                {
                    if (weakSelf.boardView) {
                        [weakSelf.boardView clearBoard];
                    }
                }
                    break;
                default:
                    break;
            }
        };
        _toolView.userInteractionEnabled = YES;
        _toolView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
        _toolView.layer.cornerRadius = 18;
        _toolView.layer.masksToBounds = YES;
        _toolView.layer.borderWidth = .5;
        _toolView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _toolView;
}
- (UIButton*)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setBackgroundImage:Bundle_IMAGE(@"left_sliding") forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setBackgroundImage:Bundle_IMAGE(@"right_sliding") forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIButton *)tooButton {
    if (!_tooButton) {
        _tooButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tooButton setBackgroundImage:Bundle_IMAGE(@"drawing_open") forState:UIControlStateSelected];
        [_tooButton setBackgroundImage:Bundle_IMAGE(@"drawing_close") forState:UIControlStateNormal];
        [_tooButton addTarget:self action:@selector(tooButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tooButton;
}
- (NSString*)getErrorCode:(int)nCode {
    
    switch (nCode) {
        case 201:
        {
            return @"登录信息已经过期";
        }
            break;
        case 202:
        {
            return @"白板初始化出错，开发者信息错误";
        }
            break;
        case 203:
        {
            return @"开发者账号已欠费";
        }
            break;
        case 206:
        {
            return @"开发者未开启该功能";
        }
            break;
        case 3000:
        {
            return @"初始化参数不正确";
        }
            break;
        default:
            return @"未知错误";
            break;
    }
}

@end
