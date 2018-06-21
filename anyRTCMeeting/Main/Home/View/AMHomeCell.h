//
//  AMHomeCell.h
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMHomeCell : UITableViewCell

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//会议主题
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
//AM、PM
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
//会议Id
@property (weak, nonatomic) IBOutlet UILabel *meetIdLabel;

@property (nonatomic, strong) MeetingInfo *listModel;

@end
