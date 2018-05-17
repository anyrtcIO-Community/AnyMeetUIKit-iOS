//
//  AMPopverView.h
//  LFPopOverView
//
//  Created by derek on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMPopverView;

@protocol AMPopverViewDelegate <NSObject>

@optional
// 消失的回调
- (void)popoverViewDidDismiss:(AMPopverView *)popoverView;

@end

@interface AMPopverView : UIView
{
    CGRect boxFrame;
    CGPoint arrowPoint;
    
    BOOL above;
    
    UIView *parentView;
    UIView *topView;
}
+ (AMPopverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView delegate:(id<AMPopverViewDelegate>)delegate;

#pragma mark - 消失
- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end
