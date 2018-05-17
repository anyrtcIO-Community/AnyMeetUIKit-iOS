//
//  AMDocToolView.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ButtonType) {
    PencilButtonType = 0,// 铅笔动画
    ArrowsLineButtonType,// 箭头直线
    DrawColorLineSelectedType,// 颜色选择
    RemoveButtonType,    // 撤销动作
    ClearButtonType,    // 清空动作
    
};

@interface AMDocToolView : UIView

@property (weak, nonatomic) IBOutlet UIButton *penButton;
@property (weak, nonatomic) IBOutlet UIButton *lineButton;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UIButton *revokeButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;


typedef void(^DrawTypeBlcok)(ButtonType type);
@property (nonatomic, copy) DrawTypeBlcok drawBlock;


@end
