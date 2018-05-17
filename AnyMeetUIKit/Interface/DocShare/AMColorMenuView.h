//
//  AMColorMenuView.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMColorMenuView : UIView

+ (instancetype)loadColorMenuView;

@property (nonatomic, strong) NSString *selectedColor;

//颜色
typedef void(^DidSelectedColorBlock)(NSString *colorStr);
@property (nonatomic, copy) DidSelectedColorBlock selectedColorBlock;

//画笔
typedef void(^DidSelectedLineBlock)(int lineWidth);
@property (nonatomic, copy) DidSelectedLineBlock lineWidthBlock;

@end
