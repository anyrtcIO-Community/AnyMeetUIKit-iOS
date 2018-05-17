//
//  AMInformationCell.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMInformationModel.h"

@interface AMInformationCell : UITableViewCell

- (void)updateInfoModel:(AMInformationModel *)infoModel userId:(NSString *)userId;

@end
