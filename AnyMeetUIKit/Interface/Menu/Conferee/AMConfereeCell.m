//
//  AMConfereeCell.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMConfereeCell.h"

@implementation AMConfereeCell{
    UIImageView *_headImageView;  //头像
    
    UILabel *_nameLabel;    //昵称
    
    UIImageView *_audioImageView;
    
    UIImageView *_videoImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeConferee];
    }
    return self;
}

- (void)initializeConferee{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.image = [UIImage imageNamed:@"blue" inBundle:Bundle compatibleWithTraitCollection:nil];
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(45));
    }];
    
    //视频
    _audioImageView = [[UIImageView alloc]init];
    _audioImageView.image = [UIImage imageNamed:@"button_shipin" inBundle:Bundle compatibleWithTraitCollection:nil];
    [self.contentView addSubview:_audioImageView];
    [_audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.height.equalTo(@(30));
        make.centerY.equalTo(self);
    }];
    
    //音频
    _videoImageView = [[UIImageView alloc]init];
    _videoImageView.image = [UIImage imageNamed:@"button_yuyin" inBundle:Bundle compatibleWithTraitCollection:nil];
    [self.contentView addSubview:_videoImageView];
    [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_audioImageView.mas_left).offset(-15);
        make.width.height.equalTo(@(30));
        make.centerY.equalTo(self);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"anyRTC";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headImageView.mas_right).equalTo(@(10));
        make.right.equalTo(self->_videoImageView.mas_left).offset(-10);
        make.centerY.equalTo(self);
    }];
}

- (void)setConfereeModel:(AMConfereeModel *)confereeModel{
    _confereeModel = confereeModel;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:confereeModel.headUrl] placeholderImage:[UIImage imageNamed:@"blue" inBundle:Bundle compatibleWithTraitCollection:nil] options:SDWebImageRetryFailed];
    
    NSString *video = @"";
    NSString *audio = @"";
    confereeModel.video_state ? (video = @"icon_shipin") : (video = @"icon_guanbishipin");
    confereeModel.audio_state ? (audio = @"icon_yinpin") : (audio = @"icon_guanbiyinpin");
    _videoImageView.image = [UIImage imageNamed:video inBundle:Bundle compatibleWithTraitCollection:nil];
    _audioImageView.image = [UIImage imageNamed:audio inBundle:Bundle compatibleWithTraitCollection:nil];
    
    _nameLabel.text = confereeModel.nickName;
}

@end
