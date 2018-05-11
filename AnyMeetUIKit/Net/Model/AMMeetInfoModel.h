//
//  AMMeetInfoModel.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meetinginfo :NSObject
// 会议ID
@property (nonatomic , copy) NSString              * meetingid;
// 会议开始时间（时间戳）
@property (nonatomic , copy) NSString              * m_start_time;
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
// 会议名称
@property (nonatomic , copy) NSString              * m_create_at;
// 创建会议着的昵称
@property (nonatomic , copy) NSString              * m_name;
// 连麦会议的分享hls地址
@property (nonatomic , copy) NSString              * m_hls_url;
// 会议权限类型：1:开发；2:密码；3:制定人员
@property (nonatomic , assign) int                 m_limit_type;
// anyRTC号
@property (nonatomic , copy) NSString              * m_anyrtcid;
// 连麦会议的推流地址
@property (nonatomic , copy) NSString              * m_push_url;
// 创建会议着的昵称
@property (nonatomic , copy) NSString              * m_host_name;
// 连麦会议视频清晰度
@property (nonatomic , assign) int                 m_line_quality;
// 连麦会议拉流地址
@property (nonatomic , copy) NSString              * m_pull_url;
// 会议类型
@property (nonatomic , assign) int                 m_type;

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
@property (nonatomic , strong) Meetinginfo              * meetinginfo;
// 邀请人的信息
@property (nonatomic , strong) NSArray<Memberlist *>              * memberlist;
// 本次请求ID
@property (nonatomic , copy) NSString              * requestid;

@end
