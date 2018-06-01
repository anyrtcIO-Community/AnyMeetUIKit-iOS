//
//  AMMeetListModel.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingInfo :NSObject
// 会议ID
@property (nonatomic , copy) NSString              * meetingid;
// 会议开始时间
@property (nonatomic , copy) NSString              * m_start_time;
// 会议支撑的最大人员数量（可在后台配置）
@property (nonatomic , copy) NSString              * m_max_number;
// 会议是否上锁
@property (nonatomic , assign) BOOL                m_is_lock;
// 会议默认清晰度
@property (nonatomic , assign) int                 m_quality;
// 创建会议的用户ID(用户注册后，在anyRTC平台里的ID)
@property (nonatomic , copy) NSString              * m_userid;
// 会议密码
@property (nonatomic , copy) NSString              * m_password;
// 会议视频编码格式
@property (nonatomic , copy) NSString              * m_avcodec;
// 会议创建时间
@property (nonatomic , copy) NSString              * m_create_at;
// 会议名称
@property (nonatomic , copy) NSString              * m_name;
// 会议权限类型：1:开发；2:密码；3:制定人员
@property (nonatomic , assign) int                 m_limit_type;
// anyRTC号
@property (nonatomic , copy) NSString              * m_anyrtcid;
// 连麦会议视频清晰度
@property (nonatomic , assign) int                 m_line_quality;
// 会议类型
@property (nonatomic , assign) int                 m_type;

@end

@interface AMMeetListModel :NSObject
// 当前时间
@property (nonatomic , copy) NSString              * currenttime;
// 响应吗
@property (nonatomic , assign) int                 code;
// 相应提示内容（可忽略）
@property (nonatomic , copy) NSString              * message;
// 本次请求ID
@property (nonatomic , copy) NSString              * requestid;
// 会议总数量
@property (nonatomic , assign) int                 total_number;
// 会议列表数组
@property (nonatomic , strong) NSArray<MeetingInfo *>              * meetinglist;

@end


@interface Memberlist :NSObject
// 用户自己平台的ID
@property (nonatomic , copy) NSString              * mem_anyrtc_openid;
// 用户注册anyRTC后给予的ID
@property (nonatomic , copy) NSString              * mem_userid;
// 用户头像
@property (nonatomic , copy) NSString              * mem_icon;
// 用户昵称
@property (nonatomic , copy) NSString              * mem_nickname;

@end


@interface AMMeetInfoModel :NSObject
// 响应吗
@property (nonatomic , assign) int                 code;
// 相应提示内容（可忽略）
@property (nonatomic , copy) NSString              * message;
//　会议详情model
@property (nonatomic , strong) MeetingInfo              * meetinginfo;
// 邀请人的信息
@property (nonatomic , strong) NSArray<Memberlist *>              * memberlist;
// 本次请求ID
@property (nonatomic , copy) NSString              * requestid;

@end
