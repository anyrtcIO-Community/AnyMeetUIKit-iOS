//
//  AMTopToolView.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMTopToolView.h"
#import "AMCommon.h"

@implementation AMTopToolView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        CGFloat toolBarHigh;
        kDevice_Is_iPhoneX ? (toolBarHigh = 88) : (toolBarHigh = 64);
        
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, toolBarHigh);
        [self initTopTool];
    }
    return self;
}

- (void)initTopTool{
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchCameraButton.tag = 202;
    [switchCameraButton addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setImage:Bundle_IMAGE(@"switch") forState:UIControlStateNormal];
    [self addSubview:switchCameraButton];
    
    self.leaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leaveButton.tag = 201;
    [self.leaveButton addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.leaveButton setTitleColor:[AMCommon getColor:@"#FF4141"] forState:UIControlStateNormal];
    self.leaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leaveButton setTitle:@"离开" forState:UIControlStateNormal];
    [self addSubview:self.leaveButton];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"连接中...";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.titleLabel];
    
    UIButton *spearkerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spearkerButton.tag = 200;
    [spearkerButton addTarget:self action:@selector(doSomethingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [spearkerButton setImage:Bundle_IMAGE(@"icon_扬声器") forState:UIControlStateNormal];
    [spearkerButton setImage:Bundle_IMAGE(@"icon_扬声器关闭") forState:UIControlStateSelected];
    [self addSubview:spearkerButton];
    
    [spearkerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.leaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(spearkerButton);
    }];
    
    [switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(70);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(spearkerButton);
    }];
}

- (void)topBarAnimation:(BOOL)hide{
    CGFloat position,toolBarHigh;
    kDevice_Is_iPhoneX ? (toolBarHigh = 88) : (toolBarHigh = 64);
    hide ? (position = - toolBarHigh) : (position = 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, position, UIScreen.mainScreen.bounds.size.width, toolBarHigh);
        [self layoutIfNeeded];
    }];
}

- (void)doSomethingEvent:(UIButton *)button {
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(topBarDidSelectItem:)]) {
        [self.delegate topBarDidSelectItem:button];
    }
}

@end
