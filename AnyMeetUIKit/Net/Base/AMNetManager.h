//
//  AMNetManager.h
//  NetRequest
//
//  Created by derek on 2018/5/4.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMApiCommon.h"


typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FailureBlock)(NSError *error);


@interface AMNetManager : NSObject

+(AMNetManager*)shareInstance;

// 注册成功后，系统给予的用户Id
@property (nonatomic, strong) NSString *anyUserId;

// 配置请求信息
- (void)configNetRequestParameter:(NSString*)strDeveloperId
                        withAppId:(NSString*)strAppId
                       withAppKey:(NSString*)strAppKey
                     withAppToken:(NSString*)strAppToken
                    withVerifyUrl:(NSString*)strVerifyUrl;

//用户对接
- (void)registeredDockingMeeting:(NSString*)userId
                    withNickName:(NSString*)nickName
                     withHeadUrl:(NSString*)headUrl
                         success:(SuccessBlock)successBlock
                         failure:(FailureBlock)failureBlock;

//创建房间
- (void)createMeetingRoom:(NSString*)userId
             withMeetName:(NSString*)meetingName
             withMeetType:(AMMeetType)type
        withMeetStartTime:(NSString*)startTime
             withPassWord:(NSString*)passWord
            withLimitType:(AMMeetLimitType)limitType
    withDefaultPersonList:(NSArray*)personList
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

//删除会议
- (void)deleteMeetingRoom:(NSString*)userId
            withMeetingId:(NSString*)meetingId
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;
//获取会议详情
- (void)getMeetingInfo:(NSString*)userId
         withMeetingId:(NSString*)meetingId
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;
//更新会议时间
- (void)updateMeetingStartTime:(NSString*)userId
                 withMeetingId:(NSString*)meetingId
           withUpdateStartTime:(NSString*)startTime
                       success:(SuccessBlock)successBlock
                       failure:(FailureBlock)failureBlock;
//获取列表
- (void)getUserMeetingList:(NSString*)userId
               withPageNum:(int)pageNum
              withPageSize:(int)pageSize
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;
//邀请参会人员
- (void)inviteMeetingMember:(NSString*)userId
              withMeetingId:(NSString*)meetingId
       withInvitePersonList:(NSArray*)personList
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;
//删除踢出参会人员
- (void)deleteMeetingMember:(NSString*)userId
              withMeetingId:(NSString*)meetingId
       withDeletePersonList:(NSArray*)personList
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock; 
//获取邀请过的参会人员列表
- (void)getInviteMemberList:(NSString*)meetingId
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;
//获取错误码
- (NSString *)getErrorInfoWithCode:(int)nCode;

- (NSString *)getTimestamp;

@end
