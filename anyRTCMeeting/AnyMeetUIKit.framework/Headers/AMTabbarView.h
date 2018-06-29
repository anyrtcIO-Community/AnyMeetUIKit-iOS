//
//  AMTabbarView.h
//  RTMPCDemo
//
//  Created by jh on 2018/4/28.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMTabBarDelegate <NSObject>

@optional

- (void)tabBardidSelectItem:(UIButton *)button;

@end

@interface AMTabbarView : UIView

@property (nonatomic, weak) id <AMTabBarDelegate> delegate;

@property (nonatomic, assign) BOOL isHide;

//显示隐藏
- (void)tabBarAnimation:(BOOL)hide;

- (void)tabBarDidShared:(BOOL)selected;

@end
