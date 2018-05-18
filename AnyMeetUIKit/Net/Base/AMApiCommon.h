//
//  AMApiCommon.h
//  AnyApiManager
//
//  Created by derek on 2018/5/11.
//  Copyright © 2018年 derek. All rights reserved.
//

#ifndef AMApiCommon_h
#define AMApiCommon_h

// 会议类型
typedef NS_ENUM(NSInteger,AMMeetType) {
    AMMeetTypeNomal = 1,     // 交流会议
    AMMeetTypeTerminal = 2,  // 终端会议
};

// 会议限制类型
typedef NS_ENUM(NSInteger,AMMeetLimitType) {
    AMMeetLimitOpenType = 0,     // 开发会议
    AMMeetLimitPassWordType = 1, // 密码会议
    AMMeetLimitDefaultPersonType = 2, // 内定人员会议
};

typedef NS_ENUM(NSInteger,AMErrorCode) {
    AM_No_User_Error = 100004,                  // 用户不存在
    AM_Register_User_Error = 100005,            // 用户注册失败
    AM_Meeting_No_Exist_Error = 100013,         // 会议室不存在
    AM_Meeting_Pass_Error = 100014,             // 会议室密码错误
    AM_Meeting_Start_Time_Error = 100017,       // 会议开始时间不能小于当前时间
    AM_Database_Error = 400001,                 // 数据库异常
    AM_Paramter_Lose_Error = 400002,            // 数据参数缺失
    AM_Paramter_Format_Error = 400003,          // 据参数格式不正确
    AM_Paramter_NoRule_Error = 400004,          // 数据参数不符合系统规则
    AM_Paramter_LengthExceed_Error = 400005,    // 数据参数超出系统规范长度
    AM_List_Error_Error = 400006,               // 列表为空
    AM_Visit_Server_Error = 500000,             // 服务器访问失败
    AM_Visit_Api_Often_Error = 500001,          // 接口访问频繁
    AM_Update_Data_Error = 600001,              // 数据更新失败
    AM_Exit_Person_List_Error = 600002,         // 会议成员已经存在于会议列表中
    AM_Invite_Member_NotExist_Error = 600003,   // 邀请人员不存在
    AM_Verify_Sign_Error = 700001,              // 验证签名失败
    AM_Verify_AnyRTC_Info_Error = 800001,       // 验证anyRTC信息失败
    AM_Visit_AnyRTC_Network_Error = 800002,     // 访问anyRTC网站信息失败
    AM_AnyRTC_AccountArrears_Error = 800003,    // anyRTC 账户欠费
    AM_Visit_CallBack_Url_Error = 800004,       // 访问Teameeting模块回调地址失败
    AM_Init_AnyRTC_Info_Error = 800005,         // 初始化用户信息失败
    AM_Visit_AnyRTC_Api_TimeOut_Error = 800006, // 用户接口访问时间戳大于60秒
};

#endif /* AMApiCommon_h */
