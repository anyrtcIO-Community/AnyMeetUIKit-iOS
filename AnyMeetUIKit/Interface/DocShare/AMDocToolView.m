//
//  AMDocToolView.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMDocToolView.h"

@interface AMDocToolView()

@end

@implementation AMDocToolView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.penButton setImage:Bundle_IMAGE(@"button_huabi_weixuanzhong") forState:UIControlStateNormal];
    [self.penButton setImage:Bundle_IMAGE(@"button_huabi_xuanzhong") forState:UIControlStateSelected];
    [self.lineButton setImage:Bundle_IMAGE(@"button_zhixian_weixuanzhong") forState:UIControlStateNormal];
    [self.lineButton setImage:Bundle_IMAGE(@"button_zhixian_xuanzhong") forState:UIControlStateSelected];
    [self.colorButton setImage:Bundle_IMAGE(@"button_secai_weixuanzhong") forState:UIControlStateNormal];
    [self.colorButton setImage:Bundle_IMAGE(@"button_secai_xuanzhong") forState:UIControlStateSelected];
    [self.revokeButton setImage:Bundle_IMAGE(@"button_chexiao_weixuanzhong") forState:UIControlStateNormal];
    [self.revokeButton setImage:Bundle_IMAGE(@"button_chexiao_xuanzhong") forState:UIControlStateHighlighted];
    [self.clearButton setImage:Bundle_IMAGE(@"button_cachu_weixuanzhong") forState:UIControlStateNormal];
    [self.clearButton setImage:Bundle_IMAGE(@"button_cachu_xuanzhong") forState:UIControlStateHighlighted];
    //默认选中
    self.penButton.selected = YES;
}

- (IBAction)doSomeEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    switch (button.tag) {
        case 200:
        {
            self.lineButton.selected = NO;
            self.revokeButton.selected = NO;
            self.clearButton.selected = NO;
            //钢笔
            if (self.drawBlock) {
                self.drawBlock(PencilButtonType);
            }
        }
            break;
        case 201:
        {
            self.penButton.selected = NO;
            self.revokeButton.selected = NO;
            self.clearButton.selected = NO;
            //直线
            if (self.drawBlock) {
                self.drawBlock(ArrowsLineButtonType);
            }
            
        }
            break;

        case 202:
        {
            //颜色
            if (self.drawBlock) {
                self.drawBlock(DrawColorLineSelectedType);
            }
        }
            break;

        case 203:
        {
            //撤销
            if (self.drawBlock) {
                self.drawBlock(RemoveButtonType);
            }
        }
            break;
        case 204:
        {
            //清空
            if (self.drawBlock) {
                self.drawBlock(ClearButtonType);
            }
        }
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
