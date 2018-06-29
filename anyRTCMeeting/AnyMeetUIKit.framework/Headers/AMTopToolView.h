//
//  AMTopToolView.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMTopToolDelegate <NSObject>

@optional

- (void)topBarDidSelectItem:(UIButton *)button;

@end

@interface AMTopToolView : UIView

//标题
@property (strong, nonatomic)  UILabel *titleLabel;
//离开
@property (strong, nonatomic)  UIButton *leaveButton;

@property (nonatomic, weak) id <AMTopToolDelegate> delegate;

- (void)topBarAnimation:(BOOL)hide;

@end
