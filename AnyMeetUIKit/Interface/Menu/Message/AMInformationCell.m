//
//  AMInformationCell.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMInformationCell.h"

@implementation AMInformationCell{
    
    UIImageView *_iconImageView; //头像
    
    UILabel *_infoLabel;    //消息
    
    UIView *_containerView;  //消息容器
    
    UILabel *_nameLabel; //名字
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [AMCommon getColor:@"#F2F4F6"];
        [self initializeMessage];
    }
    return self;
}

- (void)initializeMessage{
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.image = Bundle_IMAGE(@"blue");
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 20;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:8];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_nameLabel];
    
    _containerView = [[UIView alloc]init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 5;
    _containerView.clipsToBounds = YES;
    [self.contentView addSubview:_containerView];
    
    _infoLabel = [[UILabel alloc]init];
    _infoLabel.numberOfLines = 0;
    _infoLabel.font = [UIFont systemFontOfSize:14];
    [_containerView addSubview:_infoLabel];
}

- (void)updateInfoModel:(AMInformationModel *)infoModel userId:(NSString *)userId{
    CGFloat messageX = CGRectGetWidth(UIScreen.mainScreen.bounds)/2.0;
    NSLog(@"%@",Bundle);
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.t_msg_u_icon] placeholderImage:Bundle_IMAGE(@"blue") options:SDWebImageRetryFailed];
    _nameLabel.text = infoModel.t_msg_u_name;
    //富文本
    NSString *info = [Base64Generater DecoderWithBase64:infoModel.t_msg_content];
    CGFloat lineSpace = 3.0;
    NSNumber *textLengthSpace  = @0.25;
    NSDictionary *attribute = [AMCommon setTextLineSpaceWithString:info withFont:[UIFont systemFontOfSize:14] withLineSpace:lineSpace  withTextlengthSpace:textLengthSpace paragraphSpacing:0];
    _infoLabel.attributedText = [[NSAttributedString alloc] initWithString:info attributes:attribute];
    
    if (![infoModel.t_msg_userid isEqualToString:userId]) {
        _infoLabel.textColor = [UIColor blackColor];
        _containerView.backgroundColor = [UIColor whiteColor];
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(20);
            make.width.height.equalTo(@40);
        }];
        
        [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_iconImageView.mas_right).offset(10);
            make.top.equalTo(self->_iconImageView .mas_top);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.width.lessThanOrEqualTo(@(messageX));
        }];
        
    } else {
        _infoLabel.textColor = [UIColor whiteColor];
        _containerView.backgroundColor = [AMCommon getColor:@"#2797FF"];
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.width.height.equalTo(@(40));
        }];
        
        [_containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->_iconImageView.mas_left).offset(-10);
            make.top.equalTo(self->_iconImageView.mas_top);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.width.lessThanOrEqualTo(@(messageX));
        }];
    }
    
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self->_iconImageView);
        make.top.equalTo(self->_iconImageView.mas_bottom);
        make.height.equalTo(@(15));
        //less
        //make.bottom.mas_lessThanOrEqualTo(self->_containerView.mas_bottom);
    }];
    
    [_infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->_containerView).insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
}


@end
