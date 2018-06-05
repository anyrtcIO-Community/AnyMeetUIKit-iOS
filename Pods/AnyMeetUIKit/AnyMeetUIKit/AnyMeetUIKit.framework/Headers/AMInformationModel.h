//
//  AMInformationModel.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMInformationModel : NSObject

//聊天信息
@property (nonatomic, copy) NSString *t_msg_content;
//用户名
@property (nonatomic, copy) NSString *t_msg_u_name;
//头像
@property (nonatomic, copy) NSString *t_msg_u_icon;
//用户id
@property (nonatomic, copy) NSString *t_msg_userid;
//消息时间
@property (nonatomic, assign) NSInteger t_msg_create_at;

@end
