//
//  AMFunctionView.m
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMFunctionView.h"

@implementation AMFunctionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [AMCommons getColor:@"#EBEBEB"];
        NSArray *titleArr = @[@"加入会议",@"安排会议"];
        NSArray *imageArr = @[@"icon_ruhui",@"icon_安排会议"];
        NSArray *highlightArr = @[@"icon_ruhui_选中",@"icon_安排会议_选中"];
        
        UIButton *lastButton;
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.tag = i;
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(functionViewEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitleColor:[AMCommons getColor:@"#888888"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            [button setBackgroundImage:[UIImage imageNamed:@"icon_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
            
            [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:highlightArr[i]] forState:UIControlStateHighlighted];
            
            [self addSubview:button];
            if (!lastButton) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(@(10));
                    make.bottom.equalTo(@(-10));
                }];
                lastButton = button;
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.bottom.equalTo(@(-10));
                    make.top.equalTo(lastButton.mas_top);
                    make.left.equalTo(lastButton.mas_right).offset(5);
                    make.width.equalTo(lastButton.mas_width);
                }];
            }
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:25];
        }
    }
    return self;
}

- (void)functionViewEvent:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(functionEvent:)]) {
        [self.delegate functionEvent:button.tag];
    }
}

@end
