//
//  AMTabbarView.m
//  RTMPCDemo
//
//  Created by jh on 2018/4/28.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "AMTabbarView.h"

@implementation AMTabbarView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 49, UIScreen.mainScreen.bounds.size.width, 49);
        [self initializeTabBar];
    }
    return self;
}

- (void)tabBarAnimation:(BOOL)hide{
    CGFloat position;
    
    hide ? (position = UIScreen.mainScreen.bounds.size.height) : (position =UIScreen.mainScreen.bounds.size.height - 49);
    self.isHide = hide;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, position, UIScreen.mainScreen.bounds.size.width, 49);
        [self layoutIfNeeded];
    }];
}

- (void)initializeTabBar{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [AMCommon makeEqualWidthViews:[self productTabBarItem] inView:self LRpadding:0 viewPadding:0];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
        }
    }];
}

- (void)tabBarDidSelectItem:(UIButton *)button{
    if (button.tag == 0 || button.tag == 1) {
        button.selected = !button.selected;
        button.selected ? ([button setTitleColor:[AMCommon getColor:@"#00A1FF"] forState:UIControlStateSelected]) : ([button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]);
    }
    
    if ([self.delegate respondsToSelector:@selector(tabBardidSelectItem:)]) {
        [self.delegate tabBardidSelectItem:button];
    }
}

- (void)tabBarDidShared:(BOOL)selected{
    UIButton *button = [self viewWithTag:2];
    if (selected) {
        [button setImage:Bundle_IMAGE(@"switch_screen") forState:UIControlStateNormal];
        [button setTitle:@"屏幕切换" forState:UIControlStateNormal];
        [button setTitleColor:[AMCommon getColor:@"#00A1FF"] forState:UIControlStateNormal];
    } else {
        [button setImage:Bundle_IMAGE(@"document_share") forState:UIControlStateNormal];
        [button setTitle:@"文档共享" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
}


- (NSArray <UIButton *>*)productTabBarItem{
    
    NSArray *titleArr = @[@"关闭语音",@"关闭视频",@"文档共享",@"参会人员",@"更多"];
    NSArray *imageArr = @[@"open_audio",@"open_video",@"document_share",@"conferee",@"more"];
    NSArray *selectedArr = @[@"close_audio",@"close_video",@"document_share",@"conferee",@"more"];
    NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:5];
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:Bundle_IMAGE(imageArr[i]) forState:UIControlStateNormal];
        [button setImage:Bundle_IMAGE(selectedArr[i]) forState:UIControlStateSelected];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(tabBarDidSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [itemArr addObject:button];
    }
    return itemArr;
}

@end
