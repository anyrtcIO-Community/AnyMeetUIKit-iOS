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

//显示影藏
- (void)tabBarAnimation:(BOOL)hide;

- (void)tabBarDidShared:(BOOL)selected;

@end

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)


- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
