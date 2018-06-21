//
//  AMHomeCell.m
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMHomeCell.h"

@implementation AMHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(MeetingInfo *)listModel{
    self.topicLabel.text = listModel.m_name;
    self.topicLabel.textColor = [AMCommons getColor:@"#666666"];
    self.meetIdLabel.textColor = [AMCommons getColor:@"#aaaaaa"];
    
    self.meetIdLabel.text = [NSString stringWithFormat:@"会议ID：%@",listModel.meetingid];
    if (listModel.m_start_time > 0) {
        self.timeLabel.text = [AMCommons transformTimeStampString:listModel.m_start_time formate:@"HH:mm"];
        self.timeLabel.textColor = [AMCommons getColor:@"#666666"];
        
        NSInteger index = [[self.timeLabel.text substringToIndex:2] integerValue];
        index > 12 ? (self.tipLabel.text = @"PM") : (self.tipLabel.text = @"AM");
    }
}

@end
