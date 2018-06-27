//
//  AMConfereeController.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTMeetEngine/RTMeetKit.h>

@interface AMConfereeController : UIViewController

//参会者
@property (nonatomic, strong) NSMutableArray *memberArr;
//普通消息
@property (nonatomic, strong) NSMutableArray *infoArr;

@property (nonatomic, strong) RTMeetKit *meetKit;

@property (nonatomic, strong) AMUserModel *userModel;

@property (nonatomic, strong) MeetingInfo *meetModel;

@property (nonatomic, assign) BOOL isHoster;

@property (nonatomic, assign) BOOL isLandscape;

@end
