//
//  AMColorMenuView.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMColorMenuView.h"

@interface AMColorMenuView ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressUISlider;
@property (weak, nonatomic) IBOutlet UIButton *redColor;
@property (weak, nonatomic) IBOutlet UIButton *greenColor;
@property (weak, nonatomic) IBOutlet UIButton *blueColor;
@property (weak, nonatomic) IBOutlet UIButton *yellowColor;
@property (weak, nonatomic) IBOutlet UIButton *blackColor;
@property (weak, nonatomic) IBOutlet UIButton *writeColor;


@end

@implementation AMColorMenuView
- (void)dealloc {
    
}

+ (instancetype)loadColorMenuView {
    return [[[NSBundle bundleForClass:self.class] loadNibNamed:@"AMColorMenuView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.6];
    self.progressUISlider.minimumValue = 1;
    self.progressUISlider.maximumValue = 20;
    self.progressUISlider.value = 6;
    self.progressUISlider.minimumTrackTintColor = [AMCommon getColor:@"#01A2FF"];
    self.progressUISlider.maximumTrackTintColor = [UIColor whiteColor];
    self.progressUISlider.thumbTintColor = [AMCommon getColor:@"#01A2FF"];
    
    
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.textColor = [AMCommon getColor:@"#FFFFFF"];
    self.tipLabel.text = [NSString stringWithFormat:@"画笔粗细:(%d)",(int)self.progressUISlider.value];
    
    self.selectedColor = @"#4e91ff";
}

- (void)setSelectedColor:(NSString *)selectedColor {
    _selectedColor = selectedColor;
    if ([selectedColor isEqualToString:@"#ff5050"]) {
        //红色
        self.redColor.selected = YES;
        self.greenColor.selected = NO;
        self.blueColor.selected = NO;
        self.yellowColor.selected = NO;
        self.blackColor.selected = NO;
        self.writeColor.selected = NO;
        
    }else if ([selectedColor isEqualToString:@"#31ff7a"]){
        //绿色
        self.redColor.selected = NO;
        self.greenColor.selected = YES;
        self.blueColor.selected = NO;
        self.yellowColor.selected = NO;
        self.blackColor.selected = NO;
        self.writeColor.selected = NO;
    }else if ([selectedColor isEqualToString:@"#4e91ff"]){
        self.redColor.selected = NO;
        self.greenColor.selected = NO;
        self.blueColor.selected = YES;
        self.yellowColor.selected = NO;
        self.blackColor.selected = NO;
        self.writeColor.selected = NO;
        
    }else if ([selectedColor isEqualToString:@"#ffd133"]){
        self.redColor.selected = NO;
        self.greenColor.selected = NO;
        self.blueColor.selected = NO;
        self.yellowColor.selected = YES;
        self.blackColor.selected = NO;
        self.writeColor.selected = NO;
    }else if ([selectedColor isEqualToString:@"#000000"]){
        self.redColor.selected = NO;
        self.greenColor.selected = NO;
        self.blueColor.selected = NO;
        self.yellowColor.selected = NO;
        self.blackColor.selected = YES;
        self.writeColor.selected = NO;
    }else if ([selectedColor isEqualToString:@"#ffffff"]){
        self.redColor.selected = NO;
        self.greenColor.selected = NO;
        self.blueColor.selected = NO;
        self.yellowColor.selected = NO;
        self.blackColor.selected = NO;
        self.writeColor.selected = YES;
    }
}
- (IBAction)lineWidthEvent:(id)sender {
    UISlider *slider = (UISlider*)sender;
    if (self.lineWidthBlock) {
        self.lineWidthBlock(slider.value);
    }
    self.tipLabel.text = [NSString stringWithFormat:@"画笔粗细:(%d)",(int)self.progressUISlider.value];
}

- (IBAction)doSomeEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 200:
        {
            self.selectedColor = @"#ff5050";
            if (self.selectedColorBlock) {
                self.selectedColorBlock(self.selectedColor);
            }
        }
            break;
        case 201:
        {
            self.selectedColor = @"#31ff7a";
            if (self.selectedColorBlock) {
                self.selectedColorBlock(@"#31ff7a");
            }
        }
            break;
        case 202:
        {
            self.selectedColor = @"#4e91ff";
            if (self.selectedColorBlock) {
                self.selectedColorBlock(@"#4e91ff");
            }
        }
            break;
        case 203:
        {
            self.selectedColor = @"#ffd133";
            if (self.selectedColorBlock) {
                self.selectedColorBlock(@"#ffd133");
            }
        }
            break;
        case 204:
        {
            self.selectedColor = @"#000000";
            if (self.selectedColorBlock) {
                self.selectedColorBlock(@"#000000");
            }
        }
            break;
        case 205:
        {
            self.selectedColor = @"#ffffff";
            if (self.selectedColorBlock) {
                self.selectedColorBlock(@"#ffffff");
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
